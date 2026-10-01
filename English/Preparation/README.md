<table width="100%">
<tr>
<td align="left" width="5000"><strong>English</strong> | <a href="https://github.com/guihn/ArchLinux-Installation/tree/main/Portugu%C3%AAs/Prepara%C3%A7%C3%A3o">Português</a></td>
<td align="right" width="5000"><a href="https://github.com/guihn/ArchLinux-Installation/tree/main/English">Index</a> | <a href="https://github.com/guihn/ArchLinux-Installation/tree/main/English/Installation">Next</a></td>
</tr>
</table>

# Preparation

This section prepares a USB installer and the firmware boot mode. It begins on a working computer with Internet access and ends at the Arch Linux Live terminal. The Live environment runs from installation media; it is separate from the system that will be installed on the disk.

## 1. Installation media

### 1.1 Backups and device selection

Ventoy installation repartitions the selected USB drive and erases its existing data. A backup on another device is required before that operation. The installation disk also needs a separate backup before any partitioning or formatting in the next section. USB capacity, model and device identity distinguish it from the internal SSD.

### 1.2 Arch Linux ISO

The [Arch Linux download page](https://archlinux.org/download/) lists the current installation image and download methods. Its HTTP mirror list is organized by country. Brazil is the reference location; a suitable nearby country is an alternative. A selected server opens a directory containing the current `archlinux-…-x86_64.iso`, its signature and checksum information. The `.iso` file contains the installation environment; it is downloaded intact rather than extracted.

The release version and filename come from the current download page. A mirror's synchronized release and checksum must correspond to that same file.

### 1.3 Download verification

The official download page provides verification information. On Linux, `sha256sum` prints the SHA-256 checksum of the downloaded ISO; comparison with the matching published value checks file integrity. `ARCH_ISO.iso` below represents the actual downloaded filename.

```bash
sha256sum ARCH_ISO.iso
```

On Windows, the equivalent PowerShell command is:

```powershell
Get-FileHash .\ARCH_ISO.iso -Algorithm SHA256
```

A matching hash verifies agreement with the published checksum. Signature verification also authenticates the release when its signing key has been verified, following the official download instructions.

### 1.4 Ventoy installation

The [Ventoy download page](https://www.ventoy.net/en/download.html) supplies Windows and Linux distributions, with checksum information. The downloaded archive is extracted before the appropriate program starts. Ventoy prepares the USB once; ISO files can then be copied onto its data partition.

On Windows, `Ventoy2Disk.exe` opens the installer. The **Device** field identifies the USB drive by capacity and model. **Install** writes Ventoy after its data-loss confirmations. On Linux, `VentoyGUI.x86_64` offers the graphical interface; the command-line alternative below runs from the extracted Ventoy directory with administrator privileges:

```bash
sudo sh Ventoy2Disk.sh -i /dev/sdX
```

`/dev/sdX` represents the whole identified USB device, never an individual partition or the internal installation disk. `lsblk -o NAME,SIZE,MODEL,TRAN,MOUNTPOINTS` helps identify it. `-i` performs an installation and refuses an existing Ventoy installation; upgrades use the separate documented update operation.

Ventoy's own USB partition-table setting is separate from the installed system's disk layout. The firmware's supported boot mode governs its suitability. The [Ventoy getting-started instructions](https://www.ventoy.net/en/doc_start.html) explain the available media settings.

### 1.5 ISO transfer

After successful Ventoy installation, its large data partition appears as a normal removable volume. The complete Arch ISO is copied there as a file. Safe removal after the copy finishes ensures that buffered writes reach the USB drive. At boot, Ventoy lists the ISO and opens the Arch boot menu after selection.

## 2. Firmware and boot selection

### 2.1 Firmware access

Firmware setup and the temporary boot menu are entered using the shortcuts documented by the computer or motherboard manufacturer. Keys such as Delete, F2 or F8 are examples only; the model's manual supplies the actual key. The same applies to menu names, saving changes and exiting. A firmware setting can change boot order permanently, while a one-time boot menu chooses the USB for one boot.

### 2.2 UEFI and BIOS/Legacy

The main reference uses UEFI with GPT. A USB entry explicitly marked UEFI starts that route. BIOS/Legacy is an alternative only when the machine provides compatible firmware or a compatibility support module (CSM) and can boot the selected disk. Legacy boot from an NVMe drive requires firmware support; visibility of the drive after Linux starts does not establish that support.

The unmodified Arch installation medium does not provide an automatically configured Secure Boot installation. The reference procedure uses Secure Boot disabled in the model-specific firmware settings. A signed Secure Boot setup requires the separate [Arch documentation](https://wiki.archlinux.org/title/Unified_Extensible_Firmware_Interface/Secure_Boot).

GPT is used for both routes in this guide. GPT and MBR are partition-table schemes, whereas FAT32 and ext4 are filesystems. The partition-table choice remains an installation decision based on firmware, disk and other operating systems. The installation section also explains the BIOS/MBR alternative and its different partition numbering.

### 2.3 Arch Live startup

After USB selection, Ventoy opens the chosen Arch ISO and its installation entry. The resulting root shell is a command interpreter with administrator privileges in the temporary environment. The next section verifies the actual boot mode before formatting any disk.

The installer is now running. [Installation](https://github.com/guihn/ArchLinux-Installation/tree/main/English/Installation) continues with keyboard, network, storage and the base system.

[Index](https://github.com/guihn/ArchLinux-Installation/tree/main/English) · [Next](https://github.com/guihn/ArchLinux-Installation/tree/main/English/Installation)
