#!/usr/bin/fish
# === kernel building ===

function set-build
    set -g BUILD_FOLDER "$argv"
end

#find $LINUX_SRC_PATH/*_build -maxdepth 0 | head -n1

abbr -a mk 'make CC="ccache gcc -fdiagnostics-color -O0" -j8 O=$BUILD_FOLDER'
#abbr -a mmd 'make modules CC="ccache gcc -fdiagnostics-color" -j8 O=$BUILD_FOLDER'
abbr -a gg 'git grep'
abbr -a glg 'git log --grep='
alias gitline='git log --oneline'

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

function set-arch
    set -g ARCH "$argv"
    set -g ARCH_BUILD "$argv-build"
end

abbr -a mcr 'COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross -j4 ARCH=$ARCH O=$ARCH_BUILD'
abbr -a menu 'make menuconfig O=$BUILD_FOLDER'

# === vm management ===

function set-img
    if echo "$argv" | grep -q '^/'
        set -g IMG_FILE "$argv"
    else
        set -g IMG_FILE (pwd)"/$argv"
    end
    set -g IMG_PATH (echo $IMG_FILE | sed -e 's/\(.*\)\/.*$/\1/')
end

function install-mods
    set MNT_FOLDER $IMG_PATH/mnt
    mountpoint $MNT_FOLDER || echorun sudo mount $IMG_FILE $MNT_FOLDER

    wait_for_mount $MNT_FOLDER

    pwd | grep -q 'linux$' || echo "entering directory '$HOME/shared/linux'" && pushd $HOME/shared/linux

    echorun sudo make -j8 O=$BUILD_FOLDER \
    INSTALL_HDR_PATH=$MNT_FOLDER/usr INSTALL_MOD_PATH=$MNT_FOLDER \
    headers_install modules_install

    dirs > /dev/null && echo "leaving directory '"(pwd)"'" && popd

    echorun sudo umount $MNT_FOLDER
end

abbr -a qx86a 'qemu-system-x86_64 \
    -boot order=a -drive file=$IMG_FILE,format=raw,if=virtio \
    -kernel $LINUX_SRC_PATH/$BUILD_FOLDER/arch/x86_64/boot/bzImage \
    -append "root=/dev/vda rw console=ttyS0 nokaslr loglevel=7 raid=noautodetect audit=0 cpuidle_haltpoll.force=1" \
    -enable-kvm -m 4G -smp 4 -cpu host \
    -nic user,hostfwd=tcp::2222-:22,smb=$HOME/shared -s \
    -nographic \
    && stty sane'

#-fsdev local,id=fs1,path=/home/tonyk/codes,security_model=none \
#-device virtio-9p-pci,fsdev=fs1,mount_tag=$HOME/shared \

function default_set --no-scope-shadowing
    if set -q argv[2]
        set $argv[1] $argv[2]
    else
        set $argv[1] $argv[3]
    end
end

function echorun
    echo "\$ $argv"
    eval $argv
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
    default_set disk_name $argv[2] 'arch_disk.vm'

    set extra_packs "vim fish git rustup strace gdb dhcpcd openssh cifs-utils samba"
    #set xforwarding_packs 'xorg-xauth xorg-xclock xorg-fonts-type1'

    set all_packs "$extra_packs"

    echorun truncate -s $disk_space $disk_name
    test $status != 0 && return 1
    echorun mkfs.ext4 $disk_name
    test $status != 0 && return 1

    test -d mnt || echorun mkdir mnt
    echorun sudo mount $disk_name mnt
    test $status != 0 && echorun sudo umount mnt && return 1

    wait_for_mount

    echorun sudo pacstrap -c mnt base base-devel $all_packs
    test $status != 0 && echorun sudo umount mnt && return 1

    # configure ssh
    echorun sudo cp ~/.ssh/id_rsa.pub mnt/root/
    test $status != 0 && echorun sudo umount mnt && return 1

    # copy bootstrap script
    echorun sudo cp $HOME/scripts/start.sh mnt/root/
    echorun sudo cp $HOME/scripts/smb.conf mnt/root/
    test $status != 0 && echorun sudo umount mnt && return 1

    # remove root passwd
    sudo arch-chroot mnt/ sh -c "echo 'root:xx' | chpasswd"

    echorun sudo umount mnt

    echorun set-img $disk_name
end
