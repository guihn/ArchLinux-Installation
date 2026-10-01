<table width="100%">
<tr>
<td align="left" width="5000"><strong>Português</strong> | <a href="https://github.com/guihn/ArchLinux-Installation/tree/main/English/Hyprland/Configuration">English</a></td>
<td align="right" width="5000"><a href="https://github.com/guihn/ArchLinux-Installation/tree/main/Portugu%C3%AAs">Índice</a></td>
</tr>
</table>

# Configuração

Esta pasta contém doze arquivos completos para `~/.config/hypr/`. O ponto de entrada importa os dez módulos Lua na ordem documentada; o hypridle lê sua configuração separada. O [procedimento do Hyprland](https://github.com/guihn/ArchLinux-Installation/tree/main/Portugu%C3%AAs/Hyprland) cobre backup, adaptação e implantação.

**Comportamento pessoal opcional:** o autostart completo inclui Spotify, Discord, Waybar e hyprpaper. Suas inicializações podem permanecer comentadas antes da implantação; os pacotes e a configuração do papel de parede são necessários quando ativados. Valores dos monitores e nomes de dispositivos exigem adaptação à máquina real.

As referências técnicas oficiais nos comentários estão em inglês. As descrições abaixo explicam os arquivos e suas relações em português.

## Arquivos

| Arquivo | Finalidade |
| --- | --- |
| `hyprland.lua` | Ponto de entrada e ordem dos módulos. |
| `monitors.lua` | Modos das saídas, posições, escala e rotação. |
| `programs.lua` | Comandos de foot, Yazi em terminal e Hyprlauncher. |
| `autostart.lua` | Agente de autenticação, inatividade, barra/papel de parede opcionais, iniciador, histórico de transferência e aplicativos pessoais. |
| `environmentvariables.lua` | Tamanhos de cursor e escolha de tema Qt 5. |
| `permissions.lua` | Exemplos comentados de aplicação e regras de permissões. |
| `lookandfeel.lua` | Espaçamentos, bordas, decoração, animações e layouts, com alternativas comentadas de espaçamento inteligente. |
| `miscellaneous.lua` | Opções de papel de parede padrão e logotipo. |
| `input.lua` | Teclado, ponteiro, touchpad, gesto e exemplo por dispositivo. |
| `keybinds.lua` | Atalhos de aplicativos, janelas, espaços, área de transferência, capturas, volume, brilho e mídia. |
| `windowsandworkspaces.lua` | Exemplos de janelas e camadas, comportamento XWayland e espaço pessoal magic. |
| `hypridle.conf` | Desligamento dos monitores após 60 segundos e religação com atividade, sem bloqueio. |

## 1. hyprland.lua

Ponto de entrada e ordem dos módulos.

[Abrir arquivo](https://github.com/guihn/ArchLinux-Installation/blob/main/Portugu%C3%AAs/Hyprland/Configura%C3%A7%C3%A3o/hyprland.lua) · [Download](https://raw.githubusercontent.com/guihn/ArchLinux-Installation/main/Portugu%C3%AAs/Hyprland/Configura%C3%A7%C3%A3o/hyprland.lua)

<details>
<summary>Conteúdo completo</summary>

```lua
-- Exemplo de configuração Lua modular do Hyprland.
-- Documentação de configuração:
-- https://wiki.hypr.land/Configuring/Start/

-- Este exemplo configura parte das opções disponíveis.
-- A wiki oficial documenta o conjunto completo de opções.

-- A configuração está dividida em módulos.
-- Um módulo separado pode ser carregado como no exemplo comentado:
-- require("myColors")

----------------------
---- IMPORTAÇÃO DE MÓDULOS ----
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

</details>

## 2. monitors.lua

Modos das saídas, posições, escala e rotação.

[Abrir arquivo](https://github.com/guihn/ArchLinux-Installation/blob/main/Portugu%C3%AAs/Hyprland/Configura%C3%A7%C3%A3o/monitors.lua) · [Download](https://raw.githubusercontent.com/guihn/ArchLinux-Installation/main/Portugu%C3%AAs/Hyprland/Configura%C3%A7%C3%A3o/monitors.lua)

<details>
<summary>Conteúdo completo</summary>

```lua
------------------
---- MONITORES ----
------------------

-- Referência em inglês: https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
    output   = "HDMI-A-1",
    mode     = "2560x1080@74.99",
    position = "-1080x0",
    scale    = "1",
    transform = 1,
})

