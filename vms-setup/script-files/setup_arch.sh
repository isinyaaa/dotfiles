#!/bin/bash

main() {
    set -e
    set -x
    disk_size=$1
    disk_name=$2
    mountpoint /mnt && umount -R /mnt
    ls "*.img" && {
	kpartx -d "*.img"
	rm -rf "*.img"
    }

    truncate -s "$disk_size" "$disk_name"
    gdisk "$disk_name" << EOF
o
Y
n


+256M
ef00
n




w
Y
EOF
    kpartx -av "$disk_name"
    loopdev="$(losetup -a | grep "/$disk_name" |\
	sed 's,/dev/\(.*\): .*,\1,' |\
	sort -t p -k 2n -n | tail -n1)"
    efivol=/dev/mapper/"$loopdev"p1
    rootvol=/dev/mapper/"$loopdev"p2
    mkfs.vfat "$efivol"
    echo "Y" | mkfs.ext4 "$rootvol"
    mount "$rootvol" /mnt
    mkdir /mnt/boot
    mount "$efivol" /mnt/boot
    bsdtar -xpf ArchLinuxARM-aarch64-latest.tar.gz -C /mnt
    cp start_aarch64.sh /mnt/root/
    cp smb.conf /mnt/root/
    cp id*.pub /mnt/root/
    exp='s,.*="\(.*\)",\1,'
    efiuuid="$(blkid "$efivol" -s UUID | sed "$exp")"
    rootuuid="$(blkid "$rootvol" -s UUID | sed "$exp")"
    echo "
UUID=$efiuuid	/boot	vfat	defaults	0 0
UUID=$rootuuid	/	ext4	defaults	0 0" > /mnt/etc/fstab
    echo "Image root=UUID=$rootuuid rw initrd=\\initramfs-linux.img" \
	> /mnt/boot/startup.nsh

    umount /mnt/boot
    umount /mnt
    kpartx -d "$disk_name"
    sync
    mv "$disk_name" images/
}

main "$@"
