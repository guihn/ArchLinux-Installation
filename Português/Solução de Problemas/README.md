<table width="100%">
<tr>
<td align="left" width="5000"><strong>Português</strong> | <a href="https://github.com/guihn/ArchLinux-Installation/tree/main/English/Troubleshooting">English</a></td>
<td align="right" width="5000"><a href="https://github.com/guihn/ArchLinux-Installation/tree/main/Portugu%C3%AAs">Índice</a></td>
</tr>
</table>

# Solução de Problemas

Estes procedimentos se aplicam a falhas específicas, em vez de toda instalação. Cada problema identifica sintoma, ambiente de execução e ponto de retorno. Comandos com marcadores exigem o identificador real da interface, conexão ou dispositivo.

## 1. Resolução de DNS

### 1.1 Conectividade e resolução de nomes

Um erro de resolução em `ping -c 3 google.com` ou no download de pacotes pode indicar problema de DNS. A sequência abaixo distingue o caminho por IP da consulta por nome:

```bash
ip address
ip route
ping -c 3 1.1.1.1
getent hosts google.com
```

Conectividade por IP funcional com falha na consulta por nome aponta para DNS. A ausência de endereço ou rota padrão exige correção da conexão primeiro; ICMP bloqueado também impede uma conclusão baseada apenas no ping.

### 1.2 DNS no ambiente Live

As configurações do systemd-resolved do ambiente Live ficam disponíveis por:

```bash
resolvectl status
resolvectl dns INTERFACE 1.1.1.1 8.8.8.8
resolvectl domain INTERFACE '~.'
```

`INTERFACE` é o nome ativo apresentado por `ip address`, como `wlan0` ou uma interface Ethernet. Esses servidores públicos de exemplo substituem temporariamente a seleção de DNS da interface; a política da rede pode exigir outros servidores. `resolvectl revert INTERFACE` remove a substituição.

<details>
<summary>Alternativa manual de resolv.conf para arquivo regular sem gerenciamento</summary>

Quando o DNS é gerenciado deliberadamente por um arquivo regular `/etc/resolv.conf`, em vez de serviço ou link simbólico, seu conteúdo relevante pode ser:

```text
nameserver 1.1.1.1
nameserver 8.8.8.8
```

No shell root Live, a sequência abaixo preserva um backup e grava o exemplo somente quando o caminho é um arquivo regular, sem link simbólico. Ela se aplica apenas quando nenhum serviço gerencia esse arquivo:

```bash
if [ -f /etc/resolv.conf ] && [ ! -L /etc/resolv.conf ]; then
    resolver_backup=$(mktemp /root/resolv.conf.backup.XXXXXXXX)
    cp -a /etc/resolv.conf "$resolver_backup"
    printf 'nameserver 1.1.1.1\nnameserver 8.8.8.8\n' > /etc/resolv.conf
    printf '%s\n' "$resolver_backup"
fi
```

A alternativa pelo shell funciona sem instalar um editor durante uma falha de DNS. Em um sistema instalado com Neovim, `sudo nvim /etc/resolv.conf` edita o mesmo arquivo sem gerenciamento; `i`, `Esc`, `:wq` e Enter fazem a inserção e o salvamento. Um arquivo gerenciado é configurado pelo serviço responsável.

</details>

### 1.3 Conexão NetworkManager instalada

O sistema instalado utiliza NetworkManager. O nome da conexão é identificado por:

```bash
nmcli connection show --active
```

Para uma substituição deliberada do DNS IPv4, `CONNECTION` representa o nome exato da conexão ativa:

```bash
sudo nmcli connection modify "CONNECTION" ipv4.ignore-auto-dns yes ipv4.dns "1.1.1.1 8.8.8.8"
sudo nmcli connection up "CONNECTION"
```

A reativação pode interromper brevemente a conexão. Um problema de IPv6 ou política de rede exige as configurações correspondentes, sem atribuir toda falha de DNS a IPv4. A substituição é revertida por `ipv4.ignore-auto-dns no ipv4.dns ""`, seguido da reativação da conexão.

### 1.4 Verificação e retorno

```bash
getent hosts google.com
ping -c 3 google.com
```

