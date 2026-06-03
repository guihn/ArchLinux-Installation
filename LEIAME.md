# Arch Linux — Referência de Instalação Manual

> Documentação de referência pessoal para uma instalação manual do Arch Linux com configurações customizadas.

---

## Perfil do Sistema

| Componente | Detalhes |
|------------|---------|
| **CPU** | AMD Ryzen 9 9900X (Zen 5, 12c/24t) — iGPU RDNA integrada |
| **GPU Principal** | NVIDIA GTX 750 Ti (Maxwell GM107) — `nvidia-580xx-dkms` (AUR) |
| **GPU Secundária** | AMD iGPU (Ryzen 9 9900X) — `mesa` + `vulkan-radeon` + `libva-mesa-driver` |
| **Monitor Principal** | 144 Hz (limitado a 120 Hz pela GPU) |
| **Monitor Secundário** | 75 Hz |
| **Bootloader** | `grub` |
| **Kernel** | `linux-zen` |
| **Particionamento** | EFI + swap + root (sem `/home` separado) |
| **Filesystem** | ext4 |
| **Rede** | `networkmanager` |
| **Shell** | `zsh` |
| **Editor do Sistema** | `neovim` |

---

## Ambiente Gráfico

| Componente | Detalhes |
|------------|---------|
| **Compositor** | `hyprland` |
| **Display Manager** | `ly` |
| **Terminal** | `foot` |

### Estrutura de Configuração do Hyprland

```
~/.config/hypr/
├── hyprland.lua             # ponto de entrada — apenas chamadas require("")
├── monitors.lua             # configuração de monitores (outputs, resoluções, taxas de atualização)
├── programs.lua             # programas padrão (terminal, gerenciador de arquivos, launcher)
├── autostart.lua            # programas iniciados junto ao Hyprland
├── environmentvariables.lua # variáveis de ambiente (tamanho do cursor, tema QT, etc.)
├── permissions.lua          # regras de permissão do Hyprland
├── lookandfeel.lua          # geral, decoração, animações, layouts
├── miscellaneous.lua        # configurações diversas
├── input.lua                # layout de teclado, mouse, gestos
├── keybinds.lua             # todos os atalhos de teclado
├── windowsandworkspaces.lua # regras de janela e workspace
└── hypridle.conf            # configuração de inatividade
```

> **Nota pessoal:** A wiki do Hyprland recomenda explicitamente dividir a configuração: *"You can (and should!!) split this configuration into multiple files."*

---

## Instalação

### 1. Preparação

Verificar se o sistema inicializou em modo EFI:

```bash
ls /sys/firmware/efi/efivars
```

Definir o layout do teclado:

```bash
loadkeys br-abnt2
```

Conectar à internet via cabo ou Wi-Fi. Para Wi-Fi usando `iwctl`:

```bash
iwctl
device list
station wlan0 scan
station wlan0 get-networks
station wlan0 connect "SSID"
exit
```

Sincronizar o relógio do sistema:

```bash
timedatectl set-ntp true
```

---

### 2. Particionamento

Identificar o disco de destino:

```bash
lsblk
```

Abrir o cfdisk no disco de destino:

```bash
cfdisk /dev/nvme0n1
```

Criar as partições **nessa ordem** — a ordem garante o número correto de cada partição na formatação:

1. Partição EFI: ~512 MB, tipo **EFI System** → será `/dev/nvme0n1p1`
2. Partição swap: tamanho desejado, tipo **Linux swap** → será `/dev/nvme0n1p2`
3. Partição root: restante, tipo **Linux filesystem** → será `/dev/nvme0n1p3`

Formatar as partições:

```bash
mkfs.fat -F32 /dev/nvme0n1p1    # EFI
mkswap /dev/nvme0n1p2            # swap
swapon /dev/nvme0n1p2
mkfs.ext4 /dev/nvme0n1p3         # root
```

Montar as partições:

```bash
mount /dev/nvme0n1p3 /mnt
mkdir -p /mnt/boot/efi
mount /dev/nvme0n1p1 /mnt/boot/efi
```

Sincronizar os espelhos antes de continuar:

```bash
pacman -Sy
reflector --country Brazil --latest 20 --sort rate --verbose --save /etc/pacman.d/mirrorlist
```

