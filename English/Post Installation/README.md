<table width="100%">
<tr>
<td align="left" width="5000"><strong>English</strong> | <a href="https://github.com/guihn/ArchLinux-Installation/tree/main/Portugu%C3%AAs/P%C3%B3s%20Instala%C3%A7%C3%A3o">Português</a></td>
<td align="right" width="5000"><a href="https://github.com/guihn/ArchLinux-Installation/tree/main/English/Installation">Previous</a> | <a href="https://github.com/guihn/ArchLinux-Installation/tree/main/English">Index</a> | <a href="https://github.com/guihn/ArchLinux-Installation/tree/main/English/Hyprland">Next</a></td>
</tr>
</table>

# Post Installation

The installed system has reached its console login after manual GRUB selection. This section runs as the ordinary account created during [Installation](https://github.com/guihn/ArchLinux-Installation/tree/main/English/Installation), with `sudo` for administrative commands. It installs the graphical environment, verifies the graphics modules and prepares the first Ly session.

## 1. Login and network

### 1.1 Account login

The reference account is `guihnxz`; another chosen account uses its corresponding name. Password entry does not echo characters. A successful login opens the initial Bash shell in the account's home directory. AUR builds run as this ordinary account, not as root.

### 1.2 NetworkManager connection

```bash
nmtui
```

**Activate a connection** lists the available connections. Selection of the appropriate wireless network opens its password prompt; a wired DHCP connection may already be active. Navigation uses arrows, Tab and Enter. After leaving the interface:

```bash
nmcli general status
ping -c 3 google.com
```

Name-resolution failures return through [DNS troubleshooting](https://github.com/guihn/ArchLinux-Installation/tree/main/English/Troubleshooting#1-dns-resolution). NetworkManager now manages the installed system; Live `iwctl` instructions are not repeated as its persistent network setup.

## 2. Mirrors and complete update

### 2.1 Mirror selection

`Brazil` remains the configurable reference country. Reflector updates the installed system's own mirror list:

```bash
sudo reflector --country Brazil --latest 20 --sort rate --verbose --save /etc/pacman.d/mirrorlist
sudo pacman -Syu
```

The first command must succeed before the second. `-Syu` refreshes repository databases and upgrades all installed packages. An isolated `pacman -Sy` followed by unrelated package installation can create an unsupported partial upgrade. A failed upgrade is resolved before subsequent installations; [keyring troubleshooting](https://github.com/guihn/ArchLinux-Installation/tree/main/English/Troubleshooting#2-package-signatures-and-keyring) addresses actual signature errors.

### 2.2 Kernel consistency

```bash
pacman -Q linux-zen linux-zen-headers
uname -r
```

The kernel package and its headers must correspond. `uname -r` identifies the **running** kernel, which may differ from the newly installed version after an update. DKMS and initramfs verification below concern the **installed kernel that will boot next**, not merely the running version.

## 3. AUR helper

### 3.1 Yay source and build

The Arch User Repository (AUR) hosts community build recipes. Yay coordinates their build and installation. The reference clone directory is `~/GitClones`; another directory is possible if subsequent paths match.

```bash
mkdir -p ~/GitClones
cd ~/GitClones
git clone https://aur.archlinux.org/yay.git
cd yay
nvim PKGBUILD
makepkg -si
cd ~
```

The PKGBUILD describes the source downloads and build actions. `makepkg -si` installs missing build dependencies, builds the package as the ordinary account and uses sudo when installation requires it. Compilation must finish successfully. An existing checkout is updated within its own directory instead of cloning over it.

### 3.2 Temporary build dependencies

The reference response is **Yes** when yay offers removal of temporary make dependencies **after a successful installation**. Such dependencies support compilation; runtime dependencies remain needed by the installed program. Packages used elsewhere, `base-devel` and the Linux Zen headers required for the DKMS workflow remain installed. Any removed temporary dependency can be installed again for a later build. Removal is not an instruction to delete arbitrary dependencies or force package removal.

## 4. NVIDIA driver and early loading

### 4.1 Hardware and driver choice

The reference NVIDIA card is a GTX 750 Ti, Maxwell GM107. Its driver group uses the proprietary 580xx branch, rather than the open kernel modules intended for newer supported generations. [Arch's NVIDIA documentation](https://wiki.archlinux.org/title/NVIDIA) and [driver-transition notice](https://archlinux.org/news/nvidia-590-driver-drops-pascal-support-main-packages-switch-to-open-kernel-modules/) identify the relevant families.

Hardware identification is available through `lspci -nnk` from `pciutils`; when absent in the installed system, `sudo pacman -S --needed pciutils` supplies that diagnostic command. A different GPU requires its compatible package group and corresponding module/kernel settings. The 580xx packages are not a universal NVIDIA choice. AMD integrated graphics receive their Mesa stack in section 5.

### 4.2 One package transaction and DKMS verification

```bash
yay -S nvidia-580xx-dkms nvidia-580xx-utils lib32-nvidia-580xx-utils
pacman -Q linux-zen linux-zen-headers
dkms status
```

The three NVIDIA packages are installed together so their versions remain compatible. Multilib must already be active. DKMS compiles the external kernel modules against the corresponding installed headers. The output must show the NVIDIA module **installed** for each Linux Zen kernel that will be used. A build failure is resolved before early-loading configuration or reboot; its build log resides under the corresponding `/var/lib/dkms/` directory.

The installed release directories appear under `/usr/lib/modules/`. For a particular installed release, the diagnostic below uses its full directory name in place of `KERNEL_RELEASE`:

```bash
ls /usr/lib/modules
modinfo -k KERNEL_RELEASE nvidia
```

`KERNEL_RELEASE` is a substitution marker, not a literal release. Successful `modinfo` resolves the module file for the chosen installed kernel. The driver does not have to be loaded into the old running kernel to build a valid image for the new one.

### 4.3 Module configuration and image generation

Only after successful driver installation and DKMS verification:

```bash
sudo nvim /etc/mkinitcpio.conf
```

The reference **excerpt** is:

```bash
MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)
```

This array requests early inclusion of the NVIDIA modules. Other modules required by a different storage or hardware arrangement remain part of that arrangement's configuration. After the edit:

```bash
sudo mkinitcpio -P
sudo lsinitcpio /boot/initramfs-linux-zen.img | grep -E 'nvidia(_modeset|_uvm|_drm)?\.ko'
```

Generation must finish without missing-module errors, and image inspection must identify the four NVIDIA module files, possibly compressed. Merely editing `MODULES` cannot change an existing image. A package hook may generate an image during installation, but an edit made afterward requires this subsequent rebuild. Another chosen kernel uses its corresponding image name.

## 5. Desktop and supporting packages

### 5.1 Reference package group

```bash
sudo pacman -S \
  amd-ucode \
  mesa vulkan-radeon libva-mesa-driver \
  pipewire wireplumber pipewire-alsa pipewire-pulse \
  bluez bluez-utils \
  foot yazi \
  waybar \
  wl-clipboard cliphist \
  hyprland hypridle hyprpaper hyprpolkitagent hyprtoolkit hyprlauncher hyprshot \
  xdg-desktop-portal-hyprland xdg-user-dirs xorg-xwayland \
  fastfetch imagemagick ly \
  ttf-hack-nerd noto-fonts-emoji zsh \
  wofi brightnessctl playerctl qt5ct
```

`amd-ucode` supplies AMD CPU microcode, not an AMD graphics driver. Mesa provides OpenGL and VA-API support; `libva-mesa-driver` is a provided package name satisfied by current Mesa packaging. `vulkan-radeon` supplies the AMD Vulkan driver. Intel CPUs or other GPUs require their respective choices instead of a universal copy of the reference hardware stack.

The [System Profile](https://github.com/guihn/ArchLinux-Installation/tree/main/English/System%20Profile) maps every component to its package identifiers and role. PipeWire, WirePlumber and their compatibility packages supply sound; BlueZ supplies Bluetooth; portals integrate applications with the Wayland session; XWayland supports X11 applications.

### 5.2 Configuration dependencies

| Package | Configuration use |
| --- | --- |
| `wofi` | Menu for selecting an item from clipboard history. |
| `brightnessctl` | Brightness-key commands on devices exposing a supported backlight. |
| `playerctl` | Previous/next track and play/pause commands for MPRIS-compatible media applications. |
| `qt5ct` | The `QT_QPA_PLATFORMTHEME=qt5ct` choice for Qt 5 applications. |

`playerctl` is a media controller, not an audio server or a player. Its commands communicate with applications such as Spotify through MPRIS. Brightness keys do not automatically control every external monitor; hardware support determines their effect. The Qt 5 theme setting does not claim to configure every Qt 6 application.

### 5.3 Hyprland ecosystem

Hypridle manages inactivity: the reference turns displays off after 60 seconds and restores them on activity, without a lock screen. Hyprpolkitagent supplies graphical authentication prompts and starts as a user service from the session. Hyprlauncher is the application launcher and runs its daemon through autostart. Hyprtoolkit provides common theming infrastructure for applications that use it.

Hyprpaper and Waybar are optional wallpaper and bar processes in the complete personal example. A wallpaper requires an existing image and a matching hyprpaper configuration; its selection is independent of the core compositor setup. Hyprtoolkit's personal monochrome theme remains optional planned customization.

## 6. Applications and shell

### 6.1 Additional applications

```bash
yay -S vscodium-bin spotify pwvucontrol brave-nightly-bin
```

The reference group contains VSCodium, Spotify, the PipeWire volume interface and Brave Nightly. Yay can resolve packages from the official repositories as well as AUR recipes; a package's actual source is shown in the transaction. These are personal application choices. Alternatives may replace them, with dependent commands and startup entries adapted accordingly.

Discord is optional, but its package is needed before enabling the Discord startup line in the personal configuration:

```bash
sudo pacman -S discord
```

### 6.2 Zsh selection

```bash
chsh -s /bin/zsh
```

The command changes the current account's login shell after Zsh has been installed. A new login applies the change. Bash remains a valid alternative; the optional Fastfetch example then belongs in the corresponding shell's interactive configuration rather than `.zshrc`.

## 7. Services and boot readiness

### 7.1 Bluetooth, Ly and user directories

```bash
sudo systemctl enable bluetooth
sudo systemctl disable getty@tty2.service
sudo systemctl enable ly@tty2
xdg-user-dirs-update
```

Bluetooth activation is optional when the machine does not use it. The reference enables it for the next boot; the [Bluetooth procedure](https://github.com/guihn/ArchLinux-Installation/tree/main/English/Troubleshooting#3-bluetooth) covers adapter activation and pairing. Ly uses TTY 2. Disabling the separate getty on that TTY avoids competition for the same login console, as described by [Ly's documentation](https://github.com/fairyglade/ly). Another display manager requires its own service instead of simultaneous activation with Ly.

`xdg-user-dirs-update` creates standard personal directories according to the configured locale. It runs as the ordinary account.

### 7.2 Final images and configuration

The package group includes CPU microcode and may trigger image updates. A final generation after all relevant packages establishes the boot files and current GRUB entries:

```bash
sudo mkinitcpio -P
sudo grub-mkconfig -o /boot/grub/grub.cfg
systemctl is-enabled NetworkManager ly@tty2
```

Successful image generation and correct GRUB entries precede the next boot. NVIDIA modules must remain available for the chosen kernel. GRUB retains its indefinite manual-selection menu.

### 7.3 Graphical session

```bash
reboot
```

After the manual GRUB selection, Ly presents login and session fields. The Hyprland session is selected for the ordinary account. The installed package supplies its initial configuration when necessary; the next section replaces it with the modular reference only after backup and adaptation.

The result is an installed graphical stack. [Hyprland](https://github.com/guihn/ArchLinux-Installation/tree/main/English/Hyprland) continues with configuration-file deployment, monitors, input and session verification.

[Previous](https://github.com/guihn/ArchLinux-Installation/tree/main/English/Installation) · [Index](https://github.com/guihn/ArchLinux-Installation/tree/main/English) · [Next](https://github.com/guihn/ArchLinux-Installation/tree/main/English/Hyprland)
