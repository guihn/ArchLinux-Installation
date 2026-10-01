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
