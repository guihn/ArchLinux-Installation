<table width="100%">
<tr>
<td align="left" width="5000"><strong>English</strong> | <a href="https://github.com/guihn/ArchLinux-Installation/tree/main/Portugu%C3%AAs/Solu%C3%A7%C3%A3o%20de%20Problemas">Português</a></td>
<td align="right" width="5000"><a href="https://github.com/guihn/ArchLinux-Installation/tree/main/English">Index</a></td>
</tr>
</table>

# Troubleshooting

These procedures apply to specific failures rather than every installation. Each issue identifies its symptom, execution environment and return point. Commands with substitution markers require the actual interface, connection or device identifier.

## 1. DNS resolution

### 1.1 Connectivity versus name resolution

A name-resolution error from `ping -c 3 google.com` or package downloads can indicate DNS trouble. The following distinguishes an IP path from name lookup:

```bash
ip address
ip route
ping -c 3 1.1.1.1
getent hosts google.com
```

Successful IP connectivity with failed name lookup points toward DNS. A missing address or default route requires network connection repair first; blocked ICMP also prevents a ping result from being conclusive.

### 1.2 Live DNS configuration

The Live environment's systemd-resolved settings are visible through:

```bash
resolvectl status
resolvectl dns INTERFACE 1.1.1.1 8.8.8.8
resolvectl domain INTERFACE '~.'
```

`INTERFACE` is the active name from `ip address`, such as `wlan0` or an Ethernet interface. These example public DNS servers replace the interface's resolver selection temporarily; network policy may require different servers. `resolvectl revert INTERFACE` removes the override.

<details>
<summary>Manual resolv.conf alternative for an unmanaged regular file</summary>

When DNS is deliberately managed through a regular `/etc/resolv.conf` instead of a resolver service or symlink, its relevant contents can be:

```text
nameserver 1.1.1.1
nameserver 8.8.8.8
```

In the Live root shell, the following preserves a backup and writes the example only when the path is a regular file rather than a symlink. It is applicable only when no service manages that file:

```bash
if [ -f /etc/resolv.conf ] && [ ! -L /etc/resolv.conf ]; then
    resolver_backup=$(mktemp /root/resolv.conf.backup.XXXXXXXX)
    cp -a /etc/resolv.conf "$resolver_backup"
    printf 'nameserver 1.1.1.1\nnameserver 8.8.8.8\n' > /etc/resolv.conf
    printf '%s\n' "$resolver_backup"
fi
```

This shell alternative works without installing an editor during a DNS failure. On an installed system with Neovim, `sudo nvim /etc/resolv.conf` edits the same unmanaged file; `i`, `Esc`, `:wq`, Enter handle insertion and saving. A managed file is configured through its owning service instead.

</details>

### 1.3 Installed NetworkManager connection

The installed system uses NetworkManager. Its connection name is identified by:

```bash
nmcli connection show --active
```

For a deliberate IPv4 DNS override, `CONNECTION` below is replaced by the exact active connection name:

```bash
sudo nmcli connection modify "CONNECTION" ipv4.ignore-auto-dns yes ipv4.dns "1.1.1.1 8.8.8.8"
sudo nmcli connection up "CONNECTION"
```

Reactivation can briefly interrupt the connection. An IPv6 or network-policy issue requires its corresponding settings rather than assuming every DNS failure is IPv4. The IPv4 override is reversed with `ipv4.ignore-auto-dns no ipv4.dns ""`, followed by connection reactivation.

### 1.4 Verification and return

```bash
getent hosts google.com
ping -c 3 google.com
```

