<table width="100%">
<tr>
<td align="left" width="5000"><strong>English</strong> | <a href="https://github.com/guihn/ArchLinux-Installation/tree/main/Portugu%C3%AAs/Personaliza%C3%A7%C3%A3o">Português</a></td>
<td align="right" width="5000"><a href="https://github.com/guihn/ArchLinux-Installation/tree/main/English/Hyprland">Previous</a> | <a href="https://github.com/guihn/ArchLinux-Installation/tree/main/English">Index</a></td>
</tr>
</table>

# Customization

The modular files from [Hyprland](https://github.com/guihn/ArchLinux-Installation/tree/main/English/Hyprland) are already deployed. This section describes optional personal configuration on that working session. It does not require another copy of the configuration set.

## 1. Personal configuration

### 1.1 Zsh and Fastfetch

Fastfetch displays system information. The reference preference is automatic output whenever a new interactive Zsh terminal opens:

```bash
nvim ~/.zshrc
```

The following line at the end of the file enables that behavior:

```bash
fastfetch
```

Neovim's `i` enters insertion; `Esc`, `:wq`, Enter saves and exits. A new foot window then reads `.zshrc`. A single call is sufficient; duplicate lines would print duplicate reports. Commenting the line with `#` disables the automatic display. Another shell uses its corresponding interactive startup file, such as `.bashrc` for Bash.

### 1.2 Spotify, Discord and the magic workspace

The complete example's `autostart.lua` launches Spotify and Discord. `windowsandworkspaces.lua` matches their window classes and assigns `special:magic`. Both applications must be installed before their startup entries are enabled; unwanted entries can remain commented. These are personal applications, not requirements for a working compositor.

With two tiled windows and the dwindle layout, the workspace arranges them into splits. The exact orientation depends on layout state and insertion behavior; the workspace rules assign a destination rather than enforcing a fixed two-column geometry. `SUPER + J` changes the split when a different orientation is needed.

| Shortcut | Result |
| --- | --- |
| `SUPER + S` | Show/hide `magic` above the active workspace. |
| `SUPER + SHIFT + S` | Move the active window into `special:magic`. |

The special workspace keeps music and communication accessible independently of numbered workspaces. Matching classes can be checked with `hyprctl clients`; an application's changed class requires the corresponding rule to match it.

### 1.3 Appearance, monitors and shortcuts

`lookandfeel.lua` contains gaps, border colors, opacity, shadows, blur, animation curves and layout settings. Commented smart-gap examples remain available. `monitors.lua`, `input.lua` and `keybinds.lua` contain machine-specific and personal values. The complete files and their comments remain available in [Configuration](https://github.com/guihn/ArchLinux-Installation/tree/main/English/Hyprland/Configuration).

Changes apply to the corresponding actual file under `~/.config/hypr/`. `hyprctl configerrors` exposes parsing problems. Permission and startup changes require a new session as explained in Hyprland; ordinary appearance changes follow the compositor's configuration reload behavior.

### 1.4 Wallpaper, bar and hyprtoolkit theme

Hyprpaper and Waybar can run from the example's startup callback. Wallpaper paths must identify existing images in a valid `hyprpaper.conf`; bar preferences belong to Waybar's configuration. Their official [wallpaper](https://wiki.hypr.land/Hypr-Ecosystem/hyprpaper/) and [bar](https://github.com/Alexays/Waybar/wiki/Configuration) documentation describes these formats.

`~/.config/hypr/hyprtoolkit.conf` supplies common visual settings for applications built with hyprtoolkit, including hyprlauncher and hyprpolkitagent. A shared palette can coordinate those applications. The personal monochrome theme is planned optional work; this repository does not supply a complete `hyprtoolkit.conf`. The [hyprtoolkit theming reference](https://wiki.hypr.land/Hypr-Ecosystem/hyprtoolkit/) describes available settings.

## 2. Component alternatives

| Reference choice | Optional replacement | Dependent changes |
| --- | --- | --- |
| foot | Another Wayland terminal | `terminal`, the Yazi launch command and any terminal-specific options. |
| Yazi | Another file manager | `fileManager`, package dependencies and whether a terminal wrapper is required. |
| Hyprlauncher | Another launcher | `menu`, daemon startup and relevant window/layer rules. |
| Zsh | Bash or another shell | Login shell and interactive startup files. |
| Ly | Another display manager or session launcher | Enabled services, session selection and environment handling. |
| Linux Zen | Another supported kernel | Kernel/header pair, DKMS build, image names and GRUB configuration. |

These alternatives are choices rather than additional mandatory installations. The reference remains the configuration shown throughout the guide.

The procedure ends with the configured system and optional personal preferences. [Troubleshooting](https://github.com/guihn/ArchLinux-Installation/tree/main/English/Troubleshooting) and [References](https://github.com/guihn/ArchLinux-Installation/tree/main/English/References) remain available for later consultation.

[Previous](https://github.com/guihn/ArchLinux-Installation/tree/main/English/Hyprland) · [Index](https://github.com/guihn/ArchLinux-Installation/tree/main/English)
