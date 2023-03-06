# needed env vars
set -gx LINUX_SRC_PATH "$HOME/shared/linux"
set -gx VM_PATH "$HOME/vms"

# === kernel building ===

function set-build
    # the build is relative to the linux source path
    set -g BUILD_FOLDER "$argv"

    # == aliases ==
    abbr -a mk make CC=\"ccache gcc -fdiagnostics-color\" -j(nproc) O=$BUILD_FOLDER
    abbr -a menu make menuconfig -j O=$BUILD_FOLDER

    # == functions ==
    # install modules to the system
    # $1: kernel name
    function local-install-mods
        default_set kernel_name $argv[1] $BUILD_FOLDER

        # first, we build the kernel
        echorun make CC=\"ccache gcc -fdiagnostics-color\" -j(nproc) O=$BUILD_FOLDER
        # then, we install the modules
        echorun sudo make -j(nproc) O=$BUILD_FOLDER INSTALL_HDR_PATH=/usr headers_install modules_install

        # if we are not on aarch64, we need to update the boot config
        if ! uname -r | grep -q aarch64
            echorun sudo cp -v $BUILD_FOLDER/arch/x86_64/boot/bzImage /boot/vmlinuz-$kernel_name
            echorun sudo mkinitcpio -P
            echorun sudo grub-mkconfig -o /boot/grub/grub.cfg
        end
    end

    # install modules to a vm
    # $1: vm name
    function vm-install-mods
        set img_name "$argv[1]"

        set MNT_FOLDER "$VM_PATH/mnt"

        # convert qcow2 to raw
        echorun qemu-img convert -O raw "$VM_PATH/$img_name.qcow2" "$VM_PATH/$img_name.raw"
        # mount the image
        mountpoint "$MNT_FOLDER" &&\
            echorun sudo umount "$MNT_FOLDER"

        echorun sudo mount "$VM_PATH/$img_name.raw" "$MNT_FOLDER"

        wait_for_mount "$MNT_FOLDER"

        # as we don't have subshells, we need to pushd and popd manually
        if ! pwd | grep -q 'linux$'
            echo "entering directory '$HOME/shared/linux'"
            pushd "$HOME"/shared/linux || exit
        end

        # now, we build the kernel
        echorun make CC=\"ccache gcc -fdiagnostics-color\" -j(nproc) O=$BUILD_FOLDER
        # then, we install the modules
        echorun sudo make -j(nproc) O="$BUILD_FOLDER" \
            INSTALL_HDR_PATH="$MNT_FOLDER"/usr INSTALL_MOD_PATH="$MNT_FOLDER" \
            headers_install modules_install

        echo "leaving directory '"(pwd)"'" &&\
            popd

        echorun sudo umount $MNT_FOLDER

        # convert raw back to qcow2
        echorun qemu-img convert -O qcow2 "$VM_PATH/$img_name.raw" "$VM_PATH/$img_name.qcow2"
    end

    # == OBSOLETE ==
    # clean kernel compilation output for clearing warnings on a given path
    function clean-output
        default_set INPUT_FILE $argv[1] 'modules1'
        default_set SEARCH $argv[2] 'gpu.*amd'
        default_set FILE $argv[3]/$INPUT_FILE $BUILD_FOLDER/$INPUT_FILE

        # clear possible CLI menuconfig output
        set LAST_LINE (grep -nm2 'GEN\s*Makefile' $FILE".log" | tail -n1 | cut -d: -f1)
        sed -e "1,"$LAST_LINE"d" $FILE".log" | grep -v '^\s\s[A-Z]' |\
            grep -B1 -A5 $SEARCH > $FILE".clean.log"
    end

    function error-count
        default_set INPUT_FILE $argv[1] 'modules1'
        default_set SEARCH $argv[2] 'gpu.*amd'
        default_set FILE $argv[3]/$INPUT_FILE $BUILD_FOLDER/$INPUT_FILE

        # clear possible CLI menuconfig output
        set LAST_LINE (grep -nm2 'GEN\s*Makefile' $FILE".log" | tail -n1 | cut -d: -f1)
        sed -e "1,"$LAST_LINE"d" $FILE".log" | grep -v '^\s\s[A-Z]' |\
            grep $SEARCH | wc -l
    end
end

# cross-compilation functions
function set-arch
    set -g ARCH "$argv"

    # we set the build folder to the arch name
    set-build "$argv-build"

    if uname -r | grep -q aarch64
        # OBSOLETE: cross-compilation never worked properly on aarch64
        abbr -a mcr COMPILER_INSTALL_PATH='$HOME'/x-tools/x86_64-unknown-linux-gnu/bin/x86_64-unknown-linux-gnu- make ARCH=x86_64 O=$BUILD_FOLDER -j(nproc)
    else
        abbr -a mcr COMPILER_INSTALL_PATH='$HOME'/0day COMPILER=gcc-11.2.0 make.cross ARCH=$ARCH O=$BUILD_FOLDER -j(nproc)
    end
end

# === vm management ===

abbr -a qxa qemu_x86_64

function qemu_x86_64
    set img_name $argv[1]
    set extension ""
    set format ""
    echo "$img_name" | cut -d'.' -f 2 | grep -q raw
    if test "$status" = 0
        set format ,format=raw
    else
        set extension .qcow2
    end
    default_set mem_amount $argv[2] 4G
    if test $IS_MAC = true
        set cpuvar qemu64
    else
        set cpuvar host
        set accelvar '-enable-kvm'
    end

    if test -n "$BUILD_FOLDER"
        eval qemu-system-x86_64 \
            -boot order=a -drive file="$VM_PATH/$img_name$extension"$format,if=virtio \
            -kernel "$LINUX_SRC_PATH/$BUILD_FOLDER"/arch/x86_64/boot/bzImage \
            -append \"root=/dev/vda rw console=ttyS0 nokaslr loglevel=7 raid=noautodetect audit=0 cpuidle_haltpoll.force=1\" \
            # -fsdev local,id=fs1,path=$HOME/shared,security_model=none \
            # -device virtio-9p-pci,fsdev=fs1,mount_tag=$HOME/shared
            -m "$mem_amount" -smp 4 -cpu "$cpuvar" "$accelvar" \
            -nic user,hostfwd=tcp::2222-:22,smb="$HOME"/shared -s \
            -nographic
    else
        eval qemu-system-x86_64 \
            -m "$mem_amount" -smp 4 -cpu "$cpuvar" "$accelvar" \
            -nic user,hostfwd=tcp::2222-:22,smb="$HOME"/shared -s \
            -boot order=a -drive file="$VM_PATH/$img_name$extension"$format,if=virtio
    end

end

abbr -a qaa qemu_aarch64

function qemu_aarch64
    set img_name "$argv[1].qcow2"
    default_set mem_amount $argv[2] 4G

    if test $IS_MAC = true
        default_set cpuvar $argv[3] host
        set accelvar ",accel=hvf"
    else
        default_set cpuvar $argv[3] cortex-a72
    end

    eval qemu-system-aarch64 -L ~/bin/qemu/share/qemu \
         -machine virt"$accelvar" \
         -cpu "$cpuvar" -smp 8 -m "$mem_amount" \
         "-drive if=pflash,media=disk,file=$HOME/vms/setup/UEFI/flash"{"0.img,id=drive0","1.img,id=drive1"}",cache=writethrough,format=raw" \
         -drive if=none,file="$VM_PATH/$img_name",format=qcow2,id=hd0 \
         # -virtfs local,mount_tag=fs1,path=$HOME/shared,security_model=none \
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