---

### 3. Pacstrap

Instalar o sistema base:

```bash
pacstrap /mnt base base-devel linux-zen linux-zen-headers linux-firmware \
  reflector sudo neovim grub efibootmgr networkmanager git
```

> **Nota pessoal:** O objetivo é manter o pacstrap o mais enxuto possível. Todo o resto é instalado conscientemente após o primeiro boot.

---

### 4. Fstab

Gerar a tabela de filesystems:

```bash
genfstab -U /mnt >> /mnt/etc/fstab
```

---

### 5. Chroot

Entrar no novo sistema:

```bash
arch-chroot /mnt
```

---

### 6. Timezone e Locale

Definir o fuso horário:

```bash
ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
hwclock --systohc
```

Editar `/etc/locale.gen` com Neovim e descomentar a linha `en_US.UTF-8 UTF-8`:

```bash
nvim /etc/locale.gen
```

Gerar os locales:

```bash
locale-gen
```

Imprimir a configuração de locale:

```bash
echo "LANG=en_US.UTF-8" > /etc/locale.conf
```

Imprimir a configuração do teclado no console:

```bash
echo "KEYMAP=br-abnt2" > /etc/vconsole.conf
```

> **Nota pessoal:** Sistema mantido em inglês — facilita seguir documentações, tutoriais e mensagens de erro.

---

### 7. Hostname e Hosts

Imprimir o nome da máquina:

```bash
echo "myhostname" > /etc/hostname
```

Editar `/etc/hosts` com Neovim:

```bash
nvim /etc/hosts
```

Adicionar as entradas padrão:

```
127.0.0.1   localhost
::1         localhost
127.0.1.1   myhostname.localdomain myhostname
```

---

### 8. pacman.conf

Editar `/etc/pacman.conf` com Neovim:

```bash
nvim /etc/pacman.conf
```

Aplicar as seguintes alterações:

- Descomentar `Color`
- Adicionar `ILoveCandy` na linha abaixo de `Color`
- Definir `ParallelDownloads = 10`
- Descomentar a seção `[multilib]` e sua linha `Include`:

```ini
[multilib]
Include = /etc/pacman.d/mirrorlist
```

> **Nota pessoal:** `ILoveCandy` substitui a barra de progresso do pacman por uma animação do Pac-Man. `Color` habilita saída colorida. `ParallelDownloads = 10` acelera os downloads. `multilib` é necessário para bibliotecas 32-bit (drivers lib32 da NVIDIA, etc.).

---

### 9. mkinitcpio — Módulos NVIDIA

Editar `/etc/mkinitcpio.conf` com Neovim:

```bash
nvim /etc/mkinitcpio.conf
```

Adicionar os módulos NVIDIA ao array `MODULES`:

```
MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)
```

Gerar o initramfs:

```bash
mkinitcpio -P
```

> **Nota pessoal:** Os módulos são adicionados antes dos drivers serem instalados. O mkinitcpio ignora silenciosamente módulos ausentes sem quebrar o processo. Após o reboot e a instalação dos drivers NVIDIA, os módulos já estarão programados no initramfs e funcionarão normalmente — não é necessário rodar `mkinitcpio -P` novamente.

---

### 10. GRUB — Instalação e Configuração

Instalar o GRUB na partição EFI:

```bash
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=ArchLinux
```

Editar `/etc/default/grub` com Neovim:

```bash
nvim /etc/default/grub
```

Aplicar as seguintes alterações:

- Alterar `GRUB_TIMEOUT=5` para `GRUB_TIMEOUT=0`
- Definir os parâmetros do kernel:

```
GRUB_CMDLINE_LINUX_DEFAULT="quiet loglevel=3 nvidia-drm.modeset=1 nvidia-drm.fbdev=1"
```

Gerar o arquivo de configuração do GRUB:

```bash
grub-mkconfig -o /boot/grub/grub.cfg
```

> **Nota pessoal:** `GRUB_TIMEOUT=0` pula o menu do GRUB no boot, inicializando direto no sistema. Os parâmetros `nvidia-drm.modeset=1` e `nvidia-drm.fbdev=1` são necessários para os drivers proprietários da NVIDIA funcionarem corretamente com Wayland/Hyprland. O kernel ignora silenciosamente esses parâmetros até que os módulos estejam presentes — nenhum erro de boot ocorre.