hl.monitor({
    output   = "HDMI-A-2",
    mode     = "1920x1080@120",
    position = "0x0",
    scale    = "1",
})
```

</details>

## 3. programs.lua

Comandos de foot, Yazi em terminal e Hyprlauncher.

[Abrir arquivo](https://github.com/guihn/ArchLinux-Installation/blob/main/Portugu%C3%AAs/Hyprland/Configura%C3%A7%C3%A3o/programs.lua) · [Download](https://raw.githubusercontent.com/guihn/ArchLinux-Installation/main/Portugu%C3%AAs/Hyprland/Configura%C3%A7%C3%A3o/programs.lua)

<details>
<summary>Conteúdo completo</summary>

```lua
---------------------
---- PROGRAMAS ----
---------------------

-- Comandos dos programas padrão utilizados pelos atalhos.
terminal    = "foot"
fileManager = "foot -e yazi"
menu        = "hyprlauncher"
```

</details>

## 4. autostart.lua

Agente de autenticação, inatividade, barra/papel de parede opcionais, iniciador, histórico de transferência e aplicativos pessoais.

[Abrir arquivo](https://github.com/guihn/ArchLinux-Installation/blob/main/Portugu%C3%AAs/Hyprland/Configura%C3%A7%C3%A3o/autostart.lua) · [Download](https://raw.githubusercontent.com/guihn/ArchLinux-Installation/main/Portugu%C3%AAs/Hyprland/Configura%C3%A7%C3%A3o/autostart.lua)

<details>
<summary>Conteúdo completo</summary>

```lua
-------------------
---- INICIALIZAÇÃO ----
-------------------

-- Referência em inglês: https://wiki.hypr.land/Configuring/Basics/Autostart/

-- A inicialização pode incluir agentes, barras e outros processos de fundo.
-- Exemplo opcional de inicialização de aplicativos:
--
-- hl.on("hyprland.start", function ()
--   hl.exec_cmd(terminal)
--   hl.exec_cmd("nm-applet")
--   hl.exec_cmd("waybar & hyprpaper & firefox")
-- end)

hl.on("hyprland.start", function ()
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("waybar")
    hl.exec_cmd("hyprlauncher -d")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")

-- Inicialização pessoal opcional: Spotify e Discord; as regras atribuem special:magic.
    hl.exec_cmd("spotify")
    hl.exec_cmd("discord")
end)
```

</details>

## 5. environmentvariables.lua

Tamanhos de cursor e escolha de tema Qt 5.

[Abrir arquivo](https://github.com/guihn/ArchLinux-Installation/blob/main/Portugu%C3%AAs/Hyprland/Configura%C3%A7%C3%A3o/environmentvariables.lua) · [Download](https://raw.githubusercontent.com/guihn/ArchLinux-Installation/main/Portugu%C3%AAs/Hyprland/Configura%C3%A7%C3%A3o/environmentvariables.lua)

<details>
<summary>Conteúdo completo</summary>

```lua
-------------------------------
---- VARIÁVEIS DE AMBIENTE ----
-------------------------------

-- Referência em inglês: https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

hl.env("XCURSOR_SIZE", "18")
hl.env("HYPRCURSOR_SIZE", "18")

hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")
```

</details>

## 6. permissions.lua

Exemplos comentados de aplicação e regras de permissões.

[Abrir arquivo](https://github.com/guihn/ArchLinux-Installation/blob/main/Portugu%C3%AAs/Hyprland/Configura%C3%A7%C3%A3o/permissions.lua) · [Download](https://raw.githubusercontent.com/guihn/ArchLinux-Installation/main/Portugu%C3%AAs/Hyprland/Configura%C3%A7%C3%A3o/permissions.lua)

<details>
<summary>Conteúdo completo</summary>

```lua
-----------------------
----- PERMISSÕES -----
-----------------------

-- Referência em inglês: https://wiki.hypr.land/Configuring/Advanced-and-Cool/Permissions/
-- Alterações de permissões exigem reinicialização do Hyprland, sem aplicação imediata
-- por motivos de segurança.

-- hl.config({
--   ecosystem = {
--     enforce_permissions = true,
--   },
-- })

-- hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
-- hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
-- hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")
```

</details>

## 7. lookandfeel.lua

Espaçamentos, bordas, decoração, animações e layouts, com alternativas comentadas de espaçamento inteligente.

[Abrir arquivo](https://github.com/guihn/ArchLinux-Installation/blob/main/Portugu%C3%AAs/Hyprland/Configura%C3%A7%C3%A3o/lookandfeel.lua) · [Download](https://raw.githubusercontent.com/guihn/ArchLinux-Installation/main/Portugu%C3%AAs/Hyprland/Configura%C3%A7%C3%A3o/lookandfeel.lua)

<details>
<summary>Conteúdo completo</summary>

```lua
-----------------------
---- APARÊNCIA ----
-----------------------

-- Referência em inglês: https://wiki.hypr.land/Configuring/Basics/Variables/
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

-- Curvas e animações padrão; referência em inglês: https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
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

-- Alternativas de espaçamento inteligente para os seletores de espaços correspondentes.
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

-- Referência em inglês: https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/
hl.config({
    dwindle = {
        preserve_split = true,
    },
})

-- Referência em inglês: https://wiki.hypr.land/Configuring/Layouts/Master-Layout/
hl.config({
    master = {
        new_status = "master",
    },
})

-- Referência em inglês: https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/
hl.config({
    scrolling = {
        fullscreen_on_one_column = true,
    },
})
```

</details>

## 8. miscellaneous.lua

Opções de papel de parede padrão e logotipo.

[Abrir arquivo](https://github.com/guihn/ArchLinux-Installation/blob/main/Portugu%C3%AAs/Hyprland/Configura%C3%A7%C3%A3o/miscellaneous.lua) · [Download](https://raw.githubusercontent.com/guihn/ArchLinux-Installation/main/Portugu%C3%AAs/Hyprland/Configura%C3%A7%C3%A3o/miscellaneous.lua)

<details>
<summary>Conteúdo completo</summary>

```lua
----------------
---- OPÇÕES DIVERSAS ----
----------------

hl.config({
    misc = {
        force_default_wallpaper = -1,
        disable_hyprland_logo   = false,
    },
})
```

</details>

## 9. input.lua

Teclado, ponteiro, touchpad, gesto e exemplo por dispositivo.

[Abrir arquivo](https://github.com/guihn/ArchLinux-Installation/blob/main/Portugu%C3%AAs/Hyprland/Configura%C3%A7%C3%A3o/input.lua) · [Download](https://raw.githubusercontent.com/guihn/ArchLinux-Installation/main/Portugu%C3%AAs/Hyprland/Configura%C3%A7%C3%A3o/input.lua)

<details>
<summary>Conteúdo completo</summary>

```lua
---------------
---- ENTRADA ----
---------------

