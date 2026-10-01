<table width="100%">
<tr>
<td align="left" width="5000"><strong>Português</strong> | <a href="https://github.com/guihn/ArchLinux-Installation/tree/main/English/Installation">English</a></td>
<td align="right" width="5000"><a href="https://github.com/guihn/ArchLinux-Installation/tree/main/Portugu%C3%AAs/Prepara%C3%A7%C3%A3o">Anterior</a> | <a href="https://github.com/guihn/ArchLinux-Installation/tree/main/Portugu%C3%AAs">Índice</a> | <a href="https://github.com/guihn/ArchLinux-Installation/tree/main/Portugu%C3%AAs/P%C3%B3s%20Instala%C3%A7%C3%A3o">Próximo</a></td>
</tr>
</table>

# Instalação

O ambiente Live do Arch iniciado na [Preparação](https://github.com/guihn/ArchLinux-Installation/tree/main/Portugu%C3%AAs/Prepara%C3%A7%C3%A3o) está em execução. Os comandos até a seção 3 funcionam como root nesse ambiente; a seção 4 entra no novo sistema por chroot. Esta página chega a uma instalação inicializável em console. Os drivers gráficos e o ambiente gráfico vêm na [Pós Instalação](https://github.com/guihn/ArchLinux-Installation/tree/main/Portugu%C3%AAs/P%C3%B3s%20Instala%C3%A7%C3%A3o).

## 1. Ambiente Live

### 1.1 Terminal, resultados e fonte

O terminal recebe comandos no prompt do shell. Caminhos, maiúsculas, espaços, aspas e pontuação são significativos. Um comando pode terminar sem apresentar mensagens; o silêncio, sozinho, não comprova sucesso. Imediatamente após um comando, `echo $?` apresenta seu código de saída: zero normalmente indica sucesso. Os arquivos, as montagens ou o estado dos serviços esperados fornecem confirmação adicional.

Para uma fonte maior no console, o ambiente Live oferece:

```bash
setfont ter-132b
```

Isso afeta o console atual, sem configurar a fonte do ambiente gráfico posterior.

### 1.2 Modo real do firmware

```bash
if [ -d /sys/firmware/efi ]; then
    echo UEFI
else
    echo BIOS/Legacy
fi
```

`UEFI` corresponde à rota UEFI/GPT da seção 2.3 e ao destino UEFI do gerenciador de inicialização na seção 4.8. `BIOS/Legacy` corresponde à seção 2.4 e ao destino BIOS. Em UEFI, `ls /sys/firmware/efi/efivars` também apresenta a interface de variáveis do firmware usada nas entradas de inicialização. Uma falha de listagem não é uma verificação bem-sucedida do modo de inicialização. A mudança de modo exige nova inicialização pelo pendrive na entrada correspondente do firmware.

### 1.3 Layout do teclado

O teclado de console de referência usa o padrão brasileiro ABNT2:

```bash
loadkeys br-abnt2
```

Outro teclado exige seu próprio mapa; `loadkeys us` é o exemplo americano. `localectl list-keymaps` lista as opções disponíveis. A digitação correta de pontuação e caracteres no prompt confirma um layout adequado. O mapa escolhido será reutilizado em `/etc/vconsole.conf`; o idioma desta documentação não determina o teclado nem o locale do sistema.

### 1.4 Conexão de rede

Redes cabeadas com DHCP normalmente obtêm conexão automaticamente. A configuração sem fio utiliza o prompt interativo `iwctl`, do IWD:

```bash
iwctl
```

Os comandos abaixo funcionam **dentro do iwctl**. `device list` fornece o nome real do dispositivo sem fio; `wlan0` é um exemplo usado de forma consistente. `SSID` representa o nome da rede, com aspas para preservar espaços. A senha é informada no prompt interativo.

```text
device list
station wlan0 scan
station wlan0 get-networks
station wlan0 connect "SSID"
exit
```

De volta ao shell Live:

```bash
ip address
ip route
ping -c 3 google.com
```

Um endereço, uma rota utilizável e respostas bem-sucedidas indicam conectividade funcional. Algumas redes bloqueiam ICMP; por isso, a falha de ping, sozinha, não identifica um problema de DNS. Falhas de resolução de nomes possuem um [procedimento condicional de DNS](https://github.com/guihn/ArchLinux-Installation/tree/main/Portugu%C3%AAs/Solu%C3%A7%C3%A3o%20de%20Problemas#1-resolução-de-dns), com retorno a esta etapa.

### 1.5 Sincronização do relógio

```bash
timedatectl set-ntp true
timedatectl status
```

A sincronização pela rede fornece o horário correto para conexões TLS e validade das assinaturas dos pacotes. O relógio apresentado e o estado da sincronização precisam estar consistentes antes da instalação de pacotes. Erros de assinatura possuem um [procedimento de keyring](https://github.com/guihn/ArchLinux-Installation/tree/main/Portugu%C3%AAs/Solu%C3%A7%C3%A3o%20de%20Problemas#2-assinaturas-de-pacotes-e-keyring) separado; a recriação do chaveiro não é uma etapa rotineira de instalação.

## 2. Particionamento, formatação e montagem

### 2.1 Identificação do disco e sistemas existentes

```bash
lsblk -o NAME,SIZE,MODEL,TYPE,FSTYPE,MOUNTPOINTS
fdisk -l
```

O disco de referência é `/dev/nvme0n1`; suas partições são `/dev/nvme0n1p1`, `/dev/nvme0n1p2` e `/dev/nvme0n1p3`. Um disco SATA normalmente aparece como `/dev/sda`, com partições `/dev/sda1`; `/dev/vda` costuma identificar um disco virtual. Modelo, capacidade e sistemas de arquivos existentes determinam o destino real. Os nomes podem mudar entre computadores e inicializações.

**Os procedimentos de disco novo abaixo destroem os dados existentes nas partições selecionadas. A conclusão do backup e a identificação positiva do destino precedem exclusões, substituição da tabela e formatação.** O pendrive instalador não é o disco de instalação.

No dual boot, as partições do sistema existente permanecem intactas. Uma partição EFI existente e adequada pode ser montada em `/mnt/boot/efi` **sem formatação**. Seu número real substitui `p1` na montagem EFI. O espaço livre recebe o Arch, e todos os comandos de raiz e swap usam os números das novas partições identificadas. A exclusão do disco inteiro não se aplica a esse caso. A detecção do outro sistema pelo GRUB aparece na seção 4.8.

### 2.2 Escolhas de swap e tabela de partições

A swap fornece memória apoiada em disco quando isso é útil à carga de trabalho. A máquina de referência tem 32 GiB de RAM e reserva metade, 16 GiB, para swap.

| Perfil | Tamanho da swap | Uso |
| --- | --- | --- |
| Básico | 8 GiB | Reserva menor opcional. |
| Equilibrado | Metade da RAM; 16 GiB para 32 GiB | Reserva de referência. |
| Reserva maior | 32 GiB | Capacidade adicional opcional quando há espaço em disco. |

São exemplos de configuração, não mínimos universais. Carga de trabalho, RAM e espaço disponível orientam a escolha. Este procedimento não configura hibernação.

As duas rotas principais usam **GPT**. A escolha entre GPT e MBR fica a cargo de quem realiza a instalação, conforme suas necessidades. GPT funciona com GRUB em sistemas BIOS e UEFI compatíveis, mas as partições de inicialização são diferentes. A alternativa BIOS/MBR da seção 2.5 modifica o layout e a numeração; a escolha da tabela e a formatação do sistema de arquivos são operações distintas.

### 2.3 UEFI com GPT

```bash
cfdisk /dev/nvme0n1
```

Em um disco sem tabela, `gpt` seleciona o tipo de tabela. Um disco existente abre sua tabela atual: o tipo precisa ser verificado antes das alterações. Em um disco destinado à instalação com apagamento completo, **Delete** remove as partições antigas, deixando **Free space**. **New** cria cada partição na ordem abaixo; **Type** atribui sua finalidade. **Write**, confirmação com `yes` e **Quit** salvam o layout. Um disco com uma tabela existente indesejada pode ser reinicializado por `fdisk /dev/nvme0n1`, usando `g` para GPT e `w` para gravar, somente após backup e escolha explícita da substituição integral.

| Ordem | Dispositivo | Tamanho | Tipo | Sistema de arquivos e destino |
| --- | --- | --- | --- | --- |
| 1 | `/dev/nvme0n1p1` | 512 MiB (`512M`) | EFI System | FAT32 em `/boot/efi` |
| 2 | `/dev/nvme0n1p2` | 16 GiB (`16G`) | Linux swap | Swap |
| 3 | `/dev/nvme0n1p3` | Espaço restante | Linux filesystem | ext4 em `/`, incluindo `/home` |

Formatação e ativação da swap para essas **partições novas**:

```bash
mkfs.fat -F32 /dev/nvme0n1p1
mkswap /dev/nvme0n1p2
swapon /dev/nvme0n1p2
mkfs.ext4 /dev/nvme0n1p3
```

A raiz é montada primeiro. O diretório EFI é criado dentro dela em seguida:

```bash
mount /dev/nvme0n1p3 /mnt
mkdir -p /mnt/boot/efi
mount /dev/nvme0n1p1 /mnt/boot/efi
```

`/mnt` passa a ser `/` dentro do sistema instalado, e `/mnt/boot/efi` passa a ser `/boot/efi`. Raiz e home compartilham `p3`; não há partição home separada. O kernel e o initramfs ficam em `/boot`, no ext4, enquanto o carregador EFI fica na partição FAT32. Esta rota continua na seção 2.6.

### 2.4 BIOS/Legacy com GPT

Esta rota exige inicialização BIOS/Legacy confirmada e firmware capaz de iniciar pelo disco selecionado. O nome NVMe permanece como exemplo; seu acesso pelo BIOS depende do hardware. A troca da tabela de partições, sozinha, não torna um disco compatível com um firmware que não consegue inicializá-lo.

`cfdisk /dev/nvme0n1` abre o destino. A seleção de GPT, a remoção deliberada das partições antigas, **New**, **Type**, **Write**, `yes` e **Quit** seguem a mesma interface da seção 2.3. O layout é:

| Ordem | Dispositivo | Tamanho | Tipo | Sistema de arquivos e destino |
| --- | --- | --- | --- | --- |
| 1 | `/dev/nvme0n1p1` | 1 MiB (`1M`) | BIOS boot | Sem sistema de arquivos e sem montagem |
| 2 | `/dev/nvme0n1p2` | 16 GiB (`16G`) | Linux swap | Swap |
| 3 | `/dev/nvme0n1p3` | Espaço restante | Linux filesystem | ext4 em `/`, incluindo `/home` |

A partição BIOS boot reserva espaço bruto para a imagem central do GRUB. Ela não é uma partição EFI nem um sistema de arquivos. A formatação afeta apenas swap e raiz:

```bash
mkswap /dev/nvme0n1p2
swapon /dev/nvme0n1p2
mkfs.ext4 /dev/nvme0n1p3
mount /dev/nvme0n1p3 /mnt
```

Não há montagem EFI. Kernel, initramfs e configuração do GRUB ficam em `/boot`, dentro da raiz. O GRUB usará `--target=i386-pc` no **disco inteiro**, mesmo com Arch x86_64. Esse layout segue a [documentação de instalação BIOS do GNU GRUB](https://www.gnu.org/software/grub/manual/grub/html_node/BIOS-installation.html), em inglês, e a [referência de particionamento do Arch](https://wiki.archlinux.org/title/Partitioning_(Portugu%C3%AAs)). Esta rota continua na seção 2.6.

### 2.5 BIOS/Legacy com MBR opcional

MBR é uma alternativa quando necessário pelo firmware ou pela organização pretendida do disco. Seu limite habitual com setores de 512 bytes é aproximadamente 2 TiB, e há quatro entradas de partições primárias; a geometria do disco e outros sistemas operacionais precisam ser considerados. O exemplo principal de BIOS do guia permanece em GPT.

Em um disco destinado ao apagamento integral, `fdisk /dev/nvme0n1`, seguido de `o` e `w`, cria uma tabela MBR/DOS. Isso substitui a tabela e não serve para preservar partições existentes. No `cfdisk`, **dos** é a escolha para um disco sem tabela. Com setores lógicos de 512 bytes, o início padrão no setor 2048 deixa 1 MiB antes da primeira partição para a gravação do GRUB; não há partição BIOS boot.

| Ordem | Dispositivo | Tamanho | Tipo MBR | Sistema de arquivos e destino |
| --- | --- | --- | --- | --- |
| 1 | `/dev/nvme0n1p1` | 16 GiB | Linux swap (`82`) | Swap |
| 2 | `/dev/nvme0n1p2` | Espaço restante | Linux (`83`) | ext4 em `/`, incluindo `/home` |

```bash
mkswap /dev/nvme0n1p1
swapon /dev/nvme0n1p1
mkfs.ext4 /dev/nvme0n1p2
mount /dev/nvme0n1p2 /mnt
```

Esta rota usa o comando de pacotes para BIOS e o mesmo destino de disco inteiro do GRUB BIOS usado em GPT. Seu dispositivo de swap no encerramento é **p1**, não p2. `fdisk -l /dev/nvme0n1` confirma a tabela e os setores iniciais antes da continuação. Os comandos de formatação GPT/UEFI não se aplicam a essa alternativa.

### 2.6 Verificação das montagens

```bash
lsblk -f
findmnt -R /mnt
swapon --show
```

A raiz selecionada precisa aparecer em `/mnt`, e a swap selecionada precisa estar ativa. **Somente UEFI** exige uma partição EFI em `/mnt/boot/efi`. Uma montagem ausente ou incorreta é resolvida antes de `pacstrap`, para que os pacotes cheguem ao sistema de arquivos correto.

## 3. Espelhos e sistema base

### 3.1 Espelhos de pacotes

O Reflector seleciona espelhos sincronizados recentemente e os ordena pela taxa de transferência medida. `Brazil` é o país de referência, configurável para a localização adequada; `reflector --list-countries` lista os nomes aceitos.

```bash
reflector --country Brazil --latest 20 --sort rate --verbose --save /etc/pacman.d/mirrorlist
```

O arquivo `/etc/pacman.d/mirrorlist` resultante fornece os servidores de download. Uma falha na atualização dos espelhos exige conectividade funcional ou outra seleção adequada antes da continuação.

### 3.2 Kernel e pacotes essenciais

`pacstrap` instala pacotes na raiz montada. Linux Zen e seus headers correspondentes formam o kernel de referência; `base-devel` fornece as ferramentas de compilação necessárias posteriormente para AUR e DKMS. `linux-firmware` fornece firmware de dispositivos. Os demais pacotes oferecem espelhos, elevação de privilégios, Neovim, GRUB, rede e Git. O ambiente gráfico é instalado após a primeira inicialização.

**UEFI:**

```bash
pacstrap /mnt base base-devel linux-zen linux-zen-headers linux-firmware \
  reflector sudo neovim grub efibootmgr networkmanager git
```

**BIOS/Legacy, GPT ou MBR:**

```bash
pacstrap /mnt base base-devel linux-zen linux-zen-headers linux-firmware \
  reflector sudo neovim grub networkmanager git
```

Apenas um comando se aplica. `efibootmgr` gerencia entradas UEFI do firmware e não é necessário ao GRUB BIOS. O resultado esperado é uma transação de pacotes concluída sem erros pendentes. Falhas de assinatura possuem retorno pela [solução de problemas de keyring](https://github.com/guihn/ArchLinux-Installation/tree/main/Portugu%C3%AAs/Solu%C3%A7%C3%A3o%20de%20Problemas#2-assinaturas-de-pacotes-e-keyring).

Outro kernel permanece como escolha opcional: `linux` corresponde a `linux-headers`, e `linux-lts` corresponde a `linux-lts-headers`. Essa substituição afeta compilações DKMS, nomes das imagens em `/boot`, verificação do initramfs e entradas do GRUB em todo o guia. Os comandos de referência continuam com Linux Zen.

### 3.3 Montagens persistentes

```bash
genfstab -U /mnt >> /mnt/etc/fstab
cat /mnt/etc/fstab
```

`-U` registra UUIDs dos sistemas de arquivos em vez de nomes variáveis dos dispositivos. O novo arquivo precisa descrever raiz e swap, além de `/boot/efi` em UEFI. A operação de acréscimo acontece uma vez; sua repetição sem revisão duplica entradas. UUIDs e pontos de montagem são conferidos com `lsblk -f` e o layout escolhido.

## 4. Configuração do sistema instalado

### 4.1 Transição para o chroot

```bash
arch-chroot /mnt
```

O chroot muda a raiz utilizada pelos comandos para o sistema instalado. A partir desse ponto, os comandos funcionam como root dentro dele; `/mnt/etc` passa a ser `/etc`. O shell Live só retorna após `exit` na seção 6.2.

### 4.2 Edição com Neovim

`nvim CAMINHO` abre um arquivo. As teclas abaixo são do Neovim e também se aplicam a `EDITOR=nvim visudo`, usado posteriormente:

| Tecla ou comando | Resultado |
| --- | --- |
| `i` | Modo de inserção para digitação. |
| `Esc` | Retorno ao modo normal. |
| `/texto`, seguido de Enter | Pesquisa por texto; `n` alcança a próxima ocorrência. |
| `x` no modo normal | Exclusão do caractere sob o cursor, como um `#` inicial. |
| `:w`, seguido de Enter | Salvamento. |
| `:wq`, seguido de Enter | Salvamento e saída. |
| `:q!`, seguido de Enter | Saída com descarte das alterações não salvas. |

Os exemplos abaixo apresentam arquivos pequenos completos ou trechos identificados explicitamente. O conteúdo não relacionado de um arquivo existente permanece intacto.

### 4.3 Fuso horário e relógio de hardware

O fuso de referência é `America/Sao_Paulo`. Outra região/cidade é selecionada em `/usr/share/zoneinfo`; nomes compostos usam a grafia real do caminho, como o sublinhado de `Sao_Paulo`.

```bash
ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
hwclock --systohc
```

O link simbólico seleciona o horário civil local. `hwclock --systohc` grava o horário sincronizado do sistema no relógio de hardware e estabelece suas informações de ajuste; UTC é a referência para esse relógio no Linux. Dual boot exige tratamento consistente do relógio de hardware entre os sistemas.

### 4.4 Locales e teclado do console

```bash
nvim /etc/locale.gen
```

O sistema de referência utiliza inglês. O **trecho** correspondente passa de `#en_US.UTF-8 UTF-8` para:

```text
en_US.UTF-8 UTF-8
```

`pt_BR.UTF-8 UTF-8` é um locale adicional opcional quando necessário. Vários locales podem ser gerados, enquanto um é selecionado como padrão:

```bash
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "KEYMAP=br-abnt2" > /etc/vconsole.conf
```

O valor de `LANG` precisa corresponder a um locale gerado. Para um sistema em português, a escolha correspondente é `LANG=pt_BR.UTF-8`, depois da ativação e geração desse locale. `KEYMAP` corresponde ao layout de console da seção 1.3; um teclado americano usa `KEYMAP=us`. O idioma da documentação não modifica esses valores de referência.

### 4.5 Hostname e arquivo hosts

`secura` é o nome de referência da máquina. Outro hostname substitui esse valor de forma consistente nos dois arquivos; marcadores como `myhostname` representam o nome escolhido, sem exigir esse texto literal.

```bash
echo "secura" > /etc/hostname
nvim /etc/hosts
```

As entradas correspondentes de hosts são:

```text
127.0.0.1   localhost
::1         localhost
127.0.1.1   secura.localdomain secura
```

Essas entradas resolvem nomes locais. Outras entradas existentes permanecem intactas. O hostname identifica a máquina na administração local e nos mecanismos de descoberta de rede compatíveis.

### 4.6 Configuração do pacman

```bash
nvim /etc/pacman.conf
```

Os exemplos a seguir são **trechos**, sem substituir o arquivo inteiro. Em `[options]`, as opções relevantes ficam assim:

```ini
[options]
Color
ILoveCandy
ParallelDownloads = 10
```

`#Color` passa a ser `Color`; `ILoveCandy` é adicionado imediatamente abaixo. O valor existente de `ParallelDownloads` passa a ser `10`. Color ativa a saída colorida, ILoveCandy altera a animação de progresso e ParallelDownloads permite transferências simultâneas. Dez é a preferência de referência; uma rede mais lenta pode se beneficiar de um valor menor.

O trecho do repositório passa de:

```ini
#[multilib]
#Include = /etc/pacman.d/mirrorlist
```

para:

```ini
[multilib]
Include = /etc/pacman.d/mirrorlist
```

As duas linhas precisam estar ativas. Multilib fornece software de 32 bits, incluindo os utilitários NVIDIA `lib32` da referência. As demais opções e os outros repositórios do pacman permanecem presentes.

### 4.7 Initramfs base

O initramfs é a imagem do ambiente inicial utilizada antes da disponibilidade do sistema de arquivos raiz real. A imagem base precisa ser gerada com sucesso para o kernel Linux Zen instalado:

```bash
mkinitcpio -P
ls -lh /boot/vmlinuz-linux-zen /boot/initramfs-linux-zen.img
```

Nesta etapa, `/etc/mkinitcpio.conf` não exige módulos NVIDIA ainda não instalados. Erros de módulo ausente ou de geração precisam ser resolvidos antes da inicialização. O array específico da NVIDIA será configurado somente após a instalação bem-sucedida dos drivers e a compilação DKMS na Pós Instalação.

### 4.8 Instalação e menu do GRUB

O destino corresponde à rota de firmware identificada na seção 1.2.

**UEFI:**

```bash
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=ArchLinux
```

**BIOS/Legacy, GPT ou MBR:**

```bash
grub-install --target=i386-pc /dev/nvme0n1
```

O destino BIOS é o disco de inicialização inteiro, nunca `p1`, `p2` ou `p3`. GPT utiliza sua partição BIOS boot sem formatação; MBR utiliza o espaço reservado antes da primeira partição. Uma falha na gravação ou nas variáveis do firmware é resolvida antes da geração da configuração.

```bash
nvim /etc/default/grub
```

O **trecho** relevante é:

```bash
GRUB_TIMEOUT_STYLE=menu
GRUB_TIMEOUT=-1
GRUB_CMDLINE_LINUX_DEFAULT="quiet loglevel=3 nvidia-drm.modeset=1 nvidia-drm.fbdev=1"
```

`GRUB_TIMEOUT=-1` deixa o menu aguardando **seleção manual da entrada**. `quiet` e `loglevel=3` reduzem a saída rotineira; sua remoção é útil durante diagnóstico. Os parâmetros NVIDIA configuram modesetting DRM e framebuffer do driver de referência quando seus módulos estão disponíveis; eles não instalam nem incluem esses módulos na imagem. Outra GPU não herda automaticamente esses parâmetros específicos.

<details>
<summary>Detecção opcional de dual boot</summary>

A detecção de outro sistema pelo GRUB utiliza `os-prober`, instalado no chroot com atualização completa:

```bash
pacman -Syu os-prober
```

A linha correspondente em `/etc/default/grub` fica assim:

```bash
GRUB_DISABLE_OS_PROBER=false
```

As partições do outro sistema precisam estar disponíveis para detecção, com o Windows completamente desligado quando aplicável. A saída da descoberta é conferida durante a geração da configuração. Uma partição EFI existente é reutilizada sem formatação; o modo do firmware precisa ser compatível com o outro sistema. Uma atualização do kernel nessa transação opcional exige geração bem-sucedida do initramfs antes da reinicialização.

</details>

```bash
grub-mkconfig -o /boot/grub/grub.cfg
```

A geração precisa encontrar Linux Zen e seu initramfs. Alterações em `/etc/default/grub` só entram em vigor após a regeneração. O [manual de configuração do GNU GRUB](https://www.gnu.org/software/grub/manual/grub/html_node/Simple-configuration.html), em inglês, detalha essas opções.

## 5. Contas e acesso administrativo

### 5.1 Senha de root

```bash
passwd
```

O prompt recebe e confirma a senha de root sem mostrar seus caracteres. Root é a conta administrativa; no procedimento de referência, sua senha é distinta da credencial da conta comum.

### 5.2 Conta comum

`guihnxz` é o nome de conta de referência. Outro nome escolhido o substitui de forma consistente na criação, na atribuição de senha e em caminhos explícitos de home. `username` é um marcador para esse nome.

```bash
useradd -m -G wheel,audio,video,storage,input -s /bin/bash guihnxz
passwd guihnxz
```

`-m` cria o diretório pessoal; `-G` atribui grupos suplementares; `-s` seleciona o shell inicial. `wheel` serve à autorização do sudo. Os grupos adicionais de acesso a dispositivos fazem parte desta configuração pessoal de referência; outra organização de gerenciamento de sessão pode não precisar de todos eles. Bash está disponível nesta etapa; Zsh será selecionado após sua instalação.

### 5.3 Permissões de sudo

```bash
EDITOR=nvim visudo
```

`visudo` verifica a sintaxe de sudoers. A linha padrão com autenticação por senha fica ativa após a remoção do `#` inicial:

```text
%wheel ALL=(ALL:ALL) ALL
```

<details>
<summary>Preferência pessoal opcional: sudo sem senha</summary>

A linha alternativa permite que membros de wheel executem qualquer comando sem uma solicitação de senha pelo sudo:

```text
%wheel ALL=(ALL:ALL) NOPASSWD: ALL
```

Ela substitui a escolha autenticada por senha, sem exigir as duas entradas simultâneas. Isso remove uma etapa de autenticação dos comandos privilegiados e permanece opcional.

</details>

## 6. Primeira inicialização

### 6.1 Serviço de rede

```bash
systemctl enable NetworkManager
```

Isso habilita o serviço para a próxima inicialização do sistema instalado. A rede Live já é fornecida pelo ambiente de instalação. O gerenciador de login será instalado e habilitado posteriormente.

### 6.2 Saída do chroot e desmontagem

Nas duas rotas **GPT**, swap corresponde a `p2`. O primeiro comando abaixo funciona dentro do chroot; depois, `exit` retorna ao shell Live:

```bash
swapoff /dev/nvme0n1p2
exit
```

No layout **MBR** opcional, o comando é `swapoff /dev/nvme0n1p1`. Uma falha na desativação da swap exige atenção ao uso de memória antes da continuação.

No shell Live, a desmontagem recursiva libera a raiz e sua eventual montagem EFI interna:

```bash
umount -R /mnt
reboot
```

Um erro de montagem ocupada exige a saída dos diretórios e processos que utilizam `/mnt` antes de nova tentativa. Após a desmontagem bem-sucedida e a reinicialização, o firmware inicia pelo disco instalado em vez do pendrive. O GRUB aguarda a seleção manual da entrada do Arch. O login no console resultante leva à [Pós Instalação](https://github.com/guihn/ArchLinux-Installation/tree/main/Portugu%C3%AAs/P%C3%B3s%20Instala%C3%A7%C3%A3o).

[Anterior](https://github.com/guihn/ArchLinux-Installation/tree/main/Portugu%C3%AAs/Prepara%C3%A7%C3%A3o) · [Índice](https://github.com/guihn/ArchLinux-Installation/tree/main/Portugu%C3%AAs) · [Próximo](https://github.com/guihn/ArchLinux-Installation/tree/main/Portugu%C3%AAs/P%C3%B3s%20Instala%C3%A7%C3%A3o)
