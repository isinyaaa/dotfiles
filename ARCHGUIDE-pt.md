# ar{ch,t}guide

## Sumário

- [ar{ch,t}guide](#archtguide)
  - [Sumário](#sumário)
  - [Pre-configuração](#pre-configuração)
  - [Formatação](#formatação)
    - [Para Legacy boot](#para-legacy-boot)
    - [Para EFI boot](#para-efi-boot)
  - [Conectar à internet](#conectar-à-internet)
  - [Particionamento](#particionamento)
    - [Particionamento vanilla](#particionamento-vanilla)
    - [Particionamento em btrfs](#particionamento-em-btrfs)
  - [Instalando o Linux itself](#instalando-o-linux-itself)
  - [Configuração da instalação](#configuração-da-instalação)
  - [Ligando a besta](#ligando-a-besta)
    - [Alguns programas Vanilla](#alguns-programas-vanilla)

## Pre-configuração

Primeiramente, devemos carregar o teclado de nossa escolha, aqui assumo que o
leitor usa um teclado ABNT2 (você tem a tecla `alt-gr` no lado direito da barra
de espaço?):

```sh
loadkeys br-abnt2
```

Vamos testar se existe a pasta `/sys/firmware/efi/efivars`, ela indica se estamos num sistema com EFI boot:

```sh
ls /sys/firmware/efi/efivars
```

- Se existir algo nessa pasta:
    **tente EFI boot**
- Caso contrário
    **BIOS/LEGACY boot**

## Formatação

### Para Legacy boot

Provavelmente não será necessário formatar seu disco, pode pular essa parte.

### Para EFI boot

O `lsblk` nos permite listar os dispositivos de bloco conectados ao sistema (i.e. tudo que nos permite guardar dados de maneira não-volátil):

```sh
$ lsblk
NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
sda      8:0    0 447.1G  0 disk
├─sda1   8:1    0   512M  0 part /boot/efi
└─sda2   8:2    0 446.6G  0 part /home
                                 /mnt/defvol
                                 /
zram0  254:0    0   3.1G  0 disk [SWAP]
```

Note que possuímos um disco `sda` de tamanho total `447.1G` (i.e. 447.1 GB), e
que está particionado em `sda1` e `sda2`.

Assim que você achar o disco que lhe interessa, podemos formatá-lo usando o `gdisk`, que é a ferramenta apropriada para lidar com discos GPT:

```sh
$ gdisk -l /dev/sda
GPT fdisk (gdisk) version 1.0.8

Partition table scan:
  MBR: protective
  BSD: not present
  APM: not present
  GPT: present

Found valid GPT with protective MBR; using GPT.
Disk /dev/sda: 937703088 sectors, 447.1 GiB
Model: KINGSTON SA400S3
Sector size (logical/physical): 512/512 bytes
Disk identifier (GUID): 4E546578-CCF5-4FC4-8EDF-3C8BA569C0D6
Partition table holds up to 128 entries
Main partition table begins at sector 2 and ends at sector 33
First usable sector is 34, last usable sector is 937703054
Partitions will be aligned on 2048-sector boundaries
Total free space is 3693 sectors (1.8 MiB)

Number  Start (sector)    End (sector)  Size       Code  Name
   1            2048         1050623   512.0 MiB   EF02  BIOS boot partition
   2         1050624       937701375   446.6 GiB   8300  Linux filesystem
```

Podemos ver, nas primeira linhas, que já possuímos uma tabela de partição de tipo `GPT`, o que é o desejável em sistemas UEFI.

Também é possível executar os mesmos procedimentos de forma mais "resumida"
utilizando a ferramenta clássica `fdisk`, usando a flag `-l` para listá-los:

```sh
$ fdisk -l
Disk /dev/sda: 447.13 GiB, 480103981056 bytes, 937703088 sectors
Disk model: KINGSTON SA400S3
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: 4E546578-CCF5-4FC4-8EDF-3C8BA569C0D6

Device       Start       End   Sectors   Size Type
/dev/sda1     2048   1050623   1048576   512M BIOS boot
/dev/sda2  1050624 937701375 936650752 446.6G Linux filesystem


Disk /dev/zram0: 3.1 GiB, 3324829696 bytes, 811726 sectors
Units: sectors of 1 * 4096 = 4096 bytes
Sector size (logical/physical): 4096 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
```

Note que aqui a informação relativa ao tipo de tabela de partição está na sexta linha de output, sob o nome de `Disklabel type`.

- Caso **Disklabel type** type seja **mbr** (= **dos**):
    >  Uma alternativa fácil (porém longe do ideal) é formatar o disco. Caso
    >  queira fazer isso seguem os comandos. Note que `_pdisk_` se refere ao
    >  seu disco primário, que você quer formatar:
    >
    > ```sh
    > dd if=/dev/zero of=/dev/_pdisk_ bs=4096 status=progress
    > gdisk /dev/sda
    > n
    > +1M
    > ef02
    > w
    > ```

- Para **Disklabel type: gpt** basta seguir em frente

## Conectar à internet

---

É boa prática retirar soft locks dos dispositivos de conexão sem fio do
computador (i.e. bluetooth, wifi)

```sh
rfkill unblock all
```

> Também é possível listá-los aqui:
>
> ```sh
> $ rfkill list
> 0: asus-wlan: Wireless LAN
>   Soft blocked: no
>   Hard blocked: no
> 1: asus-bluetooth: Bluetooth
>   Soft blocked: no
>   Hard blocked: no
> 2: phy0: Wireless LAN
>   Soft blocked: no
>   Hard blocked: no
> 3: hci0: Bluetooth
>   Soft blocked: no
>   Hard blocked: no
> ```

Seguem os métodos em ordem de dificuldade

1. Cabo LAN:

    Conecte um cabo de rede lan
    > pronto? provavelmente sim!

2. Utilizando o cartão de rede do seu sistema:

    ```sh
    iwctl
    station wlan0 scan
    station wlan0 connect _nome-da-sua-rede_
    # digite a senha da rede
    ^D
    ```

    > Aqui é interessante utilizar o `tab` para listar as redes escaneadas na
    > hora de conectar. Note também o atalho `Ctrl + D` (denotado por `^D`)
    > para sair.

3. Utilizando a internet do seu celular:
    1. Conecte o celular via USB
    2. Ative a ancoragem no aparelho (_tethering_)
    3. Execute:

    ```sh
    $ ip link show
    1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
        link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    3: wlan0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DORMANT group default qlen 1000
        link/ether 5c:80:b6:fc:30:b4 brd ff:ff:ff:ff:ff:ff
    4: enp0s20f0u2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UNKNOWN mode DEFAULT group default qlen 1000
        link/ether 62:31:60:e2:1f:05 brd ff:ff:ff:ff:ff:ff
    ```

    > O celular é, com frequência, a interface com o nome longo (i.e.
    > `enp0s20f0u2` no exemplo acima). Isso se dá pelos identificadores de
    > portas USB.

    Dessa forma, basta conectar-se fazendo

    ```sh
    ip link set _CEL_ up
    dhcpcd -h _CEL_
    ```

    onde `_CEL_` é o identificador do seu aparelho.

> Utilize o comando `ping` para testar sua rede. I.e.
>
> ```sh
> ping -c 1 google.com
> ```

Agora podemos sincronizar nossos relógios com a rede antes de prosseguir:

```sh
timedatectl set-ntp true
```

## Particionamento

---

Vou chamar seu disco primário por `_pdisk_`. De forma genérica podemos usar o
`fdisk`, porém também existem o `gdisk` (CLI para GPT) e as aplicações
"gráficas" correspondentes: `cfdisk` e `cgdisk`. Seguem alguns comandos comuns
para o `fdisk` e o `gdisk`:

Lista de comandos

cmd | função
:-: | :-
`d` | deletar partição
`n` | nova partição
`t` | mudar tipo da partição
`p` | mostrar partições
`w` | para salvar
`q` | para cancelar

### Particionamento vanilla

> teremos 4 partições

1. BIOS boot com 512M
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

> teremos duas partições

1. `BIOS boot` com 512M
    - Denotada por `_devboot_`
1. `linux filesystem` com tudo
    - Denotada por `_devfs_`

```sh
mkfs.fat -F32 _devboot_
mkfs.btrfs _devfs_
mount _devfs_ /mnt
cd /mnt
btrfs subvol create _active
btrfs subvol create _active/rootvol
btrfs subvol create _active/homevol
btrfs subvol create _snapshots
cd ..
umount /mnt
mount -o subvol=_active/rootvol _devfs_ /mnt
mkdir /mnt/{boot,home,mnt}
mkdir /mnt/mnt/defvol
mount -o subvol=_active/homevol _devfs_ /mnt/home
mount -o subvol=/ _devfs_ /mnt/mnt/defvol
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
genfstab -U /mnt >> /mnt/etc/fstab
```

Agora vamos entrar no sistema

```sh
arch-chroot /mnt
timedatectl set-timezone America/Sao_Paulo
ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
hwclock -wu
pacman -S nano
nano /etc/locale.gen
```

Descomente a linhas do locale desejado ─ ambos UTF-8 e ISO

Salve e saia

```sh
locale-gen
```

Aqui `_lang_` será lingua do local que você escolheu

```sh
echo LANG=_lang_.UTF-8 >> /etc/locale.conf
echo KEYMAP=br-abnt2 >> /etc/vconsole.conf
```

Agora escolha um nome para o seu PC. É importante notar que, tanto para
usuários quanto para nome de máquina, não podem ser usadas letras maiúsculas,
acentos ou símbolos (com raras exceções), e nem podemos começar usando números.

```sh
echo _nome_do_pc_ >> /etc/hostname
nano /etc/hosts
```

Dentro do arquivo

```sh
/etc/hosts
-------------
127.0.0.1 \t localhost
::1 \t localhost
127.0.1.1 \t _nome_do_pc_.localdomain \t _nome_do_pc_
```

> ⚠️ Note que aqui usamos `\t` como notação para o `tab`

Salve e saia

```sh
passwd
# digite a senha do root (2x)
```

- Se você conectou pelo wifi (ou celular) possui hardware mais novo

    ```sh
    pacman -S networkmanager wireless_tools dhcpcd iwd
    ```

- Para hardware mais antigo

    ```sh
    pacman -S networkmanager wireless_tools dhcpcd iwd wpa_supplicant netctl
    ```

- Para processador **intel**

    ```sh
    pacman -S intel-ucode
    ```

- Para processador **amd**

    ```sh
    pacman -S amd-ucode
    ```

- Caso esteja instalando pela primeira vez

    ```sh
    useradd -m -g users -G wheel _nome_do_usuário_
    ```

- Caso esteja reinstalando (i.e. já possui um usuário)

    ```sh
    useradd -g users -G wheel _nome_do_usuario_
    usermod -d /home/_nome_do_usuario_ -m _nome_do_usuario_
    chown -R _nome_do_usuario_ /home/_nome_do_usuario_
    ```

```sh
passwd _nome_do_usuario_
# digite a senha do seu usuário (2x)

nano /etc/sudoers
```

Dentro do arquivo

```raw
/etc/sudoers
---------------
## Adicione essa linha caso queira um pouco de diversão
# Insult me
Defaults \t insults

## descomente essa linha (localizada no final do arquivo)
%wheel ALL=(ALL) ALL
```

Salve e saia

> Caso você tenha usado btrfs, adicione o hook `btrfs` no final da lista no
> arquivo `/etc/mkinitcpio.conf` e, depois faça
>
> ```sh
> pacman -S btrfs-progs
> mkinitcpio -P
> ```

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

1. Internet sem fio pelo systemd
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

1. Internet sem fio pelo NetworkManager + DHCPCD
    Crie os arquivos

    ```raw
    /etc/NetworkManager/conf.d/dhcp-client.conf
    -----------
    [main]
    dhcp=dhcpcd
    ```

    ```raw
    /etc/NetworkManager/conf.d/wifi_backend.conf
    -----------
    [device]
    wifi.backend=iwd
    ```

    ```sh
    sudo systemctl enable {NetworkManager,iwd}
    sudo systemctl start {NetworkManager,iwd}
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
sudo pacman -S mesa sddm plasma konsole dolphin pipewire pipewire-alsa pipewire-pulse pipewire-docs network-manager-applet
sudo mkdir /etc/pipewire
sudo cp /usr/share/pipewire/pipewire* /etc/pipewire/

systemctl --user enable pipewire{,-pulse}
systemctl --user start pipewire{,-pulse}

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
cd ..
rm -rf paru
```

Agora para instalar qualquer programa basta usar o comando `paru`

```sh
sudo nano /etc/pacman.conf
```

descomente as duas linhas abaixo, dentro do arquivo

```raw
/etc/pacman.conf
--------
[multilib]
Include = /etc/pacman.d/mirrorlist
```

depois faça

```sh
paru -Syy
```