hl.config({
    input = {
        kb_layout  = "br",
        kb_variant = "abnt2",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        follow_mouse = 1,

        sensitivity = 0, -- Intervalo: -1.0 a 1.0; 0 mantém a sensibilidade sem alteração.

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

-- Exemplo de configuração por dispositivo; o nome precisa corresponder a um dispositivo real.
-- Referência em inglês: https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/
hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -0.5,
})
```

</details>

## 10. keybinds.lua

Atalhos de aplicativos, janelas, espaços, área de transferência, capturas, volume, brilho e mídia.

[Abrir arquivo](https://github.com/guihn/ArchLinux-Installation/blob/main/Portugu%C3%AAs/Hyprland/Configura%C3%A7%C3%A3o/keybinds.lua) · [Download](https://raw.githubusercontent.com/guihn/ArchLinux-Installation/main/Portugu%C3%AAs/Hyprland/Configura%C3%A7%C3%A3o/keybinds.lua)

<details>
<summary>Conteúdo completo</summary>

```lua
---------------------
---- ATALHOS ----
---------------------

local mainMod = "SUPER" -- Tecla Windows/logotipo como modificador principal.

-- Referência de atalhos em inglês: https://wiki.hypr.land/Configuring/Basics/Binds/
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal))
local closeWindowBind = hl.bind(mainMod .. " + C", hl.dsp.window.close())
-- closeWindowBind:set_enabled(false)
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))    -- Apenas dwindle.

-- Atalhos pessoais.
hl.bind("PRINT", hl.dsp.exec_cmd("hyprshot -m region"))
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.exec_cmd("cliphist list | wofi --dmenu | cliphist decode | wl-copy"))

-- Foco direcional com mainMod + setas.
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left"  }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up"    }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down"  }))

-- Seleção de espaços com mainMod + [0-9].
-- Movimentação da janela ativa com mainMod + SHIFT + [0-9].
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Exemplo de espaço especial (scratchpad).
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Seleção de espaços existentes com mainMod + roda do mouse.
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Movimentação/redimensionamento com mainMod + arraste esquerdo/direito do mouse.
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Teclas multimídia de volume e iluminação compatível da tela.
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })

-- Os comandos de mídia MPRIS dependem de playerctl.
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })
```

</details>

## 11. windowsandworkspaces.lua

Exemplos de janelas e camadas, comportamento XWayland e espaço pessoal magic.

[Abrir arquivo](https://github.com/guihn/ArchLinux-Installation/blob/main/Portugu%C3%AAs/Hyprland/Configura%C3%A7%C3%A3o/windowsandworkspaces.lua) · [Download](https://raw.githubusercontent.com/guihn/ArchLinux-Installation/main/Portugu%C3%AAs/Hyprland/Configura%C3%A7%C3%A3o/windowsandworkspaces.lua)

<details>
<summary>Conteúdo completo</summary>

```lua
--------------------------------
---- JANELAS E ESPAÇOS DE TRABALHO ----
--------------------------------

-- Referência em inglês: https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- Referência relacionada em inglês: https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

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

-- As regras de camada também retornam um identificador de controle.
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

-- Spotify e Discord em special:magic com organização pelo dwindle.
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

</details>

## 12. hypridle.conf

Desligamento dos monitores após 60 segundos e religação com atividade, sem bloqueio.

[Abrir arquivo](https://github.com/guihn/ArchLinux-Installation/blob/main/Portugu%C3%AAs/Hyprland/Configura%C3%A7%C3%A3o/hypridle.conf) · [Download](https://raw.githubusercontent.com/guihn/ArchLinux-Installation/main/Portugu%C3%AAs/Hyprland/Configura%C3%A7%C3%A3o/hypridle.conf)

<details>
<summary>Conteúdo completo</summary>

```hyprlang
general {
    lock_cmd             =
    before_sleep_cmd     =
    after_sleep_cmd      =
    ignore_dbus_inhibit  = false
}

listener {
    timeout    = 60
    on-timeout = hyprctl dispatch 'hl.dsp.dpms({ action = "disable" })'
    on-resume  = hyprctl dispatch 'hl.dsp.dpms({ action = "enable" })'
}
```

</details>

[Índice](https://github.com/guihn/ArchLinux-Installation/tree/main/Portugu%C3%AAs)
