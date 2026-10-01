<table width="100%">
<tr>
<td align="left" width="5000"><strong>Português</strong> | <a href="https://github.com/guihn/ArchLinux-Installation/tree/main/English/References">English</a></td>
<td align="right" width="5000"><a href="https://github.com/guihn/ArchLinux-Installation/tree/main/Portugu%C3%AAs">Índice</a></td>
</tr>
</table>

# Referências

Estas referências fundamentam os procedimentos e formatos de configuração do guia. Arch Linux e Hyprland evoluem continuamente; a versão instalada e a documentação correspondente determinam a sintaxe aplicável. A instalação começa na [Preparação](https://github.com/guihn/ArchLinux-Installation/tree/main/Portugu%C3%AAs/Prepara%C3%A7%C3%A3o), e as falhas possuem retornos específicos na [Solução de Problemas](https://github.com/guihn/ArchLinux-Installation/tree/main/Portugu%C3%AAs/Solu%C3%A7%C3%A3o%20de%20Problemas).

## Instalação e armazenamento

| Referência | Assunto |
| --- | --- |
| [Downloads do Arch](https://archlinux.org/download/) — inglês | ISO atual, espelhos, checksums e assinaturas. |
| [Guia de instalação do Arch](https://wiki.archlinux.org/title/Installation_guide_(Portugu%C3%AAs)) | Ambiente Live, sistema base e primeira inicialização. |
| [Particionamento](https://wiki.archlinux.org/title/Partitioning_(Portugu%C3%AAs)) | GPT/MBR e layouts específicos do firmware. |
| [GRUB no Arch](https://wiki.archlinux.org/title/GRUB_(Portugu%C3%AAs)) | Instalação do gerenciador em BIOS e UEFI. |
| [Instalação BIOS do GNU GRUB](https://www.gnu.org/software/grub/manual/grub/html_node/BIOS-installation.html) — inglês | Partição BIOS boot e espaço de gravação no MBR. |
| [Configuração simples do GNU GRUB](https://www.gnu.org/software/grub/manual/grub/html_node/Simple-configuration.html) — inglês | Tempo de espera e geração do menu. |
| [Downloads do Ventoy](https://www.ventoy.net/en/download.html) — inglês | Arquivos de instalação e verificação. |
| [Introdução ao Ventoy](https://www.ventoy.net/en/doc_start.html) — inglês | Preparação USB e cópia de ISOs. |

## Pacotes, drivers e serviços

| Referência | Assunto |
| --- | --- |
| [Manutenção do sistema](https://wiki.archlinux.org/title/System_maintenance_(Portugu%C3%AAs)) | Atualizações completas e limitações das atualizações parciais. |
| [Assinaturas de pacotes](https://wiki.archlinux.org/title/Pacman/Package_signing) — inglês | Verificação do keyring e recuperação condicional. |
| [NetworkManager](https://wiki.archlinux.org/title/NetworkManager_(Portugu%C3%AAs)) | Rede instalada e DNS. |
| [NVIDIA](https://wiki.archlinux.org/title/NVIDIA_(Portugu%C3%AAs)) | Seleção do driver conforme o hardware. |
| [Transição dos drivers NVIDIA](https://archlinux.org/news/nvidia-590-driver-drops-pascal-support-main-packages-switch-to-open-kernel-modules/) — inglês | Maxwell/Pascal e série 580xx. |
| [Configuração do mkinitcpio](https://github.com/archlinux/mkinitcpio/blob/master/man/mkinitcpio.conf.5.adoc) — inglês | MODULES e opções de geração das imagens. |
| [Tratamento de módulos do mkinitcpio](https://github.com/archlinux/mkinitcpio/blob/master/functions) — inglês | Erros de módulos ausentes e inclusão nas imagens. |
| [Hook de pacotes do mkinitcpio](https://github.com/archlinux/mkinitcpio/blob/master/libalpm/hooks/90-mkinitcpio-install.hook) — inglês | Geração automática após transações relevantes. |
| [Ly](https://github.com/fairyglade/ly) — inglês | Serviço do gerenciador de login e requisitos de TTY. |
| [Playerctl](https://github.com/altdesktop/playerctl) — inglês | Comandos de reprodução e faixas por MPRIS. |
| [Instalação do Yazi](https://yazi-rs.github.io/docs/installation/) — inglês | Requisitos do gerenciador de arquivos em terminal. |
| [Manual do foot](https://man.archlinux.org/man/extra/foot/foot.1.en) — inglês | Execução de comandos pelo terminal. |

## Configuração do Hyprland

As referências oficiais abaixo estão em inglês. A coluna de assunto e as seções correspondentes do guia explicam seu uso em português.

| Referência | Assunto |
| --- | --- |
| [Ponto de entrada](https://wiki.hypr.land/Configuring/Start/) | Lua, módulos e seleção de versão. |
| [Monitores](https://wiki.hypr.land/Configuring/Basics/Monitors/) | Saídas, modos, escala, posição e rotação. |
| [Autostart](https://wiki.hypr.land/Configuring/Basics/Autostart/) | Callbacks de inicialização da sessão. |
| [Variáveis de ambiente](https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/) | Ambiente da sessão. |
| [Permissões](https://wiki.hypr.land/Configuring/Advanced-and-Cool/Permissions/) | Regras de permissão e necessidade de reinicialização. |
| [Variáveis](https://wiki.hypr.land/Configuring/Basics/Variables/) | Opções gerais, decoração, entrada e configurações diversas. |
| [Animações](https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/) | Curvas e propriedades de animação. |
| [Dwindle](https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/) | Comportamento do layout dividido. |
| [Master](https://wiki.hypr.land/Configuring/Layouts/Master-Layout/) | Opções do layout master. |
| [Scrolling](https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/) | Opções do layout de rolagem. |
| [Dispositivos](https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/) | Opções de entrada por dispositivo. |
| [Atalhos](https://wiki.hypr.land/Configuring/Basics/Binds/) | Atalhos de teclado e mouse. |
| [Regras de janelas](https://wiki.hypr.land/Configuring/Basics/Window-Rules/) | Correspondência de classes e comportamento de janelas. |
| [Regras de espaços](https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/) | Seleção de espaços e propriedades de layout. |
| [Hypridle](https://wiki.hypr.land/Hypr-Ecosystem/hypridle/) | Inicialização, tempo de espera e retorno da atividade. |
| [Hyprpaper](https://wiki.hypr.land/Hypr-Ecosystem/hyprpaper/) | Configuração de papel de parede. |
| [Hyprtoolkit](https://wiki.hypr.land/Hypr-Ecosystem/hyprtoolkit/) | Temas compartilhados de aplicativos. |
| [Configuração do Waybar](https://github.com/Alexays/Waybar/wiki/Configuration) | Configuração opcional da barra. |

Os [arquivos completos de configuração](https://github.com/guihn/ArchLinux-Installation/tree/main/Portugu%C3%AAs/Hyprland/Configura%C3%A7%C3%A3o) associam esses assuntos aos exemplos reais. A revisão documental não substitui a verificação em execução no hardware de destino.

[Índice](https://github.com/guihn/ArchLinux-Installation/tree/main/Portugu%C3%AAs)
