<table width="100%">
<tr>
<td align="left" width="5000"><strong>English</strong> | <a href="https://github.com/guihn/ArchLinux-Installation/tree/main/Portugu%C3%AAs/Hyprland">Português</a></td>
<td align="right" width="5000"><a href="https://github.com/guihn/ArchLinux-Installation/tree/main/English/Post%20Installation">Previous</a> | <a href="https://github.com/guihn/ArchLinux-Installation/tree/main/English">Index</a> | <a href="https://github.com/guihn/ArchLinux-Installation/tree/main/English/Customization">Next</a></td>
</tr>
</table>

# Hyprland

The packages and boot images from [Post Installation](https://github.com/guihn/ArchLinux-Installation/tree/main/English/Post%20Installation) are ready. This section runs in the ordinary account's graphical session or recovery console. It explains the complete configuration set, adaptation before activation and the expected session behavior.

## 1. Configuration model

### 1.1 Lua entry point and modules

The supplied configuration uses Hyprland's Lua API, introduced with the 0.55 configuration transition. `hyprctl version` identifies the running version; the [version-appropriate official documentation](https://wiki.hypr.land/Configuring/Start/) determines API compatibility. A legacy `hyprland.conf` example is not interchangeable with these Lua files.

`~/.config/hypr/hyprland.lua` is the entry point. Its imports load monitors, program definitions, startup commands, environment variables, permissions, appearance, miscellaneous settings, input, keybindings and window/workspace rules in that order. `programs.lua` defines the commands later used by bindings. `autostart.lua` and `windowsandworkspaces.lua` jointly manage personal application startup and placement. `hypridle.conf` is read by the separate hypridle process, not by Lua `require`.

### 1.2 Complete files and documentation

[Configuration](https://github.com/guihn/ArchLinux-Installation/tree/main/English/Hyprland/Configuration) contains all twelve actual files, full expandable contents and individual open/download links. Every file goes directly under `~/.config/hypr/`. Their package dependencies are installed in Post Installation. The examples retain commented alternatives, which remain inactive until explicitly enabled.

## 2. Backup, adaptation and deployment

### 2.1 Existing configuration backup

The commands below create a uniquely named backup if a configuration directory already exists. They run as the ordinary account:

```bash
if [ -d "$HOME/.config/hypr" ]; then
    backup_dir=$(mktemp -d "$HOME/hypr-backup.XXXXXXXX")
    cp -a "$HOME/.config/hypr/." "$backup_dir/"
    printf '%s\n' "$backup_dir"
fi
```

The printed directory contains the previous files. Before copying the example, monitor names, keyboard layout, shortcuts and optional autostart commands are reviewed in the downloaded copy. An existing custom configuration can instead receive corresponding edits manually.

### 2.2 Obtaining the complete set

```bash
mkdir -p ~/GitClones
cd ~/GitClones
git clone https://github.com/guihn/ArchLinux-Installation.git
cd ArchLinux-Installation
```

An existing clone uses its existing directory after checking local changes. Individual downloads from Configuration are an alternative; all imported modules must be present together.

### 2.3 Machine-specific and optional settings

`hyprctl monitors all` lists output names and available modes. The reference `HDMI-A-1` is a rotated 2560×1080 output at 74.99 Hz, positioned at `-1080x0`; `HDMI-A-2` is 1920×1080 at 120 Hz, positioned at `0x0`. These values describe the reference cabling and orientation, not universal output identities. A different display uses its reported name, supported mode, scale and position. `preferred` and `auto` provide suitable mode/position alternatives where appropriate.

`input.lua` uses Brazilian `br` with the `abnt2` variant. Another keyboard uses its matching XKB layout/variant; this graphical setting is separate from the console `br-abnt2` keymap. `hyprctl devices` supplies device names for optional per-device settings. `epic-mouse-v1` is an illustrative device name, not a claim about an attached mouse. Its example has no effect unless a device matches.

**Personal configuration:** the complete autostart example starts Spotify and Discord and uses the `special:magic` rules. Their startup lines remain optional. Before deployment, an unwanted startup line can remain commented with Lua `--`, or the corresponding application must be installed. Hyprpaper and Waybar are likewise optional startup choices. Hypridle is started in the same callback for the configured inactivity behavior; a second startup method is unnecessary.

The white border, spacing, shadows, blur, opacity, animation curves, monitor orientation, cursor sizes and personal shortcuts are examples. The [Customization](https://github.com/guihn/ArchLinux-Installation/tree/main/English/Customization) section explains their optional role without repeating file deployment.

### 2.4 File placement

After adaptation, from the repository root:

```bash
mkdir -p ~/.config/hypr
cp -a English/Hyprland/Configuration/*.lua ~/.config/hypr/
cp -a English/Hyprland/Configuration/hypridle.conf ~/.config/hypr/
```

These commands overwrite same-named destination files; the backup precedes them. Other files, such as a personal wallpaper configuration, remain available. Technical behavior is identical in both language versions; comments follow the selected documentation language.

## 3. Session behavior and verification

### 3.1 Programs and shortcuts

| Shortcut | Behavior |
| --- | --- |
| `SUPER + Q` | foot terminal. |
| `SUPER + E` | Yazi inside `foot -e yazi`. |
| `SUPER + R` | Hyprlauncher. |
| `SUPER + C` | Close the active window. |
| `SUPER + V` | Toggle the active window's floating state. |
| `SUPER + P` | Pseudotiling. |
| `SUPER + J` | Dwindle split toggle. |
| `SUPER + M` | Session exit through hyprshutdown when available, otherwise the exit dispatcher. |
| `Print` | Region screenshot through hyprshot. |
| `SUPER + SHIFT + V` | Clipboard history through cliphist and wofi. |
| `SUPER + arrows` | Directional focus. |
| `SUPER + 1…9 / 0` | Workspaces 1…10. |
| `SUPER + SHIFT + 1…9 / 0` | Move the active window to workspaces 1…10. |
| `SUPER + S` | Toggle the `magic` special workspace. |
| `SUPER + SHIFT + S` | Move the active window to `special:magic`. |
| `SUPER + mouse wheel` | Previous/next existing workspace. |
| `SUPER + left/right mouse drag` | Move/resize a window. |
| Audio and microphone keys | Volume and mute through `wpctl`. |
| Brightness keys | Compatible backlight control through `brightnessctl`. |
| Media keys | Playback and track control through `playerctl`. |

`SUPER` is the usual Windows/logo modifier. Available hardware keys and the selected keymap determine their actual input events.

### 3.2 Display inactivity and input resume

Hypridle's listener waits 60 seconds without qualifying activity, then dispatches display power-off. `on-resume` dispatches display power-on when activity resumes, including keyboard or pointer activity recognized by the session. Applications can inhibit idle handling according to the configured policy. No lock screen or automatic suspend is configured.

The three unused lock/sleep command fields are empty, rather than containing a shell command named `none`. The dispatcher syntax follows the Lua API used by the compositor. Recovery from a terminal within the active session is also possible with:

```bash
hyprctl dispatch 'hl.dsp.dpms({ action = "enable" })'
```

### 3.3 Restart and diagnostics

Autostart callbacks and permission changes require a new session. After the files are ready:

```bash
reboot
```

Manual GRUB selection and Ly login return to Hyprland. Session diagnostics include:

```bash
hyprctl version
hyprctl configerrors
hyprctl monitors all
hyprctl devices
systemctl --user status hyprpolkitagent
pgrep -a hypridle
```

No configuration errors, correct monitor output and a single hypridle process are expected. A syntax error is resolved before relying on affected bindings. A console reached with the applicable TTY shortcut can restore the backed-up configuration when the graphical session is unusable. Driver startup issues are checked against `dkms status`, image-generation output and the selected kernel, as described in Post Installation.

The configured session is now ready for optional [Customization](https://github.com/guihn/ArchLinux-Installation/tree/main/English/Customization).

[Previous](https://github.com/guihn/ArchLinux-Installation/tree/main/English/Post%20Installation) · [Index](https://github.com/guihn/ArchLinux-Installation/tree/main/English) · [Next](https://github.com/guihn/ArchLinux-Installation/tree/main/English/Customization)
