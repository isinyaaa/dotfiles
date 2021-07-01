# ar{ch,t}guide

## Sumário

- [ar{ch,t}guide](#archtguide)
  - [Sumário](#sumário)
  - [Conectar à internet](#conectar-à-internet)
  - [Particionamento](#particionamento)
    - [Particionamento vanilla](#particionamento-vanilla)
    - [Particionamento em btrfs](#particionamento-em-btrfs)
  - [Instalando o Linux itself](#instalando-o-linux-itself)
  - [Configuração da instalação](#configuração-da-instalação)
  - [Ligando a besta](#ligando-a-besta)
    - [Alguns programas Vanilla](#alguns-programas-vanilla)

```sh
loadkeys br-abnt2
```

Vamos testar se existe a pasta `/sys/firmware/efi/efivars`

```sh
ls /sys/firmware/efi/efivars
```

- Se existir algo nessa pasta:
    **tente EFI boot**
- Caso contrário
    **BIOS boot**

```sh
fdisk -l
```

- Caso **disklabel** type seja **mbr**:

    Eu só posso recomendar que você busque por conta, pois não tenho experiência com isso.

    >  Uma alternativa fácil (porém longe do ideal) é formatar o disco. Caso queira fazer isso seguem os comandos:
    >
    > ```sh
    > dd if=/dev/zero of=/dev/sda bs=4096 status=progress
    > gdisk /dev/sda
    > n
    > +1M
    > ef02
    > w
    > ```

- Para **disklabel type: gpt** basta seguir em frente

## Conectar à internet

---

```sh
rfkill unblock all
```

Seguem os métodos em ordem de dificuldade

1. Cabo LAN:

    Conecte um cabo de rede lan
    > pronto? provavelmente sim!

2. Utilizando o cartão de rede do seu sistema:

    ```sh
    iwctl
    station wlan0 connect _nome-da-sua-rede_
    # digite a senha da rede
    ^D
    ```

3. Utilizando a internet do seu celular:
    1. Conecte o celular
    2. Ative a ancoragem no aparelho (_tethering_)
    3. Execute:

    ```sh
    ip link show
    ip link set _CEL_ up
    dhcpcd -h _CEL_
    ```

> Utilize o comando `ping` para testar sua rede. I.e.
>
> ```sh
> ping -c 1 google.com
> ```

```sh
timedatectl set-ntp true
fdisk -l
```

## Particionamento

---

Vou chamar seu disco primário por `_pdisk_`

```sh
fdisk /dev/_pdisk_
```

Lista de comandos

cmd | função
:-: | :-
`d` | deletar partição
`n` | nova partição
`t` | mudar tipo da partição (4 para BIOS boot e 19 para swap)
`p` | mostrar partições
`w` | para salvar
`q` | para cancelar

### Particionamento vanilla

> teremos 4 partições

1. BIOS boot com 256M
    - Denotada por `_devboot_`
1. padrão com 30 ~ 50G (será nosso /)
    - Denotada por `_devslash_`
1. swap
    - Denotada por `_devswap_`
1. resto do disco para /home
    - Denotada por `_devhome_`

```sh
mkfs.fat -F32 _devboot_
mkfs.ext4 _devslash_
mkfs.ext4 _devhome_
mkswap _devswap_
mount _devslash_ /mnt
mkdir /mnt/{boot,home}
mount _devhome_ /mnt/home
```

- para **BIOS boot**

    ```sh
    mount _devboot_ /mnt/boot
    ```

- para **EFI boot**

    ```sh
    mkdir /mnt/boot/efi
    mount _devboot_ /mnt/boot/efi
    ```

```sh
swapon _devswap_
```

> confira se montou tudo corretamente utilizando o `lsblk`

### Particionamento em btrfs

> teremos somente uma partição

1. `linux filesystem` com tudo

    TODO

## Instalando o Linux itself

- Para hardware mais novo

    ```sh
    pacstrap /mnt base base-devel linux linux-firmware linux-headers man-db man-pages
    ```

- para hardware mais antigo (ou para uma experiência mais estável)

    ```sh
    pacstrap /mnt base base-devel linux-firmware linux-lts linux-lts-headers linux-lts-docs
    ```

## Configuração da instalação

```sh
genfstab -U -p /mnt >> /mnt/etc/fstab
```

Agora vamos entrar no sistema

```sh
arch-chroot /mnt
timedatectl set-timezone America/Sao_Paulo
ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
hwclock --systohc
pacman -S nano
nano /etc/locale.gen
```

Descomente a linha do local que você quer ─ ambos UTF8 e ISO

Salve e saia

```sh
locale-gen
```

Aqui `_lang_` será lingua do local que você escolheu

```sh
echo LANG=lang.UTF-8 >> /etc/locale.conf
echo KEYMAP=br-abnt2 >> /etc/vconsole.conf
echo 'nome-do-pc' >> /etc/hostname
nano /etc/hosts
```

Dentro do arquivo

```sh
/etc/hosts
-------------
127.0.0.1 \t localhost
::1 \t localhost
127.0.1.1 \t 'nome-do-pc'.localdomain \t 'nome-do-pc'
```

Salve e saia

```sh
passwd
# digite a senha do root (2x)

pacman -S dosfstools mtools dialog sudo ntfs-3g
```

- Se você conectou pelo wifi (ou celular) possui hardware mais novo

    ```sh
    pacman -S networkmanager wireless_tools dhcpcd iwd
    ```

- hardware mais antigo

    ```sh
    pacman -S networkmanager wireless_tools dhcpcd iwd wpa_supplicant netctl
    ```

- para processador **intel**

    ```sh
    pacman -S intel-ucode
    ```

- para processador **amd**

    ```sh
    pacman -S amd-ucode
    ```

- Caso esteja instalando pela primeira vez

    ```sh
    useradd -m -g users -G wheel 'nome do usuário'
    ```

- Caso esteja reinstalando

    ```sh
    useradd -g users -G wheel 'nome_do_usuario'
    usermod -d /home/nome_do_usuario -m nome_do_usuario
    ```

```sh
passwd 'nome do usuário'
# digite a senha do seu usuário (2x)

nano /etc/sudoers
```

Dentro do arquivo

```sh
/etc/sudoers
---------------
## Adicione essa linha caso queira um pouco de diversão
# Insult me
Defaults \t insults

## descomente essa linha (localizada no final do arquivo)
%wheel ALL=(ALL) ALL
```

Salve e saia

- Para **BIOS boot**

    ```sh
    pacman -S grub
    grub-install --target=i386-pc --recheck /dev/sda
    ```

- Para **EFI boot**

    ```sh
    pacman -S grub efibootmgr

    grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=arch_grub --recheck
    ```

> Para dual boot
>
> ```sh
> pacman -S os-prober
> os-prober
> ```

```sh
grub-mkconfig -o /boot/grub/grub.cfg
^D
shutdown now
```

Remova seu pen drive, eis que arch está "instalado"... Você ainda tem um longo caminho pela frente...

## Ligando a besta

Logue como *seu user* (lembra do nome dele?)

Crie o arquivo

```sh
/etc/systemd/network/25-wireless.network
------------
[Match]
Name=wlan0

[Network]
DHCP=yes
```

```sh
sudo systemctl start systemd-{networkd,resolved}
```

Conecte-se usando o `iwctl` [novamente?](###conectar-à-internet)

```sh
sudo pacman -Sy xorg-server
```

- Para placa de vídeo AMD

    ```sh
    sudo pacman -S xf86-video-amdgpu
    ```

- ou pesquise para [nvidia](https://wiki.archlinux.org/index.php/NVIDIA)
    > Olhe [aqui também](https://wiki.archlinux.org/index.php/PRIME) caso você tenha duas placas de vídeo

### Alguns programas Vanilla

```sh
sudo pacman -S libgl mesa sddm plasma konsole dolphin alsa pulseaudio-alsa network-manager-applet

sudo systemctl enable sddm
sudo systemctl start sddm
```

Logue no sistema e abra um terminal (i.e. `konsole`).

```sh
sudo pacman -S git rustup
rustup default stable
git clone https://aur.archlinux.org/paru
cd paru
makepkg -si
```

Agora para instalar qualquer programa basta usar o comando `paru`

```sh
sudo nano /etc/pacman.conf
```

descomente as duas linhas abaixo, dentro do arquivo

```/etc/pacman.conf
--------
[multilib]
Include = /etc/pacman.d/mirrorlist
```
