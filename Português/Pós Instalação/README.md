<table width="100%">
<tr>
<td align="left" width="5000"><strong>Português</strong> | <a href="https://github.com/guihn/ArchLinux-Installation/tree/main/English/Post%20Installation">English</a></td>
<td align="right" width="5000"><a href="https://github.com/guihn/ArchLinux-Installation/tree/main/Portugu%C3%AAs/Instala%C3%A7%C3%A3o">Anterior</a> | <a href="https://github.com/guihn/ArchLinux-Installation/tree/main/Portugu%C3%AAs">Índice</a> | <a href="https://github.com/guihn/ArchLinux-Installation/tree/main/Portugu%C3%AAs/Hyprland">Próximo</a></td>
</tr>
</table>

# Pós Instalação

O sistema instalado chegou ao login em console após a seleção manual no GRUB. Esta seção funciona pela conta comum criada na [Instalação](https://github.com/guihn/ArchLinux-Installation/tree/main/Portugu%C3%AAs/Instala%C3%A7%C3%A3o), com `sudo` para comandos administrativos. Ela instala o ambiente gráfico, verifica os módulos gráficos e prepara a primeira sessão pelo Ly.

## 1. Login e rede

### 1.1 Entrada na conta

A conta de referência é `guihnxz`; outra conta escolhida utiliza o nome correspondente. A entrada de senha não mostra caracteres. O login bem-sucedido abre o shell Bash inicial no diretório pessoal. As compilações AUR funcionam nessa conta comum, não como root.

### 1.2 Conexão pelo NetworkManager

```bash
nmtui
```

**Activate a connection** lista as conexões disponíveis. A seleção da rede sem fio abre a solicitação de senha; uma conexão cabeada por DHCP pode já estar ativa. A navegação utiliza setas, Tab e Enter. Após a saída da interface:

```bash
nmcli general status
ping -c 3 google.com
```

Falhas de resolução de nomes possuem retorno pela [solução de problemas de DNS](https://github.com/guihn/ArchLinux-Installation/tree/main/Portugu%C3%AAs/Solu%C3%A7%C3%A3o%20de%20Problemas#1-resolução-de-dns). O NetworkManager gerencia o sistema instalado; as instruções Live de `iwctl` não são repetidas como configuração persistente dessa rede.

## 2. Espelhos e atualização completa

### 2.1 Seleção de espelhos

`Brazil` permanece como país de referência configurável. O Reflector atualiza a lista do próprio sistema instalado:

```bash
sudo reflector --country Brazil --latest 20 --sort rate --verbose --save /etc/pacman.d/mirrorlist
sudo pacman -Syu
```

O primeiro comando precisa terminar com sucesso antes do segundo. `-Syu` atualiza os bancos dos repositórios e todos os pacotes instalados. Um `pacman -Sy` isolado, seguido da instalação de outros pacotes, pode criar uma atualização parcial sem suporte. Uma atualização com falha é resolvida antes das instalações seguintes; a [solução de problemas de keyring](https://github.com/guihn/ArchLinux-Installation/tree/main/Portugu%C3%AAs/Solu%C3%A7%C3%A3o%20de%20Problemas#2-assinaturas-de-pacotes-e-keyring) trata erros reais de assinatura.

### 2.2 Consistência do kernel

```bash
pacman -Q linux-zen linux-zen-headers
uname -r
```

O pacote do kernel e seus headers precisam corresponder. `uname -r` identifica o kernel **em execução**, que pode ser diferente da versão recém-instalada após uma atualização. As verificações de DKMS e initramfs abaixo se referem ao **kernel instalado que será iniciado**, não apenas à versão em execução.

## 3. Auxiliar da AUR

### 3.1 Código do yay e compilação

A Arch User Repository (AUR) hospeda receitas de compilação mantidas pela comunidade. O yay coordena sua compilação e instalação. O diretório de clones de referência é `~/GitClones`; outro diretório é possível quando os caminhos seguintes correspondem.

```bash
mkdir -p ~/GitClones
cd ~/GitClones
git clone https://aur.archlinux.org/yay.git
cd yay
nvim PKGBUILD
makepkg -si
cd ~
```

O PKGBUILD descreve as fontes baixadas e as ações de compilação. `makepkg -si` instala dependências de compilação ausentes, compila o pacote pela conta comum e utiliza sudo quando a instalação exige. A compilação precisa terminar com sucesso. Um clone existente é atualizado no próprio diretório, sem uma nova clonagem sobre ele.

### 3.2 Dependências temporárias de compilação

A resposta de referência é **Sim** quando o yay oferece remoção das dependências temporárias de compilação **após uma instalação bem-sucedida**. Elas atendem à compilação; as dependências de execução continuam necessárias ao programa instalado. Pacotes utilizados por outros programas, `base-devel` e os headers do Linux Zen necessários ao DKMS permanecem instalados. Uma dependência temporária removida pode ser instalada novamente em uma compilação futura. A remoção não significa excluir dependências arbitrárias nem forçar a retirada de pacotes.

## 4. Driver NVIDIA e carregamento antecipado

### 4.1 Hardware e escolha do driver

A placa NVIDIA de referência é a GTX 750 Ti, Maxwell GM107. Seu grupo de drivers utiliza a série proprietária 580xx, em vez dos módulos abertos destinados às gerações compatíveis mais novas. A [documentação NVIDIA do Arch](https://wiki.archlinux.org/title/NVIDIA_(Portugu%C3%AAs)) e o [aviso de transição dos drivers](https://archlinux.org/news/nvidia-590-driver-drops-pascal-support-main-packages-switch-to-open-kernel-modules/), em inglês, identificam as famílias correspondentes.

Outra GPU exige seu grupo de pacotes compatível e as configurações correspondentes de módulos e kernel. Os pacotes 580xx não são uma escolha universal para NVIDIA. Os gráficos integrados AMD recebem o conjunto Mesa na seção 5.

### 4.2 Transação única e verificação do DKMS

```bash
yay -S nvidia-580xx-dkms nvidia-580xx-utils lib32-nvidia-580xx-utils
pacman -Q linux-zen linux-zen-headers
dkms status
```

Os três pacotes NVIDIA são instalados juntos para manter versões compatíveis. Multilib já precisa estar ativo. O DKMS compila os módulos externos contra os headers correspondentes instalados. A saída precisa mostrar o módulo NVIDIA como **installed** para cada kernel Linux Zen que será utilizado. Uma falha de compilação é resolvida antes da configuração de carregamento antecipado ou da reinicialização; o log fica no diretório correspondente em `/var/lib/dkms/`.

Os diretórios das versões instaladas aparecem em `/usr/lib/modules/`. Para uma versão específica, o diagnóstico abaixo utiliza o nome completo do diretório no lugar de `KERNEL_RELEASE`:

```bash
ls /usr/lib/modules
modinfo -k KERNEL_RELEASE nvidia
```

`KERNEL_RELEASE` é um marcador de substituição, não uma versão literal. O sucesso de `modinfo` identifica o arquivo do módulo para o kernel instalado escolhido. O driver não precisa estar carregado no kernel antigo em execução para que uma imagem válida seja produzida para o novo.

### 4.3 Configuração dos módulos e geração da imagem

Somente após a instalação bem-sucedida dos drivers e a verificação do DKMS:

```bash
sudo nvim /etc/mkinitcpio.conf
```

O **trecho** de referência é:

```bash
MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)
```

Esse array solicita a inclusão antecipada dos módulos NVIDIA. Outros módulos exigidos por uma organização diferente de armazenamento ou hardware continuam pertencendo à configuração correspondente. Após a edição:

```bash
sudo mkinitcpio -P
sudo lsinitcpio /boot/initramfs-linux-zen.img | grep -E 'nvidia(_modeset|_uvm|_drm)?\.ko'
```

A geração precisa terminar sem erros de módulos ausentes, e a inspeção precisa identificar os quatro arquivos de módulo NVIDIA, possivelmente compactados. A edição de `MODULES`, sozinha, não modifica uma imagem existente. Um hook de pacote pode gerar a imagem durante a instalação, mas uma edição posterior exige essa nova geração. Outro kernel escolhido utiliza o nome de imagem correspondente.

## 5. Ambiente gráfico e pacotes de apoio

### 5.1 Grupo de pacotes de referência

```bash
sudo pacman -S \
  amd-ucode \
  mesa vulkan-radeon libva-mesa-driver \
  pipewire wireplumber pipewire-alsa pipewire-pulse \
  bluez bluez-utils \
  foot yazi \
  waybar \
  wl-clipboard cliphist \
  hyprland hypridle hyprpaper hyprpolkitagent hyprtoolkit hyprlauncher hyprshot \
  xdg-desktop-portal-hyprland xdg-user-dirs xorg-xwayland \
  fastfetch imagemagick ly \
  ttf-hack-nerd noto-fonts-emoji zsh \
  wofi brightnessctl qt5ct
```

`amd-ucode` fornece microcódigo da CPU AMD, não um driver gráfico AMD. Mesa oferece OpenGL e VA-API; `libva-mesa-driver` é um nome fornecido pelo empacotamento atual do Mesa. `vulkan-radeon` fornece o driver Vulkan AMD. CPUs Intel ou outras GPUs exigem as escolhas correspondentes, em vez de uma cópia universal do conjunto de hardware de referência.

O [Perfil do Sistema](https://github.com/guihn/ArchLinux-Installation/tree/main/Portugu%C3%AAs/Perfil%20do%20Sistema) relaciona cada componente com seus pacotes e função. PipeWire, WirePlumber e os pacotes de compatibilidade fornecem áudio; BlueZ fornece Bluetooth; portais integram aplicativos com a sessão Wayland; XWayland oferece suporte a aplicativos X11.

### 5.2 Dependências das configurações

| Pacote | Uso na configuração |
| --- | --- |
| `wofi` | Menu para selecionar um item do histórico da área de transferência. |
| `brightnessctl` | Comandos das teclas de brilho em dispositivos com iluminação compatível. |
| `qt5ct` | Opção `QT_QPA_PLATFORMTHEME=qt5ct` para aplicativos Qt 5. |

`playerctl` é um controlador de mídia, não um servidor de áudio nem um reprodutor. Seus comandos se comunicam com aplicativos como Spotify por MPRIS. As teclas de brilho não controlam automaticamente todo monitor externo; o suporte do hardware determina seu efeito. A opção de tema Qt 5 não implica configuração de todos os aplicativos Qt 6.

### 5.3 Ecossistema Hyprland

O Hypridle gerencia inatividade: a referência apaga os monitores após 60 segundos e os religa com atividade, sem tela de bloqueio. O Hyprpolkitagent fornece solicitações gráficas de autenticação e inicia como serviço de usuário pela sessão. O Hyprlauncher é o iniciador de aplicativos e utiliza seu daemon pelo autostart. O Hyprtoolkit fornece infraestrutura comum de temas aos aplicativos que o utilizam.

Hyprpaper e Waybar são processos opcionais de papel de parede e barra no exemplo pessoal completo. Um papel de parede exige uma imagem existente e uma configuração correspondente do hyprpaper; sua seleção é independente da configuração central do compositor. O tema monocromático pessoal do hyprtoolkit permanece como personalização opcional planejada.

## 6. Aplicativos e shell

### 6.1 Aplicativos adicionais

```bash
yay -S vscodium-bin spotify pwvucontrol brave-nightly-bin
```

O grupo de referência contém VSCodium, Spotify, a interface de volume PipeWire e Brave Nightly. O yay pode resolver pacotes dos repositórios oficiais e receitas AUR; a origem real aparece na transação. São escolhas pessoais de aplicativos. Alternativas podem substituí-las, com adaptação dos comandos e das entradas de inicialização dependentes.

Discord é opcional, mas seu pacote é necessário antes da ativação da linha de inicialização do Discord na configuração pessoal:

```bash
sudo pacman -S discord
```

### 6.2 Seleção do Zsh

```bash
chsh -s /bin/zsh
```

O comando altera o shell de login da conta atual após a instalação do Zsh. Um novo login aplica a mudança. Bash permanece como alternativa válida; nesse caso, o exemplo opcional de Fastfetch pertence ao arquivo interativo do shell correspondente, em vez de `.zshrc`.

## 7. Serviços e preparação da inicialização

### 7.1 Bluetooth, Ly e diretórios pessoais

```bash
sudo systemctl enable bluetooth
sudo systemctl disable getty@tty2.service
sudo systemctl enable ly@tty2
xdg-user-dirs-update
```

A ativação do Bluetooth é opcional quando a máquina não o utiliza. A referência o habilita para a próxima inicialização; o [procedimento de Bluetooth](https://github.com/guihn/ArchLinux-Installation/tree/main/Portugu%C3%AAs/Solu%C3%A7%C3%A3o%20de%20Problemas#3-bluetooth) cobre ativação do adaptador e pareamento. O Ly utiliza o TTY 2. A desativação do getty separado nesse TTY evita disputa pelo mesmo console de login, conforme a [documentação do Ly](https://github.com/fairyglade/ly), em inglês. Outro gerenciador de login exige seu próprio serviço, sem ativação simultânea com Ly.

`xdg-user-dirs-update` cria diretórios pessoais padronizados conforme o locale configurado. Ele funciona pela conta comum.

### 7.2 Imagens e configuração finais

O grupo de pacotes inclui microcódigo da CPU e pode disparar atualizações das imagens. Uma geração final após todos os pacotes relevantes estabelece os arquivos de inicialização e as entradas atuais do GRUB:

```bash
sudo mkinitcpio -P
sudo grub-mkconfig -o /boot/grub/grub.cfg
systemctl is-enabled NetworkManager ly@tty2
```

A geração bem-sucedida e as entradas corretas precedem a próxima inicialização. Os módulos NVIDIA precisam continuar disponíveis para o kernel escolhido. O GRUB mantém seu menu de seleção manual por tempo indeterminado.

### 7.3 Sessão gráfica

```bash
reboot
```

Após a seleção manual no GRUB, o Ly apresenta os campos de login e sessão. A sessão Hyprland corresponde à conta comum. O pacote instalado fornece sua configuração inicial quando necessário; a próxima seção a substitui pela referência modular somente após backup e adaptação.

O resultado é um conjunto gráfico instalado. [Hyprland](https://github.com/guihn/ArchLinux-Installation/tree/main/Portugu%C3%AAs/Hyprland) continua com implantação dos arquivos de configuração, monitores, entrada e verificação da sessão.

[Anterior](https://github.com/guihn/ArchLinux-Installation/tree/main/Portugu%C3%AAs/Instala%C3%A7%C3%A3o) · [Índice](https://github.com/guihn/ArchLinux-Installation/tree/main/Portugu%C3%AAs) · [Próximo](https://github.com/guihn/ArchLinux-Installation/tree/main/Portugu%C3%AAs/Hyprland)
