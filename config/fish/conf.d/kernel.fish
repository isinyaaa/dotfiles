# === kernel building ===

function set-build
    set -g BUILD_FOLDER "$argv"
end

abbr -a mk 'make CC="ccache gcc -fdiagnostics-color" -j8 O=$BUILD_FOLDER'
#abbr -a mmd 'make modules CC="ccache gcc -fdiagnostics-color" -j8 O=$BUILD_FOLDER'

# === output management ===

function clean-output
    default_set INPUT_FILE $argv[1] 'modules1'
    default_set SEARCH $argv[2] 'gpu.*amd'

    if not set -q BUILD_FOLDER; and not set -q argv[3]
        return 2
    end

    default_set IO_PATH $argv[3] "$BUILD_FOLDER"

    set FILE $IO_PATH/$INPUT_FILE

    # clear possible CLI menuconfig output
    set LAST_LINE (grep -nm2 'GEN\s*Makefile' $FILE".log" | tail -n1 | cut -d: -f1)
    sed -e "1,"$LAST_LINE"d" $FILE".log" | grep -v '^\s\s[A-Z]' |\
        grep -B1 -A5 $SEARCH > $FILE".clean.log"
end

function error-count
    default_set INPUT_FILE $argv[1] 'modules1'
    default_set SEARCH $argv[2] 'gpu.*amd'

    if not set -q BUILD_FOLDER; and not set -q argv[3]
        return 2
    end

    default_set IO_PATH $argv[3] "$BUILD_FOLDER"

    set FILE $IO_PATH/$INPUT_FILE

    # clear possible CLI menuconfig output
    set LAST_LINE (grep -nm2 'GEN\s*Makefile' $FILE".log" | tail -n1 | cut -d: -f1)
    sed -e "1,"$LAST_LINE"d" $FILE".log" | grep -v '^\s\s[A-Z]' |\
        grep $SEARCH | wc -l
end

function set-arch
    set -g ARCH "$argv"
    set -g ARCH_BUILD "$argv-build"
end

abbr -a mcr 'COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross -j4 ARCH=$ARCH O=$ARCH_BUILD'
abbr -a menu 'make menuconfig -j O=$BUILD_FOLDER'

# === vm management ===

function install-mods
    set img_name $argv[1]
    set MNT_FOLDER "$IMG_PATH/mnt"
    mountpoint "$MNT_FOLDER" || echorun sudo mount "$img_name" "$MNT_FOLDER"

    wait_for_mount "$MNT_FOLDER"

    pwd | grep -q 'linux$' || echo "entering directory '$HOME/shared/linux'" && pushd "$HOME"/shared/linux

    echorun sudo make -j8 O="$BUILD_FOLDER" \
        INSTALL_HDR_PATH="$MNT_FOLDER"/usr INSTALL_MOD_PATH="$MNT_FOLDER" \
        headers_install modules_install

    dirs > /dev/null && echo "leaving directory '"(pwd)"'" && popd

    echorun sudo umount $MNT_FOLDER
end

abbr -a qx86a qemu_x86_64

function qemu_x86_64
    set img_name $argv[1]
    default_set mem_amount $argv[2] 4G
    if test $IS_MAC = true
        set cpuvar qemu64
    else
        set cpuvar host
    end

    if test -n "$BUILD_FOLDER"
        qemu-system-x86_64 \
            -boot order=a -drive file="$img_name",format=qcow2,if=virtio \
            -kernel "$LINUX_SRC_PATH/$BUILD_FOLDER"/arch/x86_64/boot/bzImage \
            -append "root=/dev/vda rw console=ttyS0 nokaslr loglevel=7 raid=noautodetect audit=0 cpuidle_haltpoll.force=1" \
            # -fsdev local,id=fs1,path=$HOME/shared,security_model=none \
            # -device virtio-9p-pci,fsdev=fs1,mount_tag=$HOME/shared
            -m "$mem_amount" -smp 4 -cpu "$cpuvar" \
            -nic user,hostfwd=tcp::2222-:22,smb="$HOME"/shared -s \
            -nographic
    else
        qemu-system-x86_64 \
            -accel tcg -m "$mem_amount" -smp 4 -cpu "$cpuvar" \
            -nic user,hostfwd=tcp::2222-:22,smb="$HOME"/shared -s \
            "$img_name"
    end

