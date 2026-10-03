<table width="100%">
<tr>
<td align="left" width="5000"><strong>English</strong> | <a href="https://github.com/guihn/ArchLinux-Installation/tree/main/Portugu%C3%AAs/Perfil%20do%20Sistema">Português</a></td>
<td align="right" width="5000"><a href="https://github.com/guihn/ArchLinux-Installation/tree/main/English">Index</a></td>
</tr>
</table>

# System Profile

This optional reference describes the hardware, software and personal choices used by the guide's examples. It is available for clarification outside the required installation sequence. [Preparation](https://github.com/guihn/ArchLinux-Installation/tree/main/English/Preparation) is the procedural starting point.

## Hardware and displays

| Item | Reference |
| --- | --- |
| CPU | AMD Ryzen 9 9900X, Zen 5, 12 cores / 24 threads |
| Dedicated GPU | NVIDIA GTX 750 Ti, Maxwell GM107 |
| Integrated GPU | AMD graphics integrated into the Ryzen 9 9900X |
| RAM | 32 GiB |
| Storage example | `/dev/nvme0n1`; actual identity established before disk operations |
| Main display | 144 Hz display, configured at 1920×1080 and 120 Hz in the reference |
| Secondary display | 75 Hz display, configured at 2560×1080 and 74.99 Hz, rotated |
| Reference outputs | `HDMI-A-2` at `0x0`; `HDMI-A-1` at `-1080x0` with `transform = 1` |

These output names and modes describe a particular connection arrangement. Actual GPU identification comes from the hardware inventory; `hyprctl monitors all` and `hyprctl devices` describe the active session's displays and input devices. Available refresh rates depend on the complete GPU, connector, cable and monitor path.

## System components

| Component | Role | Package(s) |
| --- | --- | --- |
| Arch base | Essential userspace | `base` |
| Build tools | AUR compilation and external modules | `base-devel` |
| Linux Zen | Kernel and matching headers | `linux-zen`, `linux-zen-headers` |
| Firmware | Device firmware | `linux-firmware` |
| AMD microcode | CPU microcode updates | `amd-ucode` |
| GRUB | Bootloader | `grub` |
| EFI boot manager | UEFI firmware entries | `efibootmgr` |
| OS discovery | Optional dual-boot detection | `os-prober` |
| NetworkManager | Installed-system networking and text UI | `networkmanager` |
| Reflector | Mirror selection | `reflector` |
| Sudo | Administrative authorization | `sudo` |
| Neovim | Configuration editor, invoked as `nvim` | `neovim` |
| Git | Source and guide checkouts | `git` |
| Yay | AUR build/installation helper | `yay` |
| NVIDIA 580xx | GTX 750 Ti driver and utilities | `nvidia-580xx-dkms`, `nvidia-580xx-utils`, `lib32-nvidia-580xx-utils` |
| Mesa and RADV | AMD graphics and video acceleration | `mesa`, `vulkan-radeon`, `libva-mesa-driver` |
| PipeWire | Audio server and ALSA/PulseAudio compatibility | `pipewire`, `pipewire-alsa`, `pipewire-pulse` |
| WirePlumber | Audio session management and `wpctl` | `wireplumber` |
| BlueZ | Bluetooth daemon and `bluetoothctl` | `bluez`, `bluez-utils` |
| foot | Wayland terminal | `foot` |
| Yazi | Terminal file manager | `yazi` |
| Waybar | Optional desktop bar | `waybar` |
| Clipboard tools | Copy/paste and history | `wl-clipboard`, `cliphist`, `wofi` |
| Hyprland | Wayland compositor | `hyprland` |
| Hypridle | Idle display handling | `hypridle` |
| Hyprpaper | Optional wallpaper process | `hyprpaper` |
| Hyprpolkitagent | Graphical authorization agent | `hyprpolkitagent` |
| Hyprtoolkit | Shared application theming infrastructure | `hyprtoolkit` |
| Hyprlauncher | Application launcher | `hyprlauncher` |
| Hyprshot | Screenshots | `hyprshot` |
| Desktop portal | Wayland application integration | `xdg-desktop-portal-hyprland` |
| User directories | Standard personal directories | `xdg-user-dirs` |
| XWayland | X11 application compatibility | `xorg-xwayland` |
| Fastfetch | Optional terminal system report | `fastfetch` |
| ImageMagick | Image tools | `imagemagick` |
| Ly | Console-based display manager | `ly` |
| Fonts | Nerd Font symbols and emoji | `ttf-hack-nerd`, `noto-fonts-emoji` |
| Zsh | Login and interactive shell | `zsh` |
| Brightness controller | Supported backlight keys | `brightnessctl` |
| Qt 5 configuration | Qt 5 theme preference | `qt5ct` |
| VSCodium | Code editor | `vscodium-bin` |
| Spotify | Personal media application | `spotify` |
| PipeWire volume control | Graphical volume interface | `pwvucontrol` |
| Brave Nightly | Personal browser choice | `brave-nightly-bin` |
| Discord | Optional personal communication application | `discord` |

Current Mesa packaging provides `libva-mesa-driver`; it is not a second independent Mesa installation. DKMS is brought in by the driver dependency chain. The component table describes roles; the chronological package commands appear in Installation and Post Installation.

## Reference values

| Setting | Value and adaptation |
| --- | --- |
| Firmware and table | Main UEFI/GPT route; BIOS/GPT alternative with its own boot partition |
| Root and home | Together in ext4; no separate `/home` partition |
| Swap | Balanced 16 GiB for 32 GiB RAM; 8 GiB and 32 GiB alternatives |
| GRUB menu | `GRUB_TIMEOUT=-1`, waiting for manual selection |
| Console keyboard | `br-abnt2`; another keyboard requires its matching keymap |
| Graphical keyboard | `br` with `abnt2`; selected through XKB settings |
| Mirror country | `Brazil`, configurable to the relevant location |
| Time zone | `America/Sao_Paulo`, configurable to region/city |
| Locale | Generated `en_US.UTF-8` with the same `LANG`; `pt_BR.UTF-8` is an alternative |
| Hostname | `secura`, consistently replaced when a different name is chosen |
| Account | `guihnxz`, consistently replaced in account commands and explicit paths |
| Inactivity | Displays off after 60 seconds, on after input resumes; no lock screen |
| Personal startup | Spotify and Discord in the optional `magic` workspace |

The relevant procedure repeats adaptation guidance where each value is used. Personal startup, appearance and shell preferences are described in [Customization](https://github.com/guihn/ArchLinux-Installation/tree/main/English/Customization).

[Index](https://github.com/guihn/ArchLinux-Installation/tree/main/English)
