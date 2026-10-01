--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- Reference: https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- Related reference: https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

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

-- Spotify and Discord in special:magic with dwindle tiling.
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
