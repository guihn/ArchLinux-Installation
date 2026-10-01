<table width="100%">
<tr>
<td align="left" width="5000"><strong>Português</strong> | <a href="https://github.com/guihn/ArchLinux-Installation/tree/main/English/Hyprland">English</a></td>
<td align="right" width="5000"><a href="https://github.com/guihn/ArchLinux-Installation/tree/main/Portugu%C3%AAs/P%C3%B3s%20Instala%C3%A7%C3%A3o">Anterior</a> | <a href="https://github.com/guihn/ArchLinux-Installation/tree/main/Portugu%C3%AAs">Índice</a> | <a href="https://github.com/guihn/ArchLinux-Installation/tree/main/Portugu%C3%AAs/Personaliza%C3%A7%C3%A3o">Próximo</a></td>
</tr>
</table>

# Hyprland

Os pacotes e as imagens de inicialização da [Pós Instalação](https://github.com/guihn/ArchLinux-Installation/tree/main/Portugu%C3%AAs/P%C3%B3s%20Instala%C3%A7%C3%A3o) estão prontos. Esta seção funciona na sessão gráfica da conta comum ou em seu console de recuperação. Ela explica o conjunto completo de configurações, a adaptação antes da ativação e o comportamento esperado da sessão.

## 1. Modelo de configuração

### 1.1 Entrada Lua e módulos

A configuração fornecida utiliza a API Lua do Hyprland, introduzida na transição de configuração da versão 0.55. `hyprctl version` identifica a versão em execução; a [documentação oficial correspondente](https://wiki.hypr.land/Configuring/Start/), em inglês, determina a compatibilidade da API. Um exemplo antigo de `hyprland.conf` não é intercambiável com esses arquivos Lua.

`~/.config/hypr/hyprland.lua` é o ponto de entrada. Suas importações carregam monitores, programas, inicialização, variáveis de ambiente, permissões, aparência, opções diversas, entrada, atalhos e regras de janelas/espaços de trabalho, nessa ordem. `programs.lua` define os comandos utilizados pelos atalhos. `autostart.lua` e `windowsandworkspaces.lua` gerenciam juntos a inicialização e o posicionamento de aplicativos pessoais. `hypridle.conf` é lido pelo processo separado do hypridle, não por `require` do Lua.

### 1.2 Arquivos completos e documentação

A [Configuração](https://github.com/guihn/ArchLinux-Installation/tree/main/Portugu%C3%AAs/Hyprland/Configura%C3%A7%C3%A3o) contém os doze arquivos reais, conteúdo expansível completo e links individuais para abertura/download. Todos os arquivos ficam diretamente em `~/.config/hypr/`. Suas dependências são instaladas na Pós Instalação. Os exemplos preservam alternativas comentadas, que permanecem inativas até sua ativação explícita.

## 2. Backup, adaptação e implantação

### 2.1 Backup da configuração existente

Os comandos abaixo criam um backup com nome único quando já existe um diretório de configuração. Eles funcionam pela conta comum:

```bash
if [ -d "$HOME/.config/hypr" ]; then
    backup_dir=$(mktemp -d "$HOME/hypr-backup.XXXXXXXX")
    cp -a "$HOME/.config/hypr/." "$backup_dir/"
    printf '%s\n' "$backup_dir"
fi
```

O diretório apresentado contém os arquivos anteriores. Antes da cópia do exemplo, nomes dos monitores, layout do teclado, atalhos e inicializações opcionais são revisados na cópia baixada. Uma configuração personalizada existente pode receber as edições correspondentes manualmente.

### 2.2 Obtenção do conjunto completo

```bash
mkdir -p ~/GitClones
cd ~/GitClones
git clone https://github.com/guihn/ArchLinux-Installation.git
cd ArchLinux-Installation
```

Um clone existente utiliza seu próprio diretório após a verificação de alterações locais. Os downloads individuais da Configuração são uma alternativa; todos os módulos importados precisam estar presentes juntos.

### 2.3 Valores da máquina e opções pessoais

`hyprctl monitors all` lista os nomes das saídas e os modos disponíveis. Na referência, `HDMI-A-1` é uma saída de 2560×1080 a 74,99 Hz, rotacionada e posicionada em `-1080x0`; `HDMI-A-2` usa 1920×1080 a 120 Hz em `0x0`. Esses valores descrevem conexões e orientação da referência, não identificadores universais. Outro monitor utiliza seu nome informado, modo compatível, escala e posição. `preferred` e `auto` oferecem alternativas adequadas de modo e posição quando aplicáveis.

`input.lua` utiliza `br` com a variante `abnt2`. Outro teclado utiliza seu layout/variante XKB correspondente; essa configuração gráfica é separada do mapa de console `br-abnt2`. `hyprctl devices` fornece os nomes para ajustes opcionais por dispositivo. `epic-mouse-v1` é um nome ilustrativo, não uma identificação de mouse conectado. Seu exemplo não produz efeito sem um dispositivo correspondente.

**Configuração pessoal:** o exemplo completo de autostart inicia Spotify e Discord e utiliza as regras de `special:magic`. Suas linhas de inicialização permanecem opcionais. Antes da implantação, uma linha indesejada pode ficar comentada com `--` do Lua, ou o aplicativo correspondente precisa estar instalado. Hyprpaper e Waybar também são escolhas opcionais de inicialização. O Hypridle inicia no mesmo callback para fornecer a inatividade configurada; um segundo método de inicialização é desnecessário.

Bordas brancas, espaçamentos, sombras, desfoque, opacidade, curvas de animação, orientação dos monitores, tamanhos de cursor e atalhos pessoais são exemplos. A [Personalização](https://github.com/guihn/ArchLinux-Installation/tree/main/Portugu%C3%AAs/Personaliza%C3%A7%C3%A3o) explica seu papel opcional sem repetir a implantação dos arquivos.

### 2.4 Posicionamento dos arquivos

Após a adaptação, a partir da raiz do repositório:

```bash
mkdir -p ~/.config/hypr
cp -a Português/Hyprland/Configuração/*.lua ~/.config/hypr/
cp -a Português/Hyprland/Configuração/hypridle.conf ~/.config/hypr/
```

Esses comandos substituem arquivos de mesmo nome no destino; o backup vem antes deles. Outros arquivos, como uma configuração pessoal de papel de parede, permanecem disponíveis. O comportamento técnico é idêntico nos dois idiomas; os comentários acompanham o idioma da documentação selecionada.

## 3. Comportamento e verificação da sessão

### 3.1 Programas e atalhos

| Atalho | Comportamento |
| --- | --- |
| `SUPER + Q` | Terminal foot. |
| `SUPER + E` | Yazi dentro de `foot -e yazi`. |
| `SUPER + R` | Hyprlauncher. |
| `SUPER + C` | Fechamento da janela ativa. |
| `SUPER + V` | Alternância do estado flutuante da janela ativa. |
| `SUPER + P` | Pseudotiling. |
| `SUPER + J` | Alternância da divisão do dwindle. |
| `SUPER + M` | Saída da sessão pelo hyprshutdown quando disponível, ou pelo dispatcher de saída. |
| `Print` | Captura de região pelo hyprshot. |
| `SUPER + SHIFT + V` | Histórico da área de transferência por cliphist e wofi. |
| `SUPER + setas` | Mudança direcional de foco. |
| `SUPER + 1…9 / 0` | Espaços de trabalho 1…10. |
| `SUPER + SHIFT + 1…9 / 0` | Movimentação da janela ativa para os espaços 1…10. |
| `SUPER + S` | Alternância do espaço especial `magic`. |
| `SUPER + SHIFT + S` | Movimentação da janela ativa para `special:magic`. |
| `SUPER + roda do mouse` | Espaço existente anterior/próximo. |
| `SUPER + arraste esquerdo/direito` | Movimentação/redimensionamento de janela. |
| Teclas de áudio e microfone | Volume e mudo pelo `wpctl`. |
| Teclas de brilho | Controle de iluminação compatível pelo `brightnessctl`. |
| Teclas de mídia | Reprodução e faixas pelo `playerctl`. |

`SUPER` é o modificador normalmente identificado pela tecla Windows/logotipo. As teclas físicas disponíveis e o mapa escolhido determinam os eventos reais de entrada.

### 3.2 Inatividade e retorno por entrada

O listener do Hypridle aguarda 60 segundos sem atividade relevante e depois dispara o desligamento dos monitores. `on-resume` dispara sua religação quando a atividade retorna, incluindo teclado ou ponteiro reconhecidos pela sessão. Aplicativos podem inibir o tratamento de inatividade conforme a política configurada. Não há tela de bloqueio nem suspensão automática configuradas.

Os três campos de comandos de bloqueio/suspensão não utilizados ficam vazios, em vez de conter um comando de shell chamado `none`. A sintaxe dos dispatchers acompanha a API Lua do compositor. A recuperação por um terminal da sessão ativa também é possível com:

```bash
hyprctl dispatch 'hl.dsp.dpms({ action = "enable" })'
```

### 3.3 Reinicialização e diagnóstico

Callbacks de autostart e alterações de permissões exigem nova sessão. Após a preparação dos arquivos:

```bash
reboot
```

A seleção manual no GRUB e o login pelo Ly retornam ao Hyprland. Os diagnósticos da sessão incluem:

```bash
hyprctl version
hyprctl configerrors
hyprctl monitors all
hyprctl devices
systemctl --user status hyprpolkitagent
pgrep -a hypridle
```

O resultado esperado é ausência de erros de configuração, saídas corretas dos monitores e um único processo hypridle. Um erro de sintaxe é resolvido antes da utilização dos atalhos afetados. Um console acessado pelo atalho TTY correspondente permite restaurar o backup quando a sessão gráfica está inutilizável. Falhas de inicialização do driver são verificadas por `dkms status`, saída de geração das imagens e kernel selecionado, conforme a Pós Instalação.

A sessão configurada está pronta para a [Personalização](https://github.com/guihn/ArchLinux-Installation/tree/main/Portugu%C3%AAs/Personaliza%C3%A7%C3%A3o) opcional.

[Anterior](https://github.com/guihn/ArchLinux-Installation/tree/main/Portugu%C3%AAs/P%C3%B3s%20Instala%C3%A7%C3%A3o) · [Índice](https://github.com/guihn/ArchLinux-Installation/tree/main/Portugu%C3%AAs) · [Próximo](https://github.com/guihn/ArchLinux-Installation/tree/main/Portugu%C3%AAs/Personaliza%C3%A7%C3%A3o)