end

abbr -a qaa qemu_aarch64

function qemu_aarch64
    set img_name $argv[1]
    default_set mem_amount $argv[2] 4G

    if test $IS_MAC = true
        set cpuvar cortex-a72
    else
        set cpuvar host
        set accelvar ",accel=hvf,highmem=off"
    end

    eval qemu-system-aarch64 -L ~/bin/qemu/share/qemu \
         -smp 8 \
         -machine virt"$accelvar" \
         -cpu "$cpuvar" -m "$mem_amount" \
         "-drive if=pflash,media=disk,file=$HOME/vms/setup/UEFI/flash"{"0.img,id=drive0","1.img,id=drive1"}",cache=writethrough,format=raw" \
         -drive if=none,file="$HOME/vms/$img_name.qcow2",format=qcow2,id=hd0 \
         -device virtio-scsi-pci,id=scsi0 \
         -device scsi-hd,bus=scsi0.0,drive=hd0,bootindex=1 \
         -nic user,model=virtio-net-pci,hostfwd=tcp::2222-:22,smb="$HOME"/shared \
         '-device virtio-'{rng,balloon,keyboard,mouse,serial,tablet}-device \
         -object cryptodev-backend-builtin,id=cryptodev0 \
         -device virtio-crypto-pci,id=crypto0,cryptodev=cryptodev0 \
         -nographic
end

function default_set --no-scope-shadowing
    if set -q argv[2]
        set $argv[1] $argv[2]
    else
        set $argv[1] $argv[3]
    end
end

function echorun
    if test $argv[1] = '-e'
        echo "\$ $argv[2..-1]" >&2
        eval $argv[2..-1]
    else
        echo "\$ $argv"
        eval $argv
    end
end

function wait_for_mount
    default_set MNT_FOLDER $argv[1] 'mnt'

    for i in (seq 100)
        sleep 1
        mountpoint $MNT_FOLDER > /dev/null && break
    end
end

function create-vm
    default_set disk_space $argv[1] '8G'
    default_set disk_name $argv[2] 'arch_disk'

    set extra_packs "vim fish git rustup strace gdb dhcpcd openssh cifs-utils samba"
    #set xforwarding_packs 'xorg-xauth xorg-xclock xorg-fonts-type1'

    set all_packs "$extra_packs"

    echorun truncate -s "$disk_space" "$disk_name.img"
    test $status != 0 && return 1
    echorun mkfs.ext4 $disk_name
    test $status != 0 && return 1

    test -d mnt || echorun mkdir mnt
    echorun sudo mount "$disk_name" mnt
    test $status != 0 && echorun sudo umount mnt && return 1

    wait_for_mount

    echorun sudo pacstrap -c mnt base base-devel "$all_packs"
    test $status != 0 && echorun sudo umount mnt && return 1

    # configure ssh
    echorun sudo cp ~/.ssh/id_rsa.pub mnt/root/
    test $status != 0 && echorun sudo umount mnt && return 1

    # copy bootstrap script
    echorun sudo cp "$HOME"/scripts/start.sh mnt/root/
    echorun sudo cp "$HOME"/scripts/smb.conf mnt/root/
    test $status != 0 && echorun sudo umount mnt && return 1

    # remove root passwd
    sudo arch-chroot mnt/ sh -c "echo 'root:xx' | chpasswd"

    echorun sudo umount mnt

    echorun qemu-convert -O qcow2 "$disk_name.img" "$disk_name.qcow2"
end
