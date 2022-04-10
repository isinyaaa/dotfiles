#!/usr/bin/env bash

main() {
    if [ "$BUILD" = true ]; then
	build
    fi

    if [ "$RUN" = true ]; then
	run
    fi
}

build() {
    set -e
    set -x
    (
	cd "$HOME"/vms/setup
	if [[ "$RECYCLE" != true || ! -f "$HOME/vms/$img_name.img" ]]; then
	    docker build -t alarm_build:latest .
	    docker ps -a | grep -q alarm && docker rm alarm
	    docker run --name=alarm --privileged -it -v "$HOME"/vms:/images alarm_build ./setup_arch.sh "$img_size" "$img_name.img" -d
	fi
	qemu-img convert -O qcow2 "$HOME"/vms/{"$img_name.img","$img_name.qcow2"}
	[ -e UEFI/flash0.img ] || (
	    cd UEFI
	    wget "https://raw.githubusercontent.com/qemu/qemu/master/pc-bios/edk2-aarch64-code.fd.bz2"
	    bzip2 -d edk2-aarch64-code.fd.bz2
	    truncate -s 64M flash0.img
	    truncate -s 64M flash1.img
	    dd if=edk2-aarch64-code.fd of=flash0.img conv=notrunc
	)
	./new_vm.ext "$img_name.qcow2"
    )
}

run() {
    qemu-system-aarch64 -L ~/bin/qemu/share/qemu \
         -smp 8 \
         -machine virt,accel=hvf,highmem=off \
         -cpu cortex-a72 -m 4096 \
         -drive "if=pflash,media=disk,id=drive0,file=$HOME/vms/setup/UEFI/flash0.img,cache=writethrough,format=raw" \
         -drive "if=pflash,media=disk,id=drive1,file=$HOME/vms/setup/UEFI/flash1.img,cache=writethrough,format=raw" \
         -drive if=none,file="$HOME/vms/$img_name.qcow2",format=qcow2,id=hd0 \
         -device virtio-scsi-pci,id=scsi0 \
         -device scsi-hd,bus=scsi0.0,drive=hd0,bootindex=1 \
         -nic user,model=virtio-net-pci,hostfwd=tcp::2222-:22,smb="$HOME"/shared \
         -device virtio-rng-device -device virtio-balloon-device -device virtio-keyboard-device \
         -device virtio-mouse-device -device virtio-serial-device -device virtio-tablet-device \
         -object cryptodev-backend-builtin,id=cryptodev0 \
         -device virtio-crypto-pci,id=crypto0,cryptodev=cryptodev0 \
         -nographic
}

BUILD=false
RUN=false
RECYCLE=false
img_name=new_arch
img_size=10G

while [[ "$#" -gt 0 ]]; do
    case "$1" in
	--run)
	    RUN=true
	    shift
	    ;;
	--build)
	    BUILD=true
	    shift
	    ;;
	--recycle)
	    RECYCLE=true
	    shift
	    ;;
	*)
	    if [[ "$1" =~ \d*[MG] ]]; then
		img_size=$1
	    elif [[ "$1" =~ \S* ]]; then
		img_name=${1%.*}
	    else
		echo "Invalid option: $1"
		exit 22
	    fi
	    shift
	    ;;
    esac
done

main
