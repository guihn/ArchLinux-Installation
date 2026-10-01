<table width="100%">
<tr>
<td align="left" width="5000"><strong>Português</strong> | <a href="https://github.com/guihn/ArchLinux-Installation/tree/main/English/Customization">English</a></td>
<td align="right" width="5000"><a href="https://github.com/guihn/ArchLinux-Installation/tree/main/Portugu%C3%AAs/Hyprland">Anterior</a> | <a href="https://github.com/guihn/ArchLinux-Installation/tree/main/Portugu%C3%AAs">Índice</a></td>
</tr>
</table>

# Personalização

Os arquivos modulares de [Hyprland](https://github.com/guihn/ArchLinux-Installation/tree/main/Portugu%C3%AAs/Hyprland) já estão implantados. Esta seção descreve configurações pessoais opcionais nessa sessão funcional. Ela não exige uma nova cópia do conjunto de arquivos.

## 1. Configuração pessoal

### 1.1 Zsh e Fastfetch

O Fastfetch apresenta informações do sistema. A preferência de referência é sua exibição automática a cada abertura de um terminal Zsh interativo:

```bash
nvim ~/.zshrc
```

A linha abaixo no final do arquivo ativa esse comportamento:

```bash
fastfetch
```

No Neovim, `i` inicia a inserção; `Esc`, `:wq` e Enter salvam e saem. Uma nova janela do foot passa a ler `.zshrc`. Uma única chamada é suficiente; linhas duplicadas repetiriam a saída. Um `#` no início da linha desativa a exibição automática. Outro shell utiliza seu arquivo interativo correspondente, como `.bashrc` para Bash.

### 1.2 Spotify, Discord e espaço magic

O `autostart.lua` do exemplo completo inicia Spotify e Discord. `windowsandworkspaces.lua` identifica suas classes de janela e atribui `special:magic`. Os dois aplicativos precisam estar instalados antes da ativação das entradas; entradas indesejadas podem permanecer comentadas. São aplicativos pessoais, não requisitos para um compositor funcional.

Com duas janelas em mosaico e o layout dwindle, o espaço as organiza em divisões. A orientação exata depende do estado do layout e da inserção; as regras atribuem um destino, sem impor uma geometria fixa de duas colunas. `SUPER + J` altera a divisão quando outra orientação é necessária.

| Atalho | Resultado |
| --- | --- |
| `SUPER + S` | Exibição/ocultação de `magic` sobre o espaço ativo. |
| `SUPER + SHIFT + S` | Movimentação da janela ativa para `special:magic`. |

O espaço especial mantém música e comunicação acessíveis independentemente dos espaços numerados. As classes podem ser verificadas por `hyprctl clients`; uma classe alterada pelo aplicativo exige correspondência na regra.

### 1.3 Aparência, monitores e atalhos

`lookandfeel.lua` contém espaçamentos, cores de borda, opacidade, sombras, desfoque, curvas de animação e layouts. Os exemplos comentados de espaçamento inteligente permanecem disponíveis. `monitors.lua`, `input.lua` e `keybinds.lua` contêm valores pessoais e específicos da máquina. Os arquivos completos e seus comentários ficam na [Configuração](https://github.com/guihn/ArchLinux-Installation/tree/main/Portugu%C3%AAs/Hyprland/Configura%C3%A7%C3%A3o).

As alterações são aplicadas ao arquivo real correspondente em `~/.config/hypr/`. `hyprctl configerrors` apresenta problemas de interpretação. Alterações de permissões e inicialização exigem nova sessão, conforme a seção Hyprland; ajustes comuns de aparência seguem o comportamento de recarga do compositor.

### 1.4 Papel de parede, barra e tema do hyprtoolkit

Hyprpaper e Waybar podem iniciar pelo callback do exemplo. Caminhos de papel de parede precisam identificar imagens existentes em um `hyprpaper.conf` válido; preferências da barra pertencem à configuração do Waybar. As documentações oficiais de [papel de parede](https://wiki.hypr.land/Hypr-Ecosystem/hyprpaper/) e [barra](https://github.com/Alexays/Waybar/wiki/Configuration), em inglês, descrevem esses formatos.

`~/.config/hypr/hyprtoolkit.conf` fornece opções visuais comuns aos aplicativos construídos com hyprtoolkit, incluindo hyprlauncher e hyprpolkitagent. Uma paleta compartilhada pode coordenar esses aplicativos. O tema monocromático pessoal é um trabalho opcional planejado; o repositório não fornece um `hyprtoolkit.conf` completo. A [referência de temas do hyprtoolkit](https://wiki.hypr.land/Hypr-Ecosystem/hyprtoolkit/), em inglês, descreve as opções disponíveis.

## 2. Alternativas de componentes

| Referência | Substituição opcional | Alterações dependentes |
| --- | --- | --- |
| foot | Outro terminal Wayland | `terminal`, comando de abertura do Yazi e opções próprias do terminal. |
| Yazi | Outro gerenciador de arquivos | `fileManager`, dependências e necessidade de um terminal envolvente. |
| Hyprlauncher | Outro iniciador | `menu`, inicialização do daemon e regras de janela/camada relacionadas. |
| Zsh | Bash ou outro shell | Shell de login e arquivos interativos. |
| Ly | Outro gerenciador de login ou iniciador de sessão | Serviços habilitados, seleção da sessão e tratamento do ambiente. |
| Linux Zen | Outro kernel compatível | Par kernel/headers, compilação DKMS, nomes de imagens e configuração do GRUB. |

São alternativas de escolha, não instalações obrigatórias adicionais. A referência continua sendo a configuração apresentada ao longo do guia.

O procedimento termina com o sistema configurado e as preferências pessoais opcionais. A [Solução de Problemas](https://github.com/guihn/ArchLinux-Installation/tree/main/Portugu%C3%AAs/Solu%C3%A7%C3%A3o%20de%20Problemas) e as [Referências](https://github.com/guihn/ArchLinux-Installation/tree/main/Portugu%C3%AAs/Refer%C3%AAncias) permanecem disponíveis para consulta posterior.

[Anterior](https://github.com/guihn/ArchLinux-Installation/tree/main/Portugu%C3%AAs/Hyprland) · [Índice](https://github.com/guihn/ArchLinux-Installation/tree/main/Portugu%C3%AAs)