A resolução e a conectividade funcionais permitem continuar na [rede Live](https://github.com/guihn/ArchLinux-Installation/tree/main/Portugu%C3%AAs/Instala%C3%A7%C3%A3o#14-conexão-de-rede) ou na [rede instalada](https://github.com/guihn/ArchLinux-Installation/tree/main/Portugu%C3%AAs/P%C3%B3s%20Instala%C3%A7%C3%A3o#12-conexão-pelo-networkmanager), conforme o ambiente.

## 2. Assinaturas de pacotes e keyring

### 2.1 Relógio e sintomas

Os sintomas incluem chaves desconhecidas ou assinaturas inválidas durante uma transação com conectividade funcional. O keyring do Arch identifica os signatários confiáveis dos pacotes. Erro de relógio, chaves antigas, download incompleto ou problema no espelho exigem diagnóstico antes da recriação do chaveiro.

```bash
timedatectl status
```

O relógio precisa estar correto. A [documentação de assinaturas](https://wiki.archlinux.org/title/Pacman/Package_signing), em inglês, explica cada classe de falha. A verificação de assinaturas permanece ativa; a aceitação de pacotes sem verificação não integra o procedimento.

### 2.2 Atualização das chaves conhecidas

No **shell root Live**, um keyring desatualizado pode ser atualizado antes de nova tentativa com `pacstrap`:

```bash
pacman -Sy archlinux-keyring
```

Essa recuperação específica é diferente de um `pacman -Sy` rotineiro seguido de instalações arbitrárias. No **sistema instalado**, a atualização das chaves é seguida imediatamente pela atualização completa, somente quando o primeiro comando termina com sucesso:

```bash
sudo pacman -Sy archlinux-keyring && sudo pacman -Su
```

Atualizações normais continuam utilizando `sudo pacman -Syu`. Uma imagem Live antiga com problemas de recuperação não resolvidos pode ser substituída por uma imagem atual verificada antes de nova tentativa.

### 2.3 Recriação apenas para chaveiro danificado

<details>
<summary>Backup e reconstrução do keyring</summary>

Esta alternativa se aplica a um chaveiro local danificado após as verificações de relógio, rede e atualização. Ela remove o armazenamento local de chaves e, portanto, também remove chaves importadas separadamente. O backup preserva esses registros para verificação e restauração posterior quando necessário.

A sequência funciona em um **shell root**. O shell Live já possui esse privilégio; uma conta do sistema instalado entra nele por `sudo -i`.

```bash
keyring_backup=$(mktemp -d /root/pacman-keyring-backup.XXXXXXXX)
cp -a /etc/pacman.d/gnupg "$keyring_backup/"
```

O backup bem-sucedido precede a remoção. A sequência de reconstrução é:

```bash
rm -rf /etc/pacman.d/gnupg
pacman-key --init
pacman-key --populate archlinux
pacman -Sy archlinux-keyring
```

Cada comando precisa terminar com sucesso antes do próximo. No sistema instalado, `pacman -Su` conclui a atualização antes da instalação de qualquer outro pacote; `exit` retorna do shell root temporário à conta comum. No Live, o chaveiro recuperado precede nova tentativa com `pacstrap`. Uma falha persistente de assinatura exige inspeção do erro específico, em vez de exclusões repetidas.

</details>

### 2.4 Retorno à instalação

A verificação bem-sucedida das assinaturas retorna à [instalação da base](https://github.com/guihn/ArchLinux-Installation/tree/main/Portugu%C3%AAs/Instala%C3%A7%C3%A3o#32-kernel-e-pacotes-essenciais) ou à [atualização completa](https://github.com/guihn/ArchLinux-Installation/tree/main/Portugu%C3%AAs/P%C3%B3s%20Instala%C3%A7%C3%A3o#21-seleção-de-espelhos). A recriação do chaveiro não é um pré-requisito rotineiro de nenhuma das etapas.

## 3. Bluetooth

### 3.1 Serviço e adaptador

Este procedimento se aplica à ausência de conexão ou falha de pareamento após a instalação dos pacotes Bluetooth. No sistema instalado:

```bash
sudo systemctl start bluetooth
systemctl status bluetooth
rfkill list
bluetoothctl
```

Um bloqueio de rádio por software ou hardware precisa ser resolvido no adaptador identificado. `bluetoothctl` abre um prompt interativo; os comandos abaixo funcionam nele.

### 3.2 Comandos de pareamento e conexão

`XX:XX:XX:XX:XX:XX` representa o endereço real do dispositivo Bluetooth descoberto. Ativação, agente, busca, pareamento, confiança e conexão são operações distintas.

| Comando | Finalidade |
| --- | --- |
| `power on` | Ativação do adaptador. |
| `agent on` | Ativação do agente de pareamento. |
| `default-agent` | Seleção do agente padrão. |
| `scan on` | Início da descoberta de dispositivos. |
| `scan off` | Encerramento da busca após a identificação do destino. |
| `devices` | Listagem dos dispositivos e endereços encontrados. |
| `pair XX:XX:XX:XX:XX:XX` | Pareamento com o dispositivo; pode haver confirmação. |
| `trust XX:XX:XX:XX:XX:XX` | Marcação de confiança para conexões posteriores. |
| `connect XX:XX:XX:XX:XX:XX` | Estabelecimento de conexão. |
| `disconnect XX:XX:XX:XX:XX:XX` | Encerramento da conexão. |
| `remove XX:XX:XX:XX:XX:XX` | Remoção do registro para um novo pareamento deliberado. |
| `quit` | Saída do bluetoothctl. |

### 3.3 Retorno ao procedimento principal

O resultado esperado é um adaptador ativo e uma conexão bem-sucedida ao dispositivo selecionado. Os códigos de pareamento precisam corresponder ao dispositivo pretendido. Uma falha pode exigir modo de pareamento no periférico ou inspeção por `journalctl -b -u bluetooth`. A recuperação retorna à [configuração dos serviços](https://github.com/guihn/ArchLinux-Installation/tree/main/Portugu%C3%AAs/P%C3%B3s%20Instala%C3%A7%C3%A3o#71-bluetooth-ly-e-diretórios-pessoais).

[Índice](https://github.com/guihn/ArchLinux-Installation/tree/main/Portugu%C3%AAs)
