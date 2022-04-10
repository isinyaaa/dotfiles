#!/bin/bash

# setup keyring
pacman-key --init
pacman-key --populate archlinuxarm

# download packages
sed -i 's,#Parallel.*,ParallelDownloads = 30,' /etc/pacman.conf
pacman -Syu efibootmgr git rustup bc fish base-devel sudo vim openssh samba strace gdb cifs-utils --noconfirm

# setup bootloader
uuid=$(blkid /dev/sda2 -s UUID | sed 's,.*="\(.*\)",\1,')
efibootmgr --disk /dev/sda --part 1 --create --label "Arch Linux ARM" --loader /Image --unicode "root=UUID=$uuid rw initrd=/initramfs-linux.img" --verbose

# setup non-root user
useradd -mg users -G wheel user
echo 'user:meow' | chpasswd
chsh -s "$(which fish)"
chsh -s "$(which fish)" user
mkdir -p /{home/user,root}/.config/fish
echo 'export TERM=xterm-256color' > /home/user/.config/fish/config.fish
echo 'export TERM=xterm-256color' > /root/.config/fish/config.fish

echo '[Unit]
Description=Mount Share at boot
Requires=systemd-networkd.service
After=network-online.target
Wants=network-online.target

[Mount]
What=//10.0.2.4/qemu
Where=/home/user/shared
Options=vers=3.0,x-systemd.automount,_netdev,x-systemd.device-timeout=10,uid=1000,noperm,credentials=/root/.cifs
Type=cifs
TimeoutSec=30

[Install]
WantedBy=multi-user.target' > /etc/systemd/system/home-user-shared.mount

echo "username=user
password=meow" > .cifs

mkdir /home/user/shared
[ -d /etc/samba ] || mkdir /etc/samba
cp smb.conf /etc/samba/smb.conf

# setup ssh
mkdir .ssh
cat id*.pub > .ssh/authorized_keys
sed -i 's/#\(PasswordAuthentication\).*/\1 yes/' /etc/ssh/sshd_config

mkdir "/etc/systemd/system/serial-getty@.service.d"

echo '[Service]
ExecStart=
ExecStart=-/usr/bin/agetty --autologin root --noclear %I $TERM' >> "/etc/systemd/system/serial-getty@.service.d/override.conf"

mkdir /home/user/.ssh
cat id_ed25519.pub > /home/user/.ssh/authorized_keys

echo "fish" >> /home/user/.bashrc
echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
echo "user ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers


# fill the fstab
#echo "#shared_folder /home/user/codes 9p trans=virtio 0 0" >> /etc/fstab
echo "//10.0.2.4/qemu         /home/user/shared  cifs    uid=1000,credentials=/root/.cifs,x-systemd.automount,noperm 0 0" >> /etc/fstab

services=(sshd smb home-user-shared.mount)
systemctl enable "${services[@]}"

rm ./*