Working name lookup and connectivity allow continuation at [Live networking](https://github.com/guihn/ArchLinux-Installation/tree/main/English/Installation#14-network-connection) or [installed networking](https://github.com/guihn/ArchLinux-Installation/tree/main/English/Post%20Installation#12-networkmanager-connection), depending on the environment.

## 2. Package signatures and keyring

### 2.1 Clock and symptoms

Symptoms include unknown signing keys or invalid package signatures during an otherwise connected package transaction. The Arch keyring identifies trusted package signers. A clock error, obsolete signing keys, an incomplete download or a mirror problem requires diagnosis before keyring reset.

```bash
timedatectl status
```

The clock must be correct. The [package-signing documentation](https://wiki.archlinux.org/title/Pacman/Package_signing) explains each failure class. Signature checking remains enabled; accepting unverified packages is not part of this procedure.

### 2.2 Updating known keys

In the **Live root shell**, an outdated keyring can be updated before retrying `pacstrap`:

```bash
pacman -Sy archlinux-keyring
```

This specific keyring recovery is distinct from routine `pacman -Sy` followed by arbitrary installations. In the **installed system**, the keyring update is immediately followed by the complete upgrade, only if the first command succeeds:

```bash
sudo pacman -Sy archlinux-keyring && sudo pacman -Su
```

Normal updates continue to use `sudo pacman -Syu`. An old Live image with unresolved recovery problems can be replaced by a current verified installation image before another attempt.

### 2.3 Reset only for a damaged keyring

<details>
<summary>Keyring backup and reconstruction</summary>

This fallback applies to a damaged local keyring after clock, network and update checks. It removes the local key store and therefore also removes any separately imported keys. The backup preserves those records for later verification and restoration as needed.

The following runs in a **root shell**. The Live shell already has that privilege; an installed-system account enters one with `sudo -i`.

```bash
keyring_backup=$(mktemp -d /root/pacman-keyring-backup.XXXXXXXX)
cp -a /etc/pacman.d/gnupg "$keyring_backup/"
```

Successful backup precedes removal. The reconstruction sequence is:

```bash
rm -rf /etc/pacman.d/gnupg
pacman-key --init
pacman-key --populate archlinux
pacman -Sy archlinux-keyring
```

Each command must finish successfully before the next. In the installed system, `pacman -Su` completes the upgrade before any other package installation, and `exit` returns from the temporary root shell to the ordinary account. In Live, the recovered keyring precedes another `pacstrap` attempt. A remaining signature failure requires inspection of the specific error rather than repeated deletion.

</details>

### 2.4 Return to installation

Successful signature verification returns to [base installation](https://github.com/guihn/ArchLinux-Installation/tree/main/English/Installation#32-kernel-and-essential-packages) or [complete system update](https://github.com/guihn/ArchLinux-Installation/tree/main/English/Post%20Installation#21-mirror-selection). The keyring reset is not a routine prerequisite for either step.

## 3. Bluetooth

### 3.1 Service and adapter

This procedure applies to a missing connection or pairing failure after the Bluetooth packages are installed. In the installed system:

```bash
sudo systemctl start bluetooth
systemctl status bluetooth
rfkill list
bluetoothctl
```

A software or hardware radio block must be resolved for the identified adapter. `bluetoothctl` opens an interactive prompt; the commands below run there.

### 3.2 Pairing and connection commands

`XX:XX:XX:XX:XX:XX` represents the real Bluetooth device address from discovery. Power, agent setup, scanning, pairing, trust and connection are separate operations.

| Command | Purpose |
| --- | --- |
| `power on` | Enable the adapter. |
| `agent on` | Enable the pairing agent. |
| `default-agent` | Select the default agent. |
| `scan on` | Start device discovery. |
| `scan off` | Stop discovery after the target appears. |
| `devices` | List discovered devices and addresses. |
| `pair XX:XX:XX:XX:XX:XX` | Pair with the selected device; confirmation may be required. |
| `trust XX:XX:XX:XX:XX:XX` | Mark the device trusted for later connections. |
| `connect XX:XX:XX:XX:XX:XX` | Establish a connection. |
| `disconnect XX:XX:XX:XX:XX:XX` | End the connection. |
| `remove XX:XX:XX:XX:XX:XX` | Remove the pairing record for a deliberate fresh pairing. |
| `quit` | Leave bluetoothctl. |

### 3.3 Return to the main procedure

The expected result is a powered adapter and a successful connection to the selected device. Pairing codes must match the intended device. A failed connection can require pairing mode on the peripheral or inspection of `journalctl -b -u bluetooth`. Successful recovery returns to [service configuration](https://github.com/guihn/ArchLinux-Installation/tree/main/English/Post%20Installation#71-bluetooth-ly-and-user-directories).

[Index](https://github.com/guihn/ArchLinux-Installation/tree/main/English)