---

### 11. Usuário e Senhas

Definir a senha do root:

```bash
passwd
```

Criar um usuário:

```bash
useradd -m -G wheel,audio,video,storage,input -s /bin/bash username
passwd username
```

Conceder acesso sudo editando o sudoers com Neovim:

```bash
EDITOR=nvim visudo
```

Descomentar a linha:

```
%wheel ALL=(ALL:ALL) ALL
```

> **Nota pessoal:** Se não quiser que o sudo peça senha toda hora, é possível descomentar apenas a linha `%wheel ALL=(ALL:ALL) NOPASSWD: ALL` no lugar da anterior.

---

### 12. Serviços Essenciais

Habilitar o NetworkManager para iniciar no boot:

```bash
systemctl enable NetworkManager
```

---

### 13. Sair e Reiniciar

```bash
swapoff /dev/nvme0n1p2
exit
umount -R /mnt
reboot
```

---

## Pós-instalação

### 14. Conectar à internet

Faça login com seu nome de usuário e senha. A primeira coisa a fazer é conectar-se à rede utilizando o comando: 
```bash
nmtui
```
 do `networkmanager`. Após abrir a ferramenta vá em **Activate a connection** e selecione sua rede Wi-Fi e em seguida digite sua senha:

---

### 15. Sincronizar espelhos

Antes de qualquer instalação, sincronizar os pacotes e atualizar os espelhos:

```bash
sudo pacman -Sy
sudo reflector --country Brazil --latest 20 --sort rate --verbose --save /etc/pacman.d/mirrorlist
```

---

### 16. Instalar o yay

Criar a pasta de repositórios e clonar o yay:

```bash
mkdir -p ~/GitClones
cd ~/GitClones
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ~
```

> **Atenção:** Quando o yay perguntar se deseja remover as dependências de compilação durante a instalação de pacotes AUR, responda **não**. Removê-las de forma agressiva pode causar falhas de compilação em pacotes futuros que dependem das mesmas ferramentas de build.

---

### 17. Instalar o Brave, fontes essenciais e ativar o Zsh

Instalar o Brave Nightly para ter acesso a este documento e facilitar o restante da instalação. As fontes e o Zsh são instalados via pacman, e o shell é ativado em seguida:

```bash
sudo pacman -S ttf-hack-nerd noto-fonts-emoji zsh
yay -S brave-nightly-bin
chsh -s /bin/zsh
```

---

### 18. Instalar Drivers NVIDIA (via yay)

Instalar os três pacotes simultaneamente:

```bash
yay -S nvidia-580xx-dkms nvidia-580xx-utils lib32-nvidia-580xx-utils
```

> **Atenção:** Instalar os três pacotes em um único comando para evitar conflitos de versão de dependências entre o driver e seus utilitários.

---

### 19. Instalar Pacotes do Sistema (pacman)

Instalar todos os pacotes em um único comando:

```bash
sudo pacman -S \
  mesa vulkan-radeon libva-mesa-driver \
  pipewire wireplumber pipewire-alsa pipewire-pulse \
  bluez bluez-utils \
  foot yazi \
  waybar \
  wl-clipboard cliphist \
  hyprland hypridle hyprpaper hyprpolkitagent hyprtoolkit hyprlauncher hyprshot \
  xdg-desktop-portal-hyprland xdg-user-dirs xorg-xwayland \
  fastfetch
```

> **Nota pessoal:** `hyprlock` não é usado nesta configuração. A inatividade é gerenciada exclusivamente pelo `hypridle`, configurado para apagar a tela após 1 minuto. O sistema é simplesmente ligado e desligado conforme necessário.
>
> `hyprpolkitagent` é iniciado via systemd do usuário em `autostart.lua`. É o agente polkit nativo do ecossistema Hypr — mais leve que o `polkit-gnome` e sem dependências GTK.
>
> `hyprlauncher` é o launcher oficial do ecossistema Hyprland. Seu tema segue automaticamente o tema do `hyprtoolkit` — relevante para a futura fase de estética monocromática.

