<table width="100%">
<tr>
<td align="left" width="5000"><strong>English</strong> | <a href="https://github.com/guihn/ArchLinux-Installation/tree/main/Portugu%C3%AAs/Instala%C3%A7%C3%A3o">Português</a></td>
<td align="right" width="5000"><a href="https://github.com/guihn/ArchLinux-Installation/tree/main/English/Preparation">Previous</a> | <a href="https://github.com/guihn/ArchLinux-Installation/tree/main/English">Index</a> | <a href="https://github.com/guihn/ArchLinux-Installation/tree/main/English/Post%20Installation">Next</a></td>
</tr>
</table>

# Installation

The Arch Live environment from [Preparation](https://github.com/guihn/ArchLinux-Installation/tree/main/English/Preparation) is running. Commands through section 3 run as root in that environment; section 4 enters the new system through chroot. This page reaches a bootable console installation. Graphics drivers and the desktop follow in [Post Installation](https://github.com/guihn/ArchLinux-Installation/tree/main/English/Post%20Installation).

## 1. Live environment

### 1.1 Terminal, command results and font

The terminal accepts commands at the shell prompt. Paths, capitalization, spaces, quotes and punctuation are significant. A command may finish without printing a message; silence alone does not prove success. Immediately after a command, `echo $?` reports its exit status: zero normally indicates success. The expected files, mounts or service status provide additional confirmation.

For a larger console font, the Live environment supports:

```bash
setfont ter-132b
```

This affects the current console rather than the later graphical desktop.

### 1.2 Actual firmware mode

```bash
if [ -d /sys/firmware/efi ]; then
    echo UEFI
else
    echo BIOS/Legacy
fi
```

`UEFI` selects the UEFI/GPT route in section 2.3 and the UEFI bootloader target in section 4.8. `BIOS/Legacy` selects section 2.4 and the BIOS target. On UEFI, `ls /sys/firmware/efi/efivars` also shows the firmware-variable interface used for boot entries. A directory listing error is not a successful boot-mode test. A mode change requires another USB boot through the corresponding firmware entry.

### 1.3 Keyboard layout

The reference console keyboard is Brazilian ABNT2:

```bash
loadkeys br-abnt2
```

Another keyboard requires its own keymap; `loadkeys us` is the US example. `localectl list-keymaps` lists available choices. Correct punctuation and characters at the prompt confirm a suitable layout. The chosen keymap is reused in `/etc/vconsole.conf`; the language of this document does not select the keyboard or system locale.

### 1.4 Network connection

Wired networks with DHCP normally obtain a connection automatically. Wireless configuration uses IWD's interactive `iwctl` prompt:

```bash
iwctl
```

The following commands run **inside iwctl**. `device list` supplies the real wireless device name; `wlan0` is an example used consistently below. `SSID` represents the network name, with quotes preserving spaces. The password is entered at the interactive prompt.

```text
device list
station wlan0 scan
station wlan0 get-networks
station wlan0 connect "SSID"
exit
```

Back in the Live shell:

```bash
ip address
ip route
ping -c 3 google.com
```

An address, a usable route and successful replies indicate working connectivity. Some networks block ICMP, so a failed ping alone does not identify a DNS failure. Name-resolution failures have a conditional [DNS procedure](https://github.com/guihn/ArchLinux-Installation/tree/main/English/Troubleshooting#1-dns-resolution), with a return to this step.

### 1.5 Clock synchronization

```bash
timedatectl set-ntp true
timedatectl status
```

Network time synchronization provides the correct time for TLS connections and package-signature validity. The displayed clock and synchronization status must be consistent before package installation. Signature errors have a separate [keyring procedure](https://github.com/guihn/ArchLinux-Installation/tree/main/English/Troubleshooting#2-package-signatures-and-keyring); resetting the keyring is not a routine installation step.

## 2. Partitioning, formatting and mounting

### 2.1 Disk identification and existing systems

```bash
lsblk -o NAME,SIZE,MODEL,TYPE,FSTYPE,MOUNTPOINTS
fdisk -l
```

The reference disk is `/dev/nvme0n1`; its partitions are `/dev/nvme0n1p1`, `/dev/nvme0n1p2` and `/dev/nvme0n1p3`. A SATA disk commonly appears as `/dev/sda`, with `/dev/sda1` partitions; `/dev/vda` commonly identifies a virtual disk. Model, size and existing filesystems determine the actual destination. Device names can change between machines and boots.

**The new-disk procedures below destroy existing data on the selected partitions. Backup completion and positive identification of the target precede partition deletion, table replacement and formatting.** A USB installer is not the installation disk.

For dual boot, existing operating-system partitions remain intact. An existing suitable EFI System Partition can be mounted at `/mnt/boot/efi` **without formatting it**. Its real number replaces `p1` in the EFI mount. Free space is allocated for Arch, and every root/swap command uses the newly identified partition numbers. The whole-disk deletion procedure does not apply to that case. GRUB discovery of another installed system is explained in section 4.8.

### 2.2 Swap and partition-table choices

Swap provides disk-backed memory when useful to the workload. The reference machine has 32 GiB of RAM and allocates half that amount, 16 GiB, to swap.

| Profile | Swap size | Use |
| --- | --- | --- |
| Basic | 8 GiB | Optional smaller allocation. |
| Balanced | Half of RAM; 16 GiB for 32 GiB | Reference allocation. |
| Larger allocation | 32 GiB | Optional additional capacity when disk space permits. |

These are configuration examples, not universal minimums. Workload, RAM and available disk space govern the choice. This procedure does not configure hibernation.

Both main routes use **GPT**. The choice of GPT or MBR remains with the installation's requirements. GPT works with GRUB on both compatible BIOS and UEFI systems, but their boot partitions are different. The optional BIOS/MBR route in section 2.5 changes the layout and partition numbers; table selection and filesystem formatting are separate operations.

### 2.3 UEFI with GPT

```bash
cfdisk /dev/nvme0n1
```

On a disk without a table, `gpt` selects the table type. An existing disk opens its existing table: its type must be verified before edits. For a deliberately erased installation disk, existing partitions are removed using **Delete**, leaving **Free space**. **New** creates each partition in the order below; **Type** assigns its purpose. **Write**, confirmation with `yes`, then **Quit** saves the layout. A disk with an unwanted existing table can be reinitialized through `fdisk /dev/nvme0n1`, using `g` for GPT and `w` to write, only after backup and explicit whole-disk replacement.

| Order | Device | Size | Type | Filesystem and destination |
| --- | --- | --- | --- | --- |
| 1 | `/dev/nvme0n1p1` | 512 MiB (`512M`) | EFI System | FAT32 at `/boot/efi` |
| 2 | `/dev/nvme0n1p2` | 16 GiB (`16G`) | Linux swap | Swap |
| 3 | `/dev/nvme0n1p3` | Remaining space | Linux filesystem | ext4 at `/`, including `/home` |

Formatting and swap activation for these **new partitions**:

```bash
mkfs.fat -F32 /dev/nvme0n1p1
mkswap /dev/nvme0n1p2
swapon /dev/nvme0n1p2
mkfs.ext4 /dev/nvme0n1p3
```

The root filesystem is mounted first. The EFI directory is then created inside it:

```bash
mount /dev/nvme0n1p3 /mnt
mkdir -p /mnt/boot/efi
mount /dev/nvme0n1p1 /mnt/boot/efi
```

`/mnt` becomes `/` inside the installed system, and `/mnt/boot/efi` becomes `/boot/efi`. Root and home share `p3`; no separate home partition is created. The kernel and initramfs reside in `/boot` on ext4, while the EFI bootloader resides on the FAT32 partition. This route continues at section 2.6.

### 2.4 BIOS/Legacy with GPT

This route requires confirmed BIOS/Legacy boot and firmware capable of booting the selected disk. The NVMe name remains the reference example; BIOS access to NVMe is hardware-dependent. A BIOS-incompatible boot disk cannot be made compatible merely by changing its partition table.

`cfdisk /dev/nvme0n1` opens the target. GPT selection, deliberate removal of old partitions, **New**, **Type**, **Write**, `yes` and **Quit** follow the same interface as section 2.3. The partition layout is:

| Order | Device | Size | Type | Filesystem and destination |
| --- | --- | --- | --- | --- |
| 1 | `/dev/nvme0n1p1` | 1 MiB (`1M`) | BIOS boot | No filesystem; no mount point |
| 2 | `/dev/nvme0n1p2` | 16 GiB (`16G`) | Linux swap | Swap |
| 3 | `/dev/nvme0n1p3` | Remaining space | Linux filesystem | ext4 at `/`, including `/home` |

The BIOS boot partition reserves raw space for GRUB's core image. It is neither an EFI System Partition nor a filesystem. Formatting affects only swap and root:

```bash
mkswap /dev/nvme0n1p2
swapon /dev/nvme0n1p2
mkfs.ext4 /dev/nvme0n1p3
mount /dev/nvme0n1p3 /mnt
```

No EFI mount is created. The kernel, initramfs and GRUB configuration remain in `/boot` within the root filesystem. GRUB later uses `--target=i386-pc` on the **whole disk**, even though Arch is x86_64. This layout follows the [GNU GRUB BIOS installation documentation](https://www.gnu.org/software/grub/manual/grub/html_node/BIOS-installation.html) and [Arch partitioning reference](https://wiki.archlinux.org/title/Partitioning). This route continues at section 2.6.

### 2.5 Optional BIOS/Legacy with MBR

MBR is an alternative when required by the firmware or the intended disk arrangement. Its usual 512-byte-sector capacity limit is about 2 TiB, and it supports four primary partition entries; disk geometry and other operating systems require consideration. The guide's main BIOS example remains GPT.

For a deliberately erased installation disk, `fdisk /dev/nvme0n1` followed by `o` and `w` creates an MBR/DOS table. This replaces the table and is unsuitable for preserving existing partitions. In `cfdisk`, **dos** is the table choice on a blank disk. With 512-byte logical sectors, a default start at sector 2048 leaves 1 MiB before the first partition for GRUB embedding; no BIOS boot partition is created.

| Order | Device | Size | MBR type | Filesystem and destination |
| --- | --- | --- | --- | --- |
| 1 | `/dev/nvme0n1p1` | 16 GiB | Linux swap (`82`) | Swap |
| 2 | `/dev/nvme0n1p2` | Remaining space | Linux (`83`) | ext4 at `/`, including `/home` |

```bash
mkswap /dev/nvme0n1p1
swapon /dev/nvme0n1p1
mkfs.ext4 /dev/nvme0n1p2
mount /dev/nvme0n1p2 /mnt
```

This route uses the BIOS package command and the same whole-disk BIOS GRUB target as GPT. Its shutdown swap device is **p1**, not p2. `fdisk -l /dev/nvme0n1` confirms the table and start sectors before proceeding. GPT/UEFI formatting commands do not apply to this alternative.

### 2.6 Mount verification

```bash
lsblk -f
findmnt -R /mnt
swapon --show
```

The selected root must appear at `/mnt`, the selected swap must be active, and **only UEFI** requires an EFI partition at `/mnt/boot/efi`. A missing or incorrect mount is resolved before `pacstrap` so that packages reach the intended filesystem.

## 3. Mirrors and base system

### 3.1 Package mirrors

Reflector selects recently synchronized mirrors and sorts them by measured transfer rate. `Brazil` is the reference country, configurable to the relevant location; `reflector --list-countries` lists accepted names.

```bash
reflector --country Brazil --latest 20 --sort rate --verbose --save /etc/pacman.d/mirrorlist
```

The resulting `/etc/pacman.d/mirrorlist` supplies the download servers for installation. A failed mirror update requires working connectivity or another suitable mirror selection before continuing.

### 3.2 Kernel and essential packages

`pacstrap` installs packages into the mounted root. Linux Zen and its matching headers are the reference kernel; `base-devel` provides the build toolchain later needed by AUR and DKMS. `linux-firmware` supplies device firmware. The remaining packages provide mirrors, privilege elevation, Neovim, GRUB, networking and Git. The desktop is installed after the first boot.

**UEFI:**

```bash
pacstrap /mnt base base-devel linux-zen linux-zen-headers linux-firmware \
  reflector sudo neovim grub efibootmgr networkmanager git
```

**BIOS/Legacy, GPT or MBR:**

```bash
pacstrap /mnt base base-devel linux-zen linux-zen-headers linux-firmware \
  reflector sudo neovim grub networkmanager git
```

Only one command applies. `efibootmgr` manages UEFI firmware boot entries and is not required by BIOS GRUB. Success means the package transaction completed without unresolved errors. Package-signature failures return through [keyring troubleshooting](https://github.com/guihn/ArchLinux-Installation/tree/main/English/Troubleshooting#2-package-signatures-and-keyring).

Another kernel remains an optional choice: `linux` pairs with `linux-headers`, while `linux-lts` pairs with `linux-lts-headers`. That substitution affects DKMS builds, `/boot` image names, initramfs verification and GRUB entries throughout the guide. The reference commands continue with Linux Zen.

### 3.3 Persistent mounts

```bash
genfstab -U /mnt >> /mnt/etc/fstab
cat /mnt/etc/fstab
```

`-U` records filesystem UUIDs rather than variable device names. The new file must describe root and swap, plus `/boot/efi` for UEFI. The append operation is performed once; repeating it blindly duplicates entries. UUIDs and mount points are checked against `lsblk -f` and the selected layout.

## 4. Installed-system configuration

### 4.1 Chroot transition

```bash
arch-chroot /mnt
```

Chroot changes the root directory used by commands to the installed system. Commands from this point run as root inside that system; `/mnt/etc` becomes `/etc`. The Live shell returns only after `exit` in section 6.2.

### 4.2 Neovim editing

`nvim PATH` opens a file. The following keys apply to Neovim, including `EDITOR=nvim visudo` later:

| Key or command | Result |
| --- | --- |
| `i` | Insert mode for text entry. |
| `Esc` | Return to normal mode. |
| `/text`, then Enter | Search for text; `n` reaches the next match. |
| `x` in normal mode | Delete the character under the cursor, such as a leading `#`. |
| `:w`, then Enter | Save. |
| `:wq`, then Enter | Save and exit. |
| `:q!`, then Enter | Discard unsaved changes and exit. |

Examples below show either complete small files or explicitly labeled excerpts. Unrelated contents of an existing configuration file remain intact.

### 4.3 Time zone and hardware clock

The reference time zone is `America/Sao_Paulo`. A different region/city is selected from `/usr/share/zoneinfo`; compound names use their actual filesystem spelling, such as the underscore in `Sao_Paulo`.

```bash
ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
hwclock --systohc
```

The symlink selects local civil time. `hwclock --systohc` writes the synchronized system time to the hardware clock and establishes its adjustment information; UTC hardware-clock use is the Linux reference. Dual boot requires consistent hardware-clock handling between operating systems.

### 4.4 Locales and console keyboard

```bash
nvim /etc/locale.gen
```

The reference system uses English. The relevant **excerpt** changes from `#en_US.UTF-8 UTF-8` to:

```text
en_US.UTF-8 UTF-8
```

`pt_BR.UTF-8 UTF-8` is an optional additional locale when needed. Multiple locales can be generated, while one is selected as the default:

```bash
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "KEYMAP=br-abnt2" > /etc/vconsole.conf
```

The `LANG` value must match a generated locale. For a Portuguese system, the corresponding choice is `LANG=pt_BR.UTF-8`, after its locale has been enabled and generated. `KEYMAP` matches the console layout selected in section 1.3; a US keyboard uses `KEYMAP=us`. The documentation language does not change these reference values.

### 4.5 Hostname and hosts file

`secura` is the reference machine name. A different hostname replaces it consistently in both files; placeholders such as `myhostname` represent that selected value rather than a required literal name.

```bash
echo "secura" > /etc/hostname
nvim /etc/hosts
```

The relevant hosts entries are:

```text
127.0.0.1   localhost
::1         localhost
127.0.1.1   secura.localdomain secura
```

These entries resolve local names. Existing unrelated hosts entries remain intact. The hostname identifies the machine in local administration and compatible network discovery.

### 4.6 Pacman configuration

```bash
nvim /etc/pacman.conf
```

The following are **excerpts**, not a replacement for the whole file. In `[options]`, the relevant settings become:

```ini
[options]
Color
ILoveCandy
ParallelDownloads = 10
```

`#Color` becomes `Color`; `ILoveCandy` is added immediately below it. The existing `ParallelDownloads` value becomes `10`. Color enables colored output, ILoveCandy changes the progress animation, and ParallelDownloads permits concurrent transfers. Ten is the reference preference; a slower network may benefit from a lower value.

The repository excerpt changes from:

```ini
#[multilib]
#Include = /etc/pacman.d/mirrorlist
```

to:

```ini
[multilib]
Include = /etc/pacman.d/mirrorlist
```

Both lines must be active. Multilib supplies 32-bit software, including the reference NVIDIA `lib32` utilities. Other pacman options and repositories remain present.

### 4.7 Base initramfs

An initramfs is the early userspace image used before the real root filesystem is available. The base image must be generated successfully for the installed Linux Zen kernel:

```bash
mkinitcpio -P
ls -lh /boot/vmlinuz-linux-zen /boot/initramfs-linux-zen.img
```

At this stage, `/etc/mkinitcpio.conf` does not require NVIDIA modules that have not been installed. Missing-module or generation errors require correction before boot. The NVIDIA-specific module array is configured only after successful driver installation and DKMS compilation in Post Installation.

### 4.8 GRUB installation and menu

The target matches the firmware route established in section 1.2.

**UEFI:**

```bash
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=ArchLinux
```

**BIOS/Legacy, GPT or MBR:**

```bash
grub-install --target=i386-pc /dev/nvme0n1
```

The BIOS destination is the whole selected boot disk, never `p1`, `p2` or `p3`. GPT uses its unformatted BIOS boot partition; MBR uses the reserved space before the first partition. A failed embedding or firmware-variable operation is resolved before configuration generation.

```bash
nvim /etc/default/grub
```

The relevant **excerpt** is:

```bash
GRUB_TIMEOUT_STYLE=menu
GRUB_TIMEOUT=-1
GRUB_CMDLINE_LINUX_DEFAULT="quiet loglevel=3 nvidia-drm.modeset=1 nvidia-drm.fbdev=1"
```

`GRUB_TIMEOUT=-1` leaves the menu waiting for **manual entry selection**. `quiet` and `loglevel=3` reduce routine boot output; their removal is useful during diagnosis. The NVIDIA parameters configure DRM modesetting and framebuffer behavior for the reference driver after its modules are available; they do not install or embed those modules. A machine using different graphics hardware does not inherit the NVIDIA-specific parameters automatically.

<details>
<summary>Optional dual-boot discovery</summary>

GRUB detection of another operating system uses `os-prober`, installed inside chroot with a complete update:

```bash
pacman -Syu os-prober
```

The corresponding line in `/etc/default/grub` becomes:

```bash
GRUB_DISABLE_OS_PROBER=false
```

The other system's partitions must be available to detection, with Windows fully shut down when applicable. The discovery output is checked during configuration generation. An existing EFI partition is reused without formatting; firmware boot mode must be compatible with the other system. A kernel update during this optional transaction requires successful initramfs generation before reboot.

</details>

```bash
grub-mkconfig -o /boot/grub/grub.cfg
```

Generation must find Linux Zen and its initramfs. Changes to `/etc/default/grub` take effect only after regenerating this configuration. Further details appear in the [GNU GRUB configuration manual](https://www.gnu.org/software/grub/manual/grub/html_node/Simple-configuration.html).

## 5. Accounts and administrative access

### 5.1 Root password

```bash
passwd
```

The prompt accepts and confirms the root password without displaying its characters. Root is the administrative account; its password is distinct from the ordinary account's credential in the reference procedure.

### 5.2 Ordinary account

`guihnxz` is the reference account name. Another chosen name replaces it consistently in account creation, password assignment and any explicit home paths. `username` is a placeholder for that name.

```bash
useradd -m -G wheel,audio,video,storage,input -s /bin/bash guihnxz
passwd guihnxz
```

`-m` creates the home directory; `-G` assigns supplementary groups; `-s` selects the initial shell. `wheel` is used for sudo authorization. The extra device-access groups are part of this personal reference setup; another session-management design may not need all of them. Bash is available now; Zsh is selected after its installation.

### 5.3 Sudo permissions

```bash
EDITOR=nvim visudo
```

`visudo` checks the sudoers syntax. The standard password-authenticated line becomes active after removal of its leading `#`:

```text
%wheel ALL=(ALL:ALL) ALL
```

<details>
<summary>Optional personal preference: passwordless sudo</summary>

The alternative line permits wheel members to execute any command without a sudo password prompt:

```text
%wheel ALL=(ALL:ALL) NOPASSWD: ALL
```

This replaces the password-authenticated choice rather than requiring both entries. It removes an authentication checkpoint for privileged commands and remains optional.

</details>

## 6. First boot

### 6.1 Network service

```bash
systemctl enable NetworkManager
```

This enables the service for the installed system's next boot. Live networking is already provided by the installation environment. The display manager is installed and enabled later.

### 6.2 Chroot exit and unmounting

For either **GPT** reference route, swap is `p2`. The first command below runs inside chroot, then `exit` returns to the Live shell:

```bash
swapoff /dev/nvme0n1p2
exit
```

For the optional **MBR** layout, the swap command is `swapoff /dev/nvme0n1p1` instead. A failed swap deactivation requires attention to memory use before continuing.

In the Live shell, recursive unmounting releases root and any nested EFI mount:

```bash
umount -R /mnt
reboot
```

A busy-mount error requires leaving directories and processes using `/mnt` before another unmount attempt. After a successful unmount and restart, the firmware boots the installed disk instead of the USB. GRUB waits for manual selection of the Arch entry. The resulting console login leads to [Post Installation](https://github.com/guihn/ArchLinux-Installation/tree/main/English/Post%20Installation).

[Previous](https://github.com/guihn/ArchLinux-Installation/tree/main/English/Preparation) · [Index](https://github.com/guihn/ArchLinux-Installation/tree/main/English) · [Next](https://github.com/guihn/ArchLinux-Installation/tree/main/English/Post%20Installation)
