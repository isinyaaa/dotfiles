#!/bin/bash

# create a user
useradd -m user -G wheel
echo "[Unit]
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
WantedBy=multi-user.target" > /etc/systemd/system/home-user-shared.mount

echo "username=user
password=meow" > .cifs

mkdir /home/user/shared
[ -d /etc/samba ] || mkdir /etc/samba
cp smb.conf /etc/samba/smb.conf

services="sshd dhcpcd smb home-user-shared.mount"
systemctl enable $services --now

mkdir .ssh
cat id_rsa.pub > .ssh/authorized_keys

mkdir "/etc/systemd/system/serial-getty@.service.d"

echo '[Service]
ExecStart=
ExecStart=-/usr/bin/agetty --autologin root --noclear %I $TERM' >> "/etc/systemd/system/serial-getty@.service.d/override.conf"

mkdir /home/user/.ssh
cat id_rsa.pub > /home/user/.ssh/authorized_keys
echo "fish" >> /home/user/.bashrc
echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# fill the fstab
#echo "#shared_folder /home/user/codes 9p trans=virtio 0 0" >> /etc/fstab
echo "//10.0.2.4/qemu         /home/user/shared  cifs    uid=1000,credentials=/root/.cifs,x-systemd.automount,noperm 0 0 " >> /etc/fstab

reboot