---

### 20. Instalar Pacotes AUR

```bash
yay -S ly vscodium-bin spotify pwvucontrol
```

---

### 21. Ativar Serviços

```bash
sudo systemctl enable bluetooth
sudo systemctl enable ly@tty2
xdg-user-dirs-update
```

---

### 22. Reiniciar

```bash
reboot
```

A partir daqui, o sistema inicializará direto no LY e, após o login, entrará no Hyprland. Os próximos passos são a configuração dos aplicativos e do ambiente gráfico.

---

## Configuração do Hyprland

> Todos os arquivos de configuração ficam em `~/.config/hypr/`. O ponto de entrada é `hyprland.lua`, que usa `require("")` para carregar cada módulo.

---

### hyprland.lua

```lua
-- This is an example Hyprland Lua config file.
-- Refer to the wiki for more information.
-- https://wiki.hypr.land/Configuring/Start/

-- Please note not all available settings / options are set here.
-- For a full list, see the wiki

-- You can (and should!!) split this configuration into multiple files
-- Create your files separately and then require them like this:
-- require("myColors")

----------------------
---- REQUISITIONS ----
----------------------

require ("monitors")
require ("programs")
require ("autostart")
require ("environmentvariables")
require ("permissions")
require ("lookandfeel")
require ("miscellaneous")
require ("input")
require ("keybinds")
require ("windowsandworkspaces")
```

---

### monitors.lua

```lua
------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
    output   = "HDMI-A-1",
    mode     = "1920x1080@120",
    position = "1x0",
    scale    = "1",
})

hl.monitor({
    output   = "HDMI-A-2",
    mode     = "2560x1080@74.99",
    position = "-2560x0",
    scale    = "1",
})
```

---

### programs.lua

```lua
---------------------
---- MY PROGRAMS ----
---------------------

-- Set programs that you use
terminal    = "foot"
fileManager = "yazi"
menu        = "hyprlauncher"
```

---

### autostart.lua

Para abrir o Spotify e o Discord dividindo a tela automaticamente no workspace `special:magic` ao iniciar o Hyprland, o autostart dispara os dois apps e as regras de janela em `windowsandworkspaces.lua` cuidam do posicionamento. Veja a seção **windowsandworkspaces.lua** para as regras correspondentes.

> **Nota:** `hyprpolkitagent` é iniciado via systemd do usuário aqui — é o agente polkit nativo do ecossistema Hypr e precisa estar ativo antes de qualquer operação que exija elevação de privilégio.

```lua
-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:
--
-- hl.on("hyprland.start", function ()
--   hl.exec_cmd(terminal)
--   hl.exec_cmd("nm-applet")
--   hl.exec_cmd("waybar & hyprpaper & firefox")
-- end)

hl.exec_cmd("systemctl --user start hyprpolkitagent")
hl.exec_cmd("hyprpaper")
hl.exec_cmd("waybar")
hl.exec_cmd("hyprlauncher -d")
hl.exec_cmd("wl-paste --type text --watch cliphist store")
hl.exec_cmd("wl-paste --type image --watch cliphist store")

-- Abre Spotify e Discord no workspace special:magic dividindo a tela
hl.exec_cmd("spotify")
hl.exec_cmd("discord")
```

---

### environmentvariables.lua

```lua
-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

hl.env("XCURSOR_SIZE", "18")
hl.env("HYPRCURSOR_SIZE", "18")

hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")
```

---

### permissions.lua

```lua
-----------------------
----- PERMISSIONS -----
-----------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Permissions/
-- Please note permission changes here require a Hyprland restart and are not applied on-the-fly
-- for security reasons

-- hl.config({
--   ecosystem = {
--     enforce_permissions = true,
--   },
-- })

-- hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
-- hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
-- hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")
```

---

### lookandfeel.lua

