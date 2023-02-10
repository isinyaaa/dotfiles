# ar{ch,t}guide

## Sumário

- [ar{ch,t}guide](#archtguide)
  - [Sumário](#sumário)
  - [Formato desse manual](#formato-desse-manual)
  - [Pre-configuração](#pre-configuração)
  - [Formatação](#formatação)
    - [Para Legacy boot](#para-legacy-boot)
    - [Para EFI boot](#para-efi-boot)
  - [Conectar à internet](#conectar-à-internet)
  - [Particionamento](#particionamento)
  - [Instalando o Linux](#instalando-o-linux)
  - [Configuração da instalação](#configuração-da-instalação)
  - [Ligando a besta](#ligando-a-besta)

## Formato desse manual

Cada comando a ser executado é precedido por um cifrão (`$`), as vezes
possuindo um exemplo de saída logo abaixo.

O conteúdo de arquivos a serem editador é escrito no formato:

```raw
arquivo.txt
-----------
Conteúdo
```

Variáveis são descritas com `_nome_da_variavel_`.

O modificador `^` indica o uso da tecla `CTRL`, então onde aparece `^D`, use
`CTRL+D` (atalho comum para sair de algum ambiente).

O modificador `\t` indica o uso de um carácter `TAB`.

> Cuidado ao copiar comandos cegamente!

## Pre-configuração

Primeiramente, devemos carregar o teclado de nossa escolha, aqui assumo que o
leitor usa um teclado ABNT2 (você tem a tecla `alt-gr` no lado direito da barra
de espaço?):

```sh
$ loadkeys br-abnt2
```

Vamos testar se existe a pasta `/sys/firmware/efi/efivars`, ela indica se estamos num sistema com EFI boot:

```sh
$ ls /sys/firmware/efi/efivars
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
    >  queira fazer isso seguem os comandos. Note que `_pdisk_` (`/dev/sda`,
    >  por exemplo) se refere ao seu disco primário, que você quer formatar:
    >
    > ```sh
    > $ dd if=/dev/zero of=/dev/_pdisk_ bs=4096 status=progress
    > $ gdisk /dev/sda
    > $ n
    > $ +1M
    > $ ef02
    > $ w
    > ```

- Para **Disklabel type: gpt** basta seguir em frente

## Conectar à internet

É boa prática retirar soft locks dos dispositivos de conexão sem fio do
computador (i.e. bluetooth, wifi)

```sh
$ rfkill unblock all
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

    Note que talvez seja necessário inserir o cabo antes de bootar o archiso,
    então se você inseriu após o boot, reinicie o PC (lembre-se de reconfigurar
    o teclado).

2. Utilizando o cartão de rede do seu sistema:

    ```sh
    $ iwctl
    $ station wlan0 scan
    $ station wlan0 connect _nome-da-sua-rede_
    # digite a senha da rede
    $ ^D
    ```

    > Aqui é interessante utilizar o `tab` para listar as redes escaneadas na
    > hora de conectar. Note também o atalho `CTRL+D` (denotado por `^D`)
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
    $ ip link set _CEL_ up
    $ dhcpcd -h _CEL_
    ```

    onde `_CEL_` é o identificador do seu aparelho.

> Utilize o comando `ping` para testar sua rede. I.e.
>
> ```sh
> $ ping -c 1 google.com
> ```

Agora podemos sincronizar nossos relógios com a rede antes de prosseguir:

```sh
$ timedatectl set-ntp true
```

## Particionamento

Essa é tida como uma das partes mais difíceis do processo, porém na realidade é
bastante simples. Aqui apresento duas opções de particionamento, a clássica
(a.k.a. _vanilla_) e uma mais moderna que dá controle direto à backups (usando
_btrfs_).

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

Abaixo seguem os esquemas de particionamento.

<details>
<summary>Particionamento vanilla</summary>

Teremos pelo menos 2 partições, `_devslash_` e `_devhome_`, confira sua
necessidade caso precise de outras.

| #   | ID  | Função | Tamanho | Tipo |
| :-: | :-: | :-     | :-      | :-   |
| 1   | `_devboot_` | Responsável pelos arquivos de boot num sistema `EFI` | 256M ~ 512M | Use `EFI boot` caso vá usar `systemd-boot` (mais simples), ou `BIOS boot` caso vá usar o `grub` (mais complexo) |
| 2   | `_devswap_`  | Swap: Memória adicional para hibernação/caso não tenha o suficiente. Também é possível criar um arquivo de swap posteriormente caso prefira | Mesmo tamanho da sua memória caso queira hibernar, ou quanto achar necessário caso contrário. | `swap` |
| 3   | `_devslash_` | Responsável pelos arquivos de sistema | 30G ~ 50G (vai da sua necessidade) | Padrão (`linux filesystem`) |
| 4   | `_devhome_`  | Onde você colocará seus arquivos | O resto do espaço disponível. Faça menor conforme sua necessidade (e.g. se vai instalar o windows no mesmo disco, faça menor pra sobrar espaço) | Padrão (`linux filesystem`) |

Após decidir os tamanhos e criar as partições, temos que formatá-las e
montá-las antes de as utilizarmos.

Para formatar:

```sh
$ mkfs.vfat _devboot_ # somente para sistemas EFI
$ mkfs.ext4 _devslash_
$ mkfs.ext4 _devhome_
```

> Note que caso a partição não esteja "limpa" (i.e. ela pode ter alguma assinatura do que havia anteriormente) o comando de formatação pedirá confirmação antes de prosseguir.

Para montar:

```sh
$ mount _devslash_ /mnt
$ mkdir /mnt/{boot,home}
$ mount _devhome_ /mnt/home
$ mount _devboot_ /mnt/boot # somente para sistemas EFI
```

* Caso tenha optado por criar uma partição de swap, basta fazer

    ```sh
    $ mkswap _devswap_
    $ swapon _devswap_
    ```

    antes de prosseguir.

> confira se montou tudo corretamente utilizando o `lsblk`

</details>

<details>
<summary>Particionamento em btrfs</summary>

Teremos duas partições:

| #   | ID  | Função | Tamanho | Tipo |
| :-: | :-: | :-     | :-      | :-   |
| 1   | `_devboot_` | Responsável pelos arquivos de boot num sistema `EFI` | 256M ~ 512M | Use `EFI boot` caso vá usar `systemd-boot` (mais simples), ou `BIOS boot` caso vá usar o `grub` (mais complexo) |
| 2   | `_devfs`  | Responsável por todos os arquivos do sistema | O resto do espaço disponível. Faça menor conforme sua necessidade (e.g. se vai instalar o windows no mesmo disco, faça menor pra sobrar espaço) | Padrão (`linux filesystem`) |

Após decidir os tamanhos e criar as partições, temos que formatá-las, criar
subvolumes, e então montá-las antes de as utilizarmos.

Para formatar:

```sh
$ mkfs.vfat _devboot_ # somente para sistemas EFI
$ mkfs.btrfs _devfs_
```

Para criar os subvolumes:

```sh
$ mount _devfs_ /mnt
$ cd /mnt
$ btrfs subvol create _active # esse subvolume representa o que utilizaremos usualmente
$ btrfs subvol create _active/rootvol # aqui temos nosso /
$ btrfs subvol create _active/homevol # e aqui arquivos pessoais
$ btrfs subvol create _snapshots # esse subvolume representa nossos backups, inicialmente ele é vazio
$ cd ..
$ umount /mnt
```

Para montar:

```sh
$ mount -o subvol=_active/rootvol _devfs_ /mnt
$ mkdir /mnt/{boot,home,mnt}
$ mkdir /mnt/mnt/defvol
$ mount -o subvol=_active/homevol _devfs_ /mnt/home
$ mount -o subvol=/ _devfs_ /mnt/mnt/defvol
$ mount _devboot_ /mnt/boot # somente para sistemas EFI
```

> Quando utilizo `btrfs` acho melhor criar um `swapfile`, pesquise por isso na
> archwiki caso tenha interesse.

</details>

## Instalando o Linux

Utilizamos o `pacstrap` para instalar pacotes em outros filesystems. Como as
partições criadas ainda não possuem nada, devemos usá-lo aqui.

Os pacotes `base` e `linux` (ou `linux-lts`) são os únicos necessários, porém
para o caso comum de desenvolvimento recomendo instalar alguns adicionais, além
do `man-db` e `man-pages`, que proveem a funcionalidade completa de manuais.

- Para hardware mais novo usamos o kernel mais recente (`linux`)

    ```sh
    $ pacstrap /mnt base base-devel linux linux-firmware linux-headers man-db man-pages
    ```

- para hardware mais antigo (ou para uma experiência mais estável) usamos o
    kernel com _long-time support_ (`lts`)

    ```sh
    $ pacstrap /mnt base base-devel linux-firmware linux-lts linux-lts-headers linux-lts-docs
    ```

## Configuração da instalação

Agora, com nosso sistema instalado, precisamos configurá-lo minimamente para
que funcione por conta própria, o que consiste em:

- configurações de timezone
- pacotes para internet
- criação de um usuário com privilégios
- configuração do bootloader

1. Primeiro, explicitamos quais partições devem ser montadas no boot, para isso
   basta exportar tudo que foi montado no nosso `/mnt` para o `fstab`. Esse
   arquivo contém informações de montagem.

    ```sh
    $ genfstab -U /mnt >> /mnt/etc/fstab
    ```

2. Agora vamos entrar no sistema

    ```sh
    $ arch-chroot /mnt
    ```

3. Para configurar o horário usamos

    ```sh
    $ timedatectl set-timezone America/Sao_Paulo
    $ hwclock -wu # atualizamos também o timezone da nossa placa-mãe, note que isso conflita com o padrão do windows pois usam formatos diferentes (UTC no linux e localtime no windows)
    ```

4. Agora, configuramos o local do sistema. Isso inclui configurações de teclado a ser utilizado fora do ambiente gráfico, assim como a lingua padrão do sistema.

    Agora precisamos alterar alguns arquivos. Utilize seu editor de escolha,
    ou, caso não conheça nenhum, use o `nano`:

    ```sh
    $ pacman -S nano
    $ nano /etc/locale.gen
    ```

    Descomente a linhas do locale desejado (basta remover o `#` no inicio) ─
    ambos UTF-8 e ISO

    Salve e saia

    ```sh
    $ locale-gen
    ```

    Aqui `_lang_` será lingua do local que você escolheu (`pt-br` por exemplo)

    ```sh
    $ echo LANG=_lang_.UTF-8 >> /etc/locale.conf
    $ echo KEYMAP=br-abnt2 >> /etc/vconsole.conf
    ```

5. Escolha um nome para o seu PC e para o seu usuário. É importante notar que,
   para ambos, não podem ser usadas letras maiúsculas, acentos ou símbolos (com
   raras exceções), e nem podemos começar usando números.

    ```sh
    $ echo _nome_do_pc_ >> /etc/hostname
    ```

    - Caso esteja instalando pela primeira vez

        ```sh
        $ useradd -m -g users -G wheel _nome_do_usuário_
        ```

    - Caso esteja reinstalando (i.e. já possui um usuário)

        ```sh
        $ useradd -g users -G wheel _nome_do_usuario_
        $ usermod -d /home/_nome_do_usuario_ -m _nome_do_usuario_
        $ chown -R _nome_do_usuario_ /home/_nome_do_usuario_
        ```

6. Agora, alteramos as senhas para o usuário padrão (`root`) e para o seu novo
   usuário.

   O `root` não deve ser utilizado com frequência, mas quem tiver esse acesso
   ganha todos os privilégios do sistema, então escolha a senha com cuidado!

    ```sh
    $ passwd
    # digite a senha do root (2x)
    ```

    ```sh
    $ passwd _nome_do_usuario_
    # digite a senha do seu usuário (2x)
    ```

7. Agora configuramos os privilégios do `root`, para isso editamos
   `/etc/sudoers`:

    ```raw
    /etc/sudoers
    ---------------
    ## Adicione essa linha caso queira um pouco de diversão
    Defaults    \t  insults
    ## env_reset controla o ambiente a cada mudança de usuário
    ## ^G deve ser inserido escapando o caracter (CTRL+V no vim e ALT+G no nano)
    Defaults    \t  env_reset,passprompt="^G[sudo] password for %p: "
    ## isso deve tornar o login persistente
    Defaults    \t  timestamp_timeout=10,timestamp_type=global

    ## descomente essa linha (localizada no final do arquivo)
    %wheel ALL=(ALL) ALL
    ```

    Salve e saia

8. Precisamos configurar a rede. Para isso editamos o arquivo `/etc/hosts`:

    ```raw
    /etc/hosts
    -------------
    # Configurações para ipv4
    127.0.0.1 \t localhost
    127.0.1.1 \t _nome_do_pc_.localdomain \t _nome_do_pc_

    # Configurações para ipv6
    ::1 \t localhost \t ip6-localhost \t ip6-loopback
    ff02::1	\t ip6-allnodes
    ff02::2	\t ip6-allrouters
    ```

    > ⚠️ Note que aqui usamos `\t` como notação para o `tab`

    Salve e saia

    - Para instalações sem wifi, basta instalar

        ```sh
        $ pacman -S networkmanager dhcpcd dnsmasq
        ```

        E então configuramos o networkmanager da seguinte forma:

        - Crie os seguintes arquivos com esses conteúdos:

        ```raw
        /etc/NetworkManager/conf.d/dns.conf
        ------
        [main]
        dns=dnsmasq
        ```

        ```raw
        /etc/NetworkManager/conf.d/dhcp-client.conf
        ------
        [main]
        dhcp=dhcpcd
        ```

    - Caso precise de wifi (ou _tethering_ pelo celular), faça também

        ```sh
        $ pacman -S wireless_tools iwd
        ```

        crie os arquivos anteriores, e também crie este:

        ```raw
        /etc/NetworkManager/conf.d/wifi_backend.conf
        ------
        [device]
        wifi.backend=iwd
        ```

    Por fim, habilitamos o serviço de rede:

    ```sh
    $ systemctl enable NetworkManager
    ```

9. Caso vá utilizar alguma placa de vídeo discreta no seu sistema, precisamos
   de pacotes para ela também:

    - Para placa de vídeo AMD

        ```sh
        $ pacman -S xf86-video-amdgpu
        ```

    - Para placa de vídeo NVIDIA

        ```sh
        $ pacman -S nvidia nvidia-utils

    > Olhe [aqui também](https://wiki.archlinux.org/index.php/PRIME) caso você tenha duas placas de vídeo

10. Agora configuramos o boot

    Primeiro instale o pacote de microcode correspondente ao seu processador

    - Para processador **intel**

        ```sh
        $ pacman -S intel-ucode
        ```

    - Para processador **amd**

        ```sh
        $ pacman -S amd-ucode
        ```

    > Caso você tenha usado btrfs, também instale
    >
    > ```sh
    > $ pacman -S btrfs-progs
    > ```

    Agora instalamos o bootloader:

    ```sh
    $ bootctl --path=/boot install
    ```

    Também precisamos configurá-lo, para isso, editamos dois arquivos

    ```raw
    /boot/loader/loader.conf
    ------
    default arch.conf
    editor 0
    timeout 3
    console-mode auto
    ```

    Note que a primeira linha nos diz qual a entry padrão do bootloader, que
    vamos escrever em seguida.

    - Configuração base:

        ```raw
        /boot/loader/entries/arch.conf
        ------
        title	Arch Linux
        linux	/vmlinuz-linux
        initrd	/amd-ucode.img # use intel-ucode.img caso seu processador seja intel
        initrd	/initramfs-linux.img
        options	root=_devslash_ rw quiet # lembre-se de substituir a variavel pelo /dev/xxx onde está sua partição do /
        ```

    - Caso possua mais de um disco, precisamos do UUID da partição onde seu
        _devslash_ está, para conseguir isso fazemos

        ```sh
        $ lsblk _devslash_ -o UUID >> /boot/loader/entries/arch.conf
        ```

        depois, troque o parametro `root=_devslash_` por `root=UUID=...`

    - Caso esteja utilizando btrfs, também é importante especificar algumas
        outras flags

        ```raw
        /boot/loader/entries/arch.conf
        ------
        ...
        options	root=... rootflags=noatime,discard=async,autodefrag,subvol=_active/rootvol rw quiet
        ```

    - Caso vá utilizar uma placa nvidia, também é importante adicionar uma flag

        ```raw
        /boot/loader/entries/arch.conf
        ------
        ...
        options	... rw quiet nvidia_drm.modeset=1
        ```

Finalmente terminamos o setup do sistema, bem trabalhoso, não?

Agora basta reiniciar!

```sh
$ ^D
$ shutdown -h now
```

Remova seu pen drive, eis que o seu Arch Linux está "instalado"... Você ainda
tem um longo caminho pela frente...

## Ligando a besta

1. Logue como *seu user* (lembra do nome dele?)

2. Conecte-se usando o `iwctl` [novamente?](###conectar-à-internet)

### Alguns programas Vanilla

| Pacote | Função |
| :--    | :--    |
| `xorg-server` | Display server padrão do Linux. Alternativamente, pesquisa sobre o wayland |
| `mesa` | Nos dá funcionalidades mais avançadas de GPU, como compilação de shaders, porém é inútil se estamos usando uma placa Nvidia |
| `sddm` | Display manager (te permite logar usando uma interface gráfica)
| `wireplumber` | Session manager do processador de audio (necessário para ter audio) |
| `pipewire` | Processador de audio |
| `pipewire-alsa` | Interface do pipewire para o processamento de audio mais simples do Linux (ALSA) |
| `pipewire-pulse` | Prove suporte para o `pulseaudio`, que é uma interface mais moderna |

Precisamos também de alguma interface gráfica. Caso não tenha nenhuma em mente, recomendo utilizar o `plasma` (KDE), para isso basta instalar

| Pacote | Função |
| :--    | :--    |
| `plasma` | Desktop environment do KDE |
| `konsole` | Emulador de terminal padrão do KDE |
| `dolphin` | File explorer padrão do KDE |
| `network-manager-applet` | Nos dá um ícone para gerenciar rede (ao invés de ter que usar o terminal sempre) |

> Caso tenha uma placa de vídeo Nvidia, é interessante criar uma xorg.conf para
> ela, para isso basta fazer
>
> ```sh
> $ sudo nvidia-xconfig
> ```

Após instalar os pacotes desejados (`sudo pacman -S [pacote1] [pacote2] ...`) ,
precisamos habilitar e iniciar seus serviços correspondentes, isso pode ser
feito com

```sh
$ systemctl --user enable wireplumber pipewire-pulse
$ sudo systemctl enable sddm --now
```

Agora, com a interface, finalizamos o tutorial instalando um aur-helper. Há
quem diga (eu) que o AUR é a melhor parte do Arch Linux, já que qualquer
usuário pode criar pacotes de uma forma simples, nos dando um repositório
virtualmente infinito, onde qualquer funcionalidade está há um comando de
distância.

Primeiro, obviamente, logue no sistema e abra um terminal (e.g. `konsole`).

Existem diversos aur-helpers, porém acredito que a melhor opção no momento seja
o `paru`. Para utilizá-lo precisamos instalar o `rust`, para isso faça:

```sh
$ sudo pacman -S rustup
$ rustup default stable
```

Os aur-helpers não se encontram disponíveis pelos repositórios oficiais
(`pacman`), dessa forma precisamos instalá-los manualmente, o que é bem
simples:

```sh
$ sudo pacman -S git # precisamos das instruções de instalação do pacote
$ git clone https://aur.archlinux.org/paru # todos os pacotes do arch são versionados, então basta clonar o repositório respectivo
$ cd paru # dentro do repositório de cada pacote, temos seu PKGBUILD
$ makepkg -si # esse comando irá instalar o pacote conforme as instruções do PKGBUILD
$ cd ..
$ rm -rf paru # depois, podemos deletar o repositório do pacote, já que ele se atualiza sozinho
```

Agora para instalar qualquer programa basta usar o comando `paru`, pois ele
busca tanto nos repositórios oficiais quanto no AUR.

Ainda assim não temos acesso à todos os pacotes do Arch pois, por padrão,
pacotes 32-bit estão desabilitados, para habilitá-los descomentamos as duas
linhas abaixo, dentro do arquivo

```raw
/etc/pacman.conf
--------
[multilib]
Include = /etc/pacman.d/mirrorlist
```

depois, para atualizar os repositórios, faça

```sh
paru -Syy
```

Existem ainda algumas outras configurações interessantes para o
`paru`/`pacman`, por exemplo, abaixo de `# Misc options`:

```raw
/etc/pacman.conf
------
# Misc options
#UseSyslog
Color # colore o output
#NoProgressBar
CheckSpace
ILoveCandy # surpresa...
#VerbosePkgLists
ParallelDownloads = 30 # escolha a quantidade dependendo da velocidade da sua internet
```

Para o `paru`, recomendo configurar da seguinte forma. Primeiro crie a pasta da
config:

```sh
$ mkdir -p ~/.config/paru
```

> Note que ~ indica sua pasta home. Rode `echo ~` caso deseje ver do que se
> trata.

Depois, edite:

```raw
~/.config/paru/paru.conf
------
[options]
BottomUp # list os pacotes ao contrário quando performamos uma busca
SudoLoop # não deixa o sudo morrer enquanto rodamos o paru
CombinedUpgrade # atualiza pacotes dos repositórios oficiais e do AUR, juntos
BatchInstall # Instala os pacotes juntos, também
NewsOnUpgrade # Nos mostra noticias do archlinux.org ao atualizar
```
