<table width="100%">
<tr>
<td align="left" width="5000"><strong>Português</strong> | <a href="https://github.com/guihn/ArchLinux-Installation/tree/main/English/System%20Profile">English</a></td>
<td align="right" width="5000"><a href="https://github.com/guihn/ArchLinux-Installation/tree/main/Portugu%C3%AAs">Índice</a></td>
</tr>
</table>

# Perfil do Sistema

Esta referência opcional descreve hardware, software e escolhas pessoais utilizados nos exemplos. Ela fica disponível para esclarecimento fora da sequência obrigatória. A [Preparação](https://github.com/guihn/ArchLinux-Installation/tree/main/Portugu%C3%AAs/Prepara%C3%A7%C3%A3o) é o início do procedimento.

## Hardware e monitores

| Item | Referência |
| --- | --- |
| CPU | AMD Ryzen 9 9900X, Zen 5, 12 núcleos / 24 threads |
| GPU dedicada | NVIDIA GTX 750 Ti, Maxwell GM107 |
| GPU integrada | Gráficos AMD integrados ao Ryzen 9 9900X |
| RAM | 32 GiB |
| Exemplo de armazenamento | `/dev/nvme0n1`; identificação real estabelecida antes das operações |
| Monitor principal | Monitor de 144 Hz, configurado em 1920×1080 a 120 Hz na referência |
| Monitor secundário | Monitor de 75 Hz, configurado em 2560×1080 a 74,99 Hz, rotacionado |
| Saídas de referência | `HDMI-A-2` em `0x0`; `HDMI-A-1` em `-1080x0` com `transform = 1` |

Os nomes das saídas e os modos descrevem uma organização específica de conexões. A identificação real das GPUs vem do inventário de hardware; `hyprctl monitors all` e `hyprctl devices` descrevem monitores e dispositivos de entrada da sessão. As taxas disponíveis dependem do conjunto de GPU, conector, cabo e monitor.

## Componentes do sistema

| Componente | Função | Pacote(s) |
| --- | --- | --- |
| Base do Arch | Ambiente essencial de usuário | `base` |
| Ferramentas de compilação | AUR e módulos externos | `base-devel` |
| Linux Zen | Kernel e headers correspondentes | `linux-zen`, `linux-zen-headers` |
| Firmware | Firmware de dispositivos | `linux-firmware` |
| Microcódigo AMD | Atualizações de microcódigo da CPU | `amd-ucode` |
| GRUB | Gerenciador de inicialização | `grub` |
| Gerenciador EFI | Entradas UEFI do firmware | `efibootmgr` |
| Descoberta de sistemas | Detecção opcional de dual boot | `os-prober` |
| NetworkManager | Rede do sistema e interface de texto | `networkmanager` |
| Reflector | Seleção de espelhos | `reflector` |
| Sudo | Autorização administrativa | `sudo` |
| Neovim | Editor de configuração, iniciado por `nvim` | `neovim` |
| Git | Clones de fontes e do guia | `git` |
| Yay | Auxiliar de compilação/instalação AUR | `yay` |
| NVIDIA 580xx | Driver e utilitários da GTX 750 Ti | `nvidia-580xx-dkms`, `nvidia-580xx-utils`, `lib32-nvidia-580xx-utils` |
| DKMS | Gerenciamento de compilação de módulos externos | `dkms` |
| Mesa e RADV | Gráficos AMD e aceleração de vídeo | `mesa`, `vulkan-radeon`, `libva-mesa-driver` |
| PipeWire | Servidor de áudio e compatibilidade ALSA/PulseAudio | `pipewire`, `pipewire-alsa`, `pipewire-pulse` |
| WirePlumber | Gerenciamento da sessão de áudio e `wpctl` | `wireplumber` |
| BlueZ | Serviço Bluetooth e `bluetoothctl` | `bluez`, `bluez-utils` |
| foot | Terminal Wayland | `foot` |
| Yazi | Gerenciador de arquivos em terminal | `yazi` |
| Waybar | Barra opcional | `waybar` |
| Área de transferência | Cópia, colagem e histórico | `wl-clipboard`, `cliphist`, `wofi` |
| Hyprland | Compositor Wayland | `hyprland` |
| Hypridle | Tratamento de inatividade dos monitores | `hypridle` |
| Hyprpaper | Processo opcional de papel de parede | `hyprpaper` |
| Hyprpolkitagent | Agente gráfico de autorização | `hyprpolkitagent` |
| Hyprtoolkit | Infraestrutura compartilhada de temas | `hyprtoolkit` |
| Hyprlauncher | Iniciador de aplicativos | `hyprlauncher` |
| Hyprshot | Capturas de tela | `hyprshot` |
| Portal do ambiente | Integração de aplicativos Wayland | `xdg-desktop-portal-hyprland` |
| Diretórios de usuário | Diretórios pessoais padronizados | `xdg-user-dirs` |
| XWayland | Compatibilidade com aplicativos X11 | `xorg-xwayland` |
| Fastfetch | Relatório opcional no terminal | `fastfetch` |
| ImageMagick | Ferramentas de imagem | `imagemagick` |
| Ly | Gerenciador de login em console | `ly` |
| Fontes | Símbolos Nerd Font e emoji | `ttf-hack-nerd`, `noto-fonts-emoji` |
| Zsh | Shell de login e interativo | `zsh` |
| Controle de brilho | Teclas de iluminação compatível | `brightnessctl` |
| Configuração Qt 5 | Preferência de tema Qt 5 | `qt5ct` |
| VSCodium | Editor de código | `vscodium-bin` |
| Spotify | Aplicativo pessoal de mídia | `spotify` |
| Controle de volume PipeWire | Interface gráfica de volume | `pwvucontrol` |
| Brave Nightly | Navegador pessoal | `brave-nightly-bin` |
| Discord | Aplicativo pessoal opcional de comunicação | `discord` |

O empacotamento atual do Mesa fornece `libva-mesa-driver`; ele não representa uma segunda instalação independente do Mesa. DKMS integra a cadeia de dependências do driver. A tabela descreve funções; os comandos de instalação aparecem cronologicamente na Instalação e na Pós Instalação.

## Valores de referência

| Configuração | Valor e adaptação |
| --- | --- |
| Firmware e tabela | Rota principal UEFI/GPT; alternativa BIOS/GPT com partição de inicialização própria |
| Raiz e home | Juntas em ext4, sem partição `/home` separada |
| Swap | Perfil equilibrado de 16 GiB para 32 GiB RAM; alternativas de 8 GiB e 32 GiB |
| Menu GRUB | `GRUB_TIMEOUT=-1`, aguardando seleção manual |
| Teclado do console | `br-abnt2`; outro teclado exige o mapa correspondente |
| Teclado gráfico | `br` com `abnt2`, selecionado pelas opções XKB |
| País dos espelhos | `Brazil`, configurável para a localização adequada |
| Fuso horário | `America/Sao_Paulo`, configurável para região/cidade |
| Locale | `en_US.UTF-8` gerado e mesmo `LANG`; `pt_BR.UTF-8` é alternativa |
| Hostname | `secura`, substituído consistentemente quando há outro nome |
| Conta | `guihnxz`, substituído nos comandos e caminhos explícitos |
| Inatividade | Monitores apagados após 60 segundos, religados com entrada; sem bloqueio |
| Inicialização pessoal | Spotify e Discord no espaço opcional `magic` |

O procedimento correspondente repete a orientação de adaptação no uso de cada valor. Inicialização pessoal, aparência e preferências de shell aparecem na [Personalização](https://github.com/guihn/ArchLinux-Installation/tree/main/Portugu%C3%AAs/Personaliza%C3%A7%C3%A3o).

[Índice](https://github.com/guihn/ArchLinux-Installation/tree/main/Portugu%C3%AAs)