```lua
-----------------------
---- LOOK AND FEEL ----
-----------------------

-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
    general = {
        gaps_in  = 5,
        gaps_out = 20,

        border_size = 2,

        col = {
            active_border   = { colors = {"rgba(ffffffff)", "rgba(ffffffff)"}, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },

        resize_on_border = false,
        allow_tearing    = false,
        layout           = "dwindle",
    },

    decoration = {
        rounding       = 10,
        rounding_power = 2,

        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = 0xee1a1a1a,
        },

        blur = {
            enabled  = true,
            size     = 3,
            passes   = 1,
            vibrancy = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },
})

-- Default curves and animations, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}    } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}       } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1}    } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })

hl.curve("easy", { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })

hl.animation({ leaf = "global",        enabled = true,  speed = 10,   bezier = "default"       })
hl.animation({ leaf = "border",        enabled = true,  speed = 5.39, bezier = "easeOutQuint"  })
hl.animation({ leaf = "windows",       enabled = true,  speed = 4.79, spring = "easy"          })
hl.animation({ leaf = "windowsIn",     enabled = true,  speed = 4.1,  spring = "easy",         style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true,  speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true,  speed = 1.73, bezier = "almostLinear"  })
hl.animation({ leaf = "fadeOut",       enabled = true,  speed = 1.46, bezier = "almostLinear"  })
hl.animation({ leaf = "fade",          enabled = true,  speed = 3.03, bezier = "quick"         })
hl.animation({ leaf = "layers",        enabled = true,  speed = 3.81, bezier = "easeOutQuint"  })
hl.animation({ leaf = "layersIn",      enabled = true,  speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true,  speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true,  speed = 1.79, bezier = "almostLinear"  })
hl.animation({ leaf = "fadeLayersOut", enabled = true,  speed = 1.39, bezier = "almostLinear"  })
hl.animation({ leaf = "workspaces",    enabled = true,  speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true,  speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true,  speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor",    enabled = true,  speed = 7,    bezier = "quick"         })

-- "Smart gaps" / "No gaps when only"
-- hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
-- hl.workspace_rule({ workspace = "f[1]",   gaps_out = 0, gaps_in = 0 })
-- hl.window_rule({
--     name  = "no-gaps-wtv1",
--     match = { float = false, workspace = "w[tv1]" },
--     border_size = 0,
--     rounding    = 0,
-- })
-- hl.window_rule({
--     name  = "no-gaps-f1",
--     match = { float = false, workspace = "f[1]" },
--     border_size = 0,
--     rounding    = 0,
-- })

-- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
hl.config({
    dwindle = {
        preserve_split = true,
    },
})

-- See https://wiki.hypr.land/Configuring/Layouts/Master-Layout/ for more
hl.config({
    master = {
        new_status = "master",
    },
})

-- See https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/ for more
hl.config({
    scrolling = {
        fullscreen_on_one_column = true,
    },
})
```

---

### miscellaneous.lua

```lua
----------------
----  MISC  ----
----------------

hl.config({
    misc = {
        force_default_wallpaper = -1,
        disable_hyprland_logo   = false,
    },
})
```

---

### input.lua

```lua
---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout  = "br",
        kb_variant = "abnt2",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        follow_mouse = 1,

        sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

        touchpad = {
            natural_scroll = false,
        },
    },
})

hl.gesture({
    fingers   = 3,
    direction = "horizontal",
    action    = "workspace"
})

-- Example per-device config
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/ for more
hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -0.5,
})
```

---

### keybinds.lua

```lua
---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER" -- Sets "Windows" key as main modifier

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal))
local closeWindowBind = hl.bind(mainMod .. " + C", hl.dsp.window.close())
-- closeWindowBind:set_enabled(false)
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + ", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))    -- dwindle only

-- My binds
hl.bind("PRINT", hl.dsp.exec_cmd("hyprshot -m region"))
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.exec_cmd("cliphist list | wofi --dmenu | cliphist decode | wl-copy"))

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left"  }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up"    }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down"  }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Example special workspace (scratchpad)
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })
```

---

### windowsandworkspaces.lua

As regras abaixo incluem o posicionamento automático do Spotify e Discord no workspace `special:magic`, dividindo a tela lado a lado ao iniciar o Hyprland.

