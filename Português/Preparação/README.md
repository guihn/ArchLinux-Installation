<table width="100%">
<tr>
<td align="left" width="5000"><strong>Português</strong> | <a href="https://github.com/guihn/ArchLinux-Installation/tree/main/English/Preparation">English</a></td>
<td align="right" width="5000"><a href="https://github.com/guihn/ArchLinux-Installation/tree/main/Portugu%C3%AAs">Índice</a> | <a href="https://github.com/guihn/ArchLinux-Installation/tree/main/Portugu%C3%AAs/Instala%C3%A7%C3%A3o">Próximo</a></td>
</tr>
</table>

# Preparação

Esta seção prepara um instalador USB e o modo de inicialização do firmware. O ponto de partida é um computador funcional com acesso à Internet; o resultado é o terminal Live do Arch Linux. O ambiente Live funciona pela mídia de instalação e é separado do sistema que será instalado no disco.

## 1. Mídia de instalação

### 1.1 Backups e seleção do dispositivo

A instalação do Ventoy reparticiona o pendrive selecionado e apaga seus dados existentes. Um backup em outro dispositivo é necessário antes dessa operação. O disco de instalação também precisa de backup separado antes de qualquer particionamento ou formatação na próxima seção. Capacidade, modelo e identificação distinguem o pendrive do SSD interno.

### 1.2 ISO do Arch Linux

A [página de downloads do Arch Linux](https://archlinux.org/download/) apresenta a imagem atual e os métodos de download. A lista de espelhos HTTP está organizada por país. O Brasil é a localização de referência; outro país próximo e adequado é uma alternativa. O servidor selecionado abre um diretório com o arquivo atual `archlinux-…-x86_64.iso`, sua assinatura e as informações de checksum. O arquivo `.iso` contém o ambiente de instalação e é baixado inteiro, sem extração.

A versão e o nome do arquivo vêm da página atual de downloads. A versão sincronizada no espelho e o checksum precisam corresponder ao mesmo arquivo.

### 1.3 Verificação do download

A página oficial fornece as informações de verificação. No Linux, `sha256sum` apresenta o checksum SHA-256 da ISO baixada; a comparação com o valor publicado correspondente verifica a integridade do arquivo. `ARCH_ISO.iso`, abaixo, representa o nome real do arquivo baixado.

```bash
sha256sum ARCH_ISO.iso
```

No Windows, o comando equivalente do PowerShell é:

```powershell
Get-FileHash .\ARCH_ISO.iso -Algorithm SHA256
```

Um hash correspondente verifica a concordância com o checksum publicado. A verificação de assinatura também autentica a versão quando a chave de assinatura foi verificada, conforme as instruções oficiais de download.

### 1.4 Instalação do Ventoy

A [página de downloads do Ventoy](https://www.ventoy.net/en/download.html) fornece versões para Windows e Linux e seus checksums. O arquivo compactado é extraído antes da abertura do programa correspondente. O Ventoy prepara o pendrive uma vez; depois, as ISOs podem ser copiadas para a partição de dados.

No Windows, `Ventoy2Disk.exe` abre o instalador. O campo **Device** identifica o pendrive por capacidade e modelo. **Install** grava o Ventoy após as confirmações de perda dos dados. No Linux, `VentoyGUI.x86_64` oferece a interface gráfica; a alternativa de linha de comando abaixo funciona no diretório extraído do Ventoy, com privilégios administrativos:

```bash
sudo sh Ventoy2Disk.sh -i /dev/sdX
```

`/dev/sdX` representa o pendrive inteiro identificado, nunca uma partição individual ou o disco interno de instalação. `lsblk -o NAME,SIZE,MODEL,TRAN,MOUNTPOINTS` auxilia sua identificação. `-i` realiza uma instalação e recusa uma instalação existente do Ventoy; as atualizações usam a operação específica documentada.

A tabela de partições do pendrive do Ventoy é uma configuração separada do particionamento do disco do sistema instalado. Sua adequação depende do modo de inicialização suportado pelo firmware. As [instruções iniciais do Ventoy](https://www.ventoy.net/en/doc_start.html), em inglês, explicam as opções da mídia; o procedimento escrito nesta seção cobre sua preparação.

### 1.5 Transferência da ISO

Após a instalação bem-sucedida do Ventoy, sua partição grande de dados aparece como um volume removível comum. A ISO completa do Arch é copiada para esse volume como arquivo. A remoção segura após o término da cópia garante a conclusão das gravações pendentes. Na inicialização, o Ventoy apresenta a ISO e abre o menu do Arch após sua seleção.

## 2. Firmware e seleção de inicialização

### 2.1 Acesso ao firmware

A configuração do firmware e o menu temporário de inicialização são acessados pelos atalhos documentados pelo fabricante do computador ou da placa-mãe. Teclas como Delete, F2 ou F8 são apenas exemplos; o manual do modelo fornece a tecla correta. O mesmo vale para os nomes dos menus, o salvamento das alterações e a saída. Uma configuração do firmware pode mudar a ordem de inicialização permanentemente; o menu temporário seleciona o pendrive para uma única inicialização.

### 2.2 UEFI e BIOS/Legacy

A referência principal usa UEFI com GPT. Uma entrada USB identificada como UEFI inicia essa rota. BIOS/Legacy é uma alternativa somente quando a máquina oferece firmware compatível ou um módulo de compatibilidade (CSM) e consegue inicializar pelo disco selecionado. A inicialização Legacy por NVMe depende do suporte do firmware; o reconhecimento do disco após a entrada no Linux não comprova esse suporte.

A mídia original do Arch não fornece uma instalação com Secure Boot configurada automaticamente. O procedimento de referência utiliza Secure Boot desativado nas configurações específicas do firmware. Uma instalação assinada com Secure Boot exige o procedimento separado da [documentação do Arch](https://wiki.archlinux.org/title/Unified_Extensible_Firmware_Interface/Secure_Boot), em inglês.

O guia usa GPT nas duas rotas. GPT e MBR são tabelas de partições; FAT32 e ext4 são sistemas de arquivos. A escolha da tabela fica a cargo de quem realiza a instalação, conforme firmware, disco e outros sistemas operacionais. A seção de instalação também explica a alternativa BIOS/MBR e sua numeração diferente de partições.

### 2.3 Inicialização do Arch Live

Após a seleção do pendrive, o Ventoy abre a ISO escolhida e sua entrada de instalação. O shell de root resultante é um interpretador de comandos com privilégios administrativos no ambiente temporário. A próxima seção verifica o modo de inicialização real antes de qualquer formatação.

O instalador está em execução. A [Instalação](https://github.com/guihn/ArchLinux-Installation/tree/main/Portugu%C3%AAs/Instala%C3%A7%C3%A3o) continua com teclado, rede, armazenamento e sistema base.

[Índice](https://github.com/guihn/ArchLinux-Installation/tree/main/Portugu%C3%AAs) · [Próximo](https://github.com/guihn/ArchLinux-Installation/tree/main/Portugu%C3%AAs/Instala%C3%A7%C3%A3o)
