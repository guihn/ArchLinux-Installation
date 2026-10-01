<table width="100%">
<tr>
<td align="left" width="5000"><strong>English</strong> | <a href="https://github.com/guihn/ArchLinux-Installation/tree/main/Portugu%C3%AAs/Refer%C3%AAncias">Português</a></td>
<td align="right" width="5000"><a href="https://github.com/guihn/ArchLinux-Installation/tree/main/English">Index</a></td>
</tr>
</table>

# References

These references support the procedures and configuration formats in the guide. Arch Linux and Hyprland evolve continuously; the installed package version and the matching upstream documentation determine the applicable syntax. Installation begins in [Preparation](https://github.com/guihn/ArchLinux-Installation/tree/main/English/Preparation), and failures have targeted return paths in [Troubleshooting](https://github.com/guihn/ArchLinux-Installation/tree/main/English/Troubleshooting).

## Installation and storage

| Reference | Subject |
| --- | --- |
| [Arch downloads](https://archlinux.org/download/) | Current ISO, mirrors, checksums and signatures. |
| [Arch installation guide](https://wiki.archlinux.org/title/Installation_guide) | Live environment, base system and first boot. |
| [Partitioning](https://wiki.archlinux.org/title/Partitioning) | GPT/MBR and firmware-specific layouts. |
| [GRUB on Arch](https://wiki.archlinux.org/title/GRUB) | BIOS and UEFI bootloader installation. |
| [GNU GRUB BIOS installation](https://www.gnu.org/software/grub/manual/grub/html_node/BIOS-installation.html) | BIOS boot partition and MBR embedding requirements. |
| [GNU GRUB simple configuration](https://www.gnu.org/software/grub/manual/grub/html_node/Simple-configuration.html) | Timeout and generated menu configuration. |
| [Ventoy downloads](https://www.ventoy.net/en/download.html) | Installation archives and verification. |
| [Ventoy getting started](https://www.ventoy.net/en/doc_start.html) | USB preparation and ISO copying. |

## Packages, drivers and services

| Reference | Subject |
| --- | --- |
| [System maintenance](https://wiki.archlinux.org/title/System_maintenance) | Complete updates and partial-upgrade limitations. |
| [Package signing](https://wiki.archlinux.org/title/Pacman/Package_signing) | Keyring verification and conditional recovery. |
| [NetworkManager](https://wiki.archlinux.org/title/NetworkManager) | Installed-system networking and DNS. |
| [NVIDIA](https://wiki.archlinux.org/title/NVIDIA) | Hardware-specific driver selection. |
| [NVIDIA legacy transition](https://archlinux.org/news/nvidia-590-driver-drops-pascal-support-main-packages-switch-to-open-kernel-modules/) | Maxwell/Pascal and the 580xx branch. |
| [mkinitcpio configuration](https://github.com/archlinux/mkinitcpio/blob/master/man/mkinitcpio.conf.5.adoc) | MODULES and image-generation settings. |
| [mkinitcpio module handling](https://github.com/archlinux/mkinitcpio/blob/master/functions) | Missing-module errors and inclusion behavior. |
| [mkinitcpio package hook](https://github.com/archlinux/mkinitcpio/blob/master/libalpm/hooks/90-mkinitcpio-install.hook) | Automatic generation after relevant transactions. |
| [Ly](https://github.com/fairyglade/ly) | Display-manager service and TTY requirements. |
| [Playerctl](https://github.com/altdesktop/playerctl) | MPRIS playback and track commands. |
| [Yazi installation](https://yazi-rs.github.io/docs/installation/) | Terminal file-manager requirements. |
| [foot manual](https://man.archlinux.org/man/extra/foot/foot.1.en) | Terminal command execution. |

## Hyprland configuration

| Reference | Subject |
| --- | --- |
| [Configuration entry point](https://wiki.hypr.land/Configuring/Start/) | Lua, modules and version selection. |
| [Monitors](https://wiki.hypr.land/Configuring/Basics/Monitors/) | Outputs, modes, scale, position and rotation. |
| [Autostart](https://wiki.hypr.land/Configuring/Basics/Autostart/) | Session startup callbacks. |
| [Environment variables](https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/) | Session environment. |
| [Permissions](https://wiki.hypr.land/Configuring/Advanced-and-Cool/Permissions/) | Permission rules and restart behavior. |
| [Variables](https://wiki.hypr.land/Configuring/Basics/Variables/) | General, decoration, input and miscellaneous settings. |
| [Animations](https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/) | Curves and animation properties. |
| [Dwindle](https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/) | Split-layout behavior. |
| [Master](https://wiki.hypr.land/Configuring/Layouts/Master-Layout/) | Master-layout settings. |
| [Scrolling](https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/) | Scrolling-layout settings. |
| [Devices](https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/) | Per-device input settings. |
| [Bindings](https://wiki.hypr.land/Configuring/Basics/Binds/) | Key and mouse bindings. |
| [Window rules](https://wiki.hypr.land/Configuring/Basics/Window-Rules/) | Class matching and window behavior. |
| [Workspace rules](https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/) | Workspace selection and layout properties. |
| [Hypridle](https://wiki.hypr.land/Hypr-Ecosystem/hypridle/) | Startup, timeout and resume events. |
| [Hyprpaper](https://wiki.hypr.land/Hypr-Ecosystem/hyprpaper/) | Wallpaper configuration. |
| [Hyprtoolkit](https://wiki.hypr.land/Hypr-Ecosystem/hyprtoolkit/) | Shared application themes. |
| [Waybar configuration](https://github.com/Alexays/Waybar/wiki/Configuration) | Optional bar configuration. |

The [complete configuration files](https://github.com/guihn/ArchLinux-Installation/tree/main/English/Hyprland/Configuration) associate these topics with the actual examples. Documentation review does not substitute for runtime verification on the target hardware.

[Index](https://github.com/guihn/ArchLinux-Installation/tree/main/English)