```lua
--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

local suppressMaximizeRule = hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})

-- Layer rules also return a handle.
-- local overlayLayerRule = hl.layer_rule({
--     name  = "no-anim-overlay",
--     match = { namespace = "^my-overlay$" },
--     no_anim = true,
-- })
-- overlayLayerRule:set_enabled(false)

hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },
    move  = "20 monitor_h-120",
    float = true,
})

-- Spotify e Discord no special:magic, dividindo a tela lado a lado (dwindle)
hl.window_rule({
    name      = "spotify-to-magic",
    match     = { class = "^(Spotify|spotify)$" },
    workspace = "special:magic",
})

hl.window_rule({
    name      = "discord-to-magic",
    match     = { class = "^(discord|Discord)$" },
    workspace = "special:magic",
})
```

---

### hypridle.conf

Apagar a tela após 1 minuto de inatividade:

```ini
general {
    lock_cmd             = none
    before_sleep_cmd     = none
    after_sleep_cmd      = none
    ignore_dbus_inhibit  = false
}

listener {
    timeout    = 60
    on-timeout = hyprctl dispatch dpms off
    on-resume  = hyprctl dispatch dpms on
}
```

> **Nota pessoal:** Nenhuma tela de bloqueio está configurada. A inatividade simplesmente apaga os monitores. O sistema é ligado e desligado conforme necessário, sem depender de um fluxo de bloqueio/suspensão.

Reiniciar para aplicar as configurações:

```bash
reboot
```

---

## hyprtoolkit.conf

`~/.config/hypr/hyprtoolkit.conf` centraliza a temação de todos os aplicativos do ecossistema Hypr. Uma única paleta de cores definida aqui se propaga automaticamente para `hyprpolkitagent`, `hyprlauncher` e todos os outros aplicativos que usam o hyprtoolkit.

> **Nota pessoal:** Quando a fase de estética monocromática começar, atualizar esse único arquivo será suficiente para retematicar todo o ecossistema Hypr.

---

<details>
<summary><b><i>Personalização do Terminal</i></b></summary>

Para exibir o fastfetch automaticamente toda vez que um novo terminal for aberto, adicionar a chamada ao final do arquivo de configuração do shell.

Editar `~/.zshrc` com Neovim:

```bash
nvim ~/.zshrc
```

Adicionar ao final do arquivo:

```bash
fastfetch
```

A partir de agora, toda vez que o foot (ou qualquer terminal usando Zsh) for aberto, o fastfetch será executado automaticamente como primeira saída.

</details>

---

<details>
<summary><b><i>Spotify + Discord — workspace magic</i></b></summary>

O Spotify e o Discord são disparados automaticamente pelo `autostart.lua` e redirecionados ao workspace `special:magic` pelas regras em `windowsandworkspaces.lua`. O layout dwindle divide a tela entre eles automaticamente.

Para acessar o workspace magic a qualquer momento, usar o atalho definido em `keybinds.lua`:

```
SUPER + S         → alternar o special:magic
SUPER + SHIFT + S → mover janela ativa para o special:magic
```

> **Nota pessoal:** O `special:magic` funciona como um workspace flutuante sobre qualquer workspace ativo — ideal para apps de fundo como música e comunicação que ficam sempre acessíveis mas fora do caminho.

</details>

---

<details>
<summary><b><i>Bluetooth — Solução de Problemas</i></b></summary>

Entrar no shell interativo do bluetoothctl:

```bash
bluetoothctl
```

| Comando | Descrição |
|---------|-----------|
| `power on` | Liga o adaptador Bluetooth |
| `agent on` | Habilita o agente de pareamento |
| `default-agent` | Define o agente padrão |
| `scan on` | Inicia a varredura por dispositivos |
| `scan off` | Para a varredura |
| `devices` | Lista os dispositivos encontrados |
| `pair XX:XX:XX:XX:XX:XX` | Pareia com o dispositivo |
| `trust XX:XX:XX:XX:XX:XX` | Confia no dispositivo (reconexão automática) |
| `connect XX:XX:XX:XX:XX:XX` | Conecta ao dispositivo |
| `disconnect XX:XX:XX:XX:XX:XX` | Desconecta o dispositivo |
| `remove XX:XX:XX:XX:XX:XX` | Remove o dispositivo da lista |
| `quit` | Sai do bluetoothctl |

</details>

---

## Fim

*Configuração feita por [@guihn](https://github.com/guihn) especificamente para uso pessoal — publicada na esperança de que possa ser útil a alguém.*
