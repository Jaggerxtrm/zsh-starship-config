# 🚀 Configurazione Zsh + Starship

Setup completo e portabile per una configurazione moderna di Zsh con Starship prompt, ottimizzata per sviluppatori.

## 📸 Screenshot

Il prompt mostra:
- 🐧 Icona Fedora Linux + username
- 📁 Directory corrente (bianca)
- 🌿 Branch Git + icona GitHub + stato dettagliato
- 🐍 Python + virtual environment (quando rilevato)
- ⚡ Durata comando (se > 2s)

Esempio:
```
 dawid ~/projects/my-repo  main  venv
⮕
```

## ✨ Caratteristiche

### Prompt (Starship)
- **Tema**: Green Theme + Tokyo Night
- **Colori**: Testo bianco per username e directory, palette verde coerente per il prompt
- **Git**: Icone dettagliate per ogni stato (modified, staged, untracked, ahead, behind, conflicts, etc.)
- **Linguaggi**: Rileva automaticamente Python, Node.js, Rust, Go, PHP, Java
- **Performance**: Timeout 500ms, prompt veloce e reattivo

### Zsh (Oh My Zsh)
- **Plugin attivi**:
  - `git` - Alias e funzioni per Git
  - `zsh-autosuggestions` - Suggerimenti mentre digiti
  - `zsh-syntax-highlighting` - Evidenziazione sintassi comandi (Tema Verde)
  - `zsh-history-substring-search` - Ricerca nell'history
  - `colored-man-pages` - Pagine man colorate
  - `command-not-found` - Suggerimenti per comandi non trovati

### Strumenti Moderni (opzionali)
- **eza** - `ls` moderno con icone (installato automaticamente)
- **bat** - `cat` con syntax highlighting
- **ripgrep** - `grep` velocissimo
- **fd** - `find` user-friendly
- **zoxide** - `cd` intelligente con memoria
- **fzf** - Fuzzy finder interattivo

**Alias intelligenti:**
- `lt` - tree che esclude venv, node_modules, .git
- `lta` - tree completo senza esclusioni

## 📋 Requisiti

- Sistema operativo: Fedora, RHEL, Ubuntu, Debian
- Git installato
- Accesso sudo (per installare pacchetti)
- Terminale con supporto colori 256

## 🪟 Supporto WSL2 (Windows)

Se usi WSL (Windows Subsystem for Linux), lo script rileverà automaticamente l'ambiente.

### 🎉 Installazione automatica font (NUOVO!)

Lo script ora **installa automaticamente i font su Windows** tramite PowerShell:

1. ✅ Copia i font in `C:\Users\TuoNome\Downloads\NerdFonts_Zsh_Setup`
2. ✅ **Esegue PowerShell per installarli** (no manual install richiesto!)
3. ✅ Registra i font nel Registry di Windows
4. ⚙️ Devi solo configurare Windows Terminal:
   - Impostazioni → Profili → Ubuntu (o la tua distro) → Aspetto
   - Tipo di carattere: **MesloLGS NF**
   - Riavvia Windows Terminal

### Fallback manuale (se PowerShell fallisce)

Se l'installazione automatica fallisce:
1. Lo script copierà comunque i font in **Download** (`NerdFonts_Zsh_Setup`)
2. Apri quella cartella su Windows
3. Seleziona tutti i file .ttf
4. **Tasto Destro** → **Installa**

## 🚀 Installazione Rapida

### Installazione Automatica

```bash
cd ~/projects/zsh-starship-config
chmod +x install.sh
./install.sh
```

### 🔄 Aggiornamento (Update)

Se hai già installato una versione precedente:

```bash
cd ~/projects/zsh-starship-config
git pull
./install.sh --update
# Oppure usa il wrapper:
./update.sh
```

**Novità modalità update:**
- ✅ Aggiorna Starship, eza e altri componenti
- ✅ **NON sovrascrive** il tuo `.zshrc` (merge intelligente)
- ✅ Backup automatico di tutte le configurazioni
- ✅ (WSL) Installazione automatica font su Windows
- ✅ Verifica post-installazione

📖 Vedi [UPGRADE.md](UPGRADE.md) per la guida completa all'aggiornamento.

### Opzioni disponibili

```bash
./install.sh           # Installazione normale
./install.sh --update  # Modalità update (aggiorna componenti esistenti)
./install.sh --verbose # Output dettagliato
./install.sh --help    # Mostra tutte le opzioni
```

## 📦 Cosa viene installato

Lo script installerà automaticamente:
1. ✅ Zsh
2. ✅ Oh My Zsh
3. ✅ Plugin Zsh (autosuggestions, syntax-highlighting, etc.)
4. ✅ Starship
5. ✅ Nerd Fonts (Meslo, JetBrains, Hack, FiraMono, Cousine)
6. ✅ eza (modern ls con icone)
7. ✅ jq (JSON parser per Claude Code)
8. ✅ Configurazione custom
9. 🔗 **Claude Code Status Line Enhanced** (model + usage% + git + venv)
10. ⚙️ Strumenti moderni extra (opzionale)

### Installazione Manuale

Se preferisci installare manualmente:

#### 1. Installa Zsh
```bash
# Fedora
sudo dnf install zsh

# Ubuntu/Debian
sudo apt install zsh
```

#### 2. Installa Oh My Zsh
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

#### 3. Installa Plugin Zsh
```bash
# zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# zsh-history-substring-search
git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
```

#### 4. Installa Starship
```bash
curl -sS https://starship.rs/install.sh | sh
```

#### 5. Installa Nerd Fonts

**MesloLGS NF** (raccomandato):
```bash
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
fc-cache -fv
```

**JetBrainsMono Nerd Font** (alternativa):
```bash
cd /tmp
wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz
mkdir -p ~/.local/share/fonts/JetBrainsMonoNerdFont
tar -xf JetBrainsMono.tar.xz -C ~/.local/share/fonts/JetBrainsMonoNerdFont
fc-cache -fv
```

**Altri Nerd Fonts Inclusi (Hack, FiraMono, Cousine):**
Puoi installarli in modo simile scaricando `Hack.tar.xz`, `FiraMono.tar.xz` o `Cousine.tar.xz` da [nerd-fonts releases](https://github.com/ryanoasis/nerd-fonts/releases).

#### 6. Applica Configurazione
```bash
# Copia starship config
cp starship.toml ~/.config/starship.toml

# Modifica .zshrc per abilitare Starship
echo 'eval "$(starship init zsh)"' >> ~/.zshrc
```

#### 7. Configura Terminale
Nelle impostazioni del terminale, seleziona il font:
- **MesloLGS NF** (raccomandato)
- Oppure **JetBrainsMono Nerd Font**
- Dimensione: 11 o 12

#### 8. Riavvia Terminale
```bash
source ~/.zshrc
# Oppure chiudi e riapri il terminale
```

## 🔗 Integrazione Claude Code Status Line

Claude Code può usare lo **stesso tema Starship** per la sua status line, con **funzionalità avanzate**!

### Configurazione Automatica

Lo script `install.sh` configura automaticamente la status line di Claude Code. La configurazione viene installata in:
- **Script**: `~/.claude/hooks/statusline-starship.sh`
- **Config**: `~/.claude/settings.json`

### Cosa Mostra (Enhanced Version)

La status line Claude Code mostra **tutte queste informazioni in tempo reale**:

| Elemento | Descrizione | Esempio |
|----------|-------------|---------|
| 🤖 **Model** | Modello Claude attualmente in uso | `Claude 3.5 Sonnet` |
| 📊 **Usage** | Percentuale di contesto utilizzato | `[15%]` |
| 👤 **User@Host** | Username e hostname | `dawid@fedora` |
| 📁 **Directory** | Path corrente (truncato a repo root) | `second-mind` |
| 🌿 **Git Branch** | Branch Git con icona | ` master` |
| ✏️ **Git Status** | Modifiche non committate | `` (se dirty) |
| 🐍 **Python Venv** | Virtual environment attivo | ` (venv)` |

**Esempio Output Completo:**
```
Claude 3.5 Sonnet [15%] dawid@fedora second-mind  master
```

### Caratteristiche Avanzate

#### 1. **Token Usage in Tempo Reale**
- Mostra la percentuale di contesto utilizzato `[X%]`
- Si aggiorna dinamicamente durante la conversazione
- **Diminuisce automaticamente dopo compaction** del contesto

#### 2. **Model Display**
- Mostra il modello Claude attualmente in uso (cyan)
- Utile quando si cambia tra modelli (Sonnet, Opus, Haiku)

#### 3. **Git Intelligence**
- Directory truncata al repository root (come Starship)
- Rileva automaticamente modifiche con `core.useBuiltinFSMonitor=false` per evitare lock
- Icone Nerd Font renderizzate correttamente

#### 4. **Colori Starship-Matched**
- **Model/Usage**: Cyan (`\033[36m`) - distintivo
- **Username**: White (`\033[37m`)
- **Hostname**: Bold Green (`\033[1;32m`)
- **Directory**: White (`\033[37m`)
- **Git**: Green (`\033[32m`)
- **Python Venv**: Yellow (`\033[33m`)

### Configurazione Manuale (se necessario)

Se vuoi installare manualmente o personalizzare:

```bash
# Copia lo script dal repository
cp data/claude-statusline-starship.sh ~/.claude/hooks/statusline-starship.sh
chmod +x ~/.claude/hooks/statusline-starship.sh

# Configura Claude Code (preserva altre impostazioni)
jq '. + {"statusLine": {"command": "~/.claude/hooks/statusline-starship.sh"}}' \
    ~/.claude/settings.json > ~/.claude/settings.json.tmp && \
    mv ~/.claude/settings.json.tmp ~/.claude/settings.json
```

### Requisiti
- ✅ `jq` per parsing JSON (installato automaticamente)
- ✅ Nerd Font installato (già configurato per Starship)
- ✅ Git (per funzionalità repository)

### File Sorgente

Lo script completo è disponibile in `data/claude-statusline-starship.sh` nel repository.

## 🎨 Personalizzazione

### Colori Prompt

I colori sono definiti in `starship.toml`:

```toml
# Username e Directory
style = "white"  # Testo bianco

# Git branch
style = "#bb9af7"  # Viola Tokyo Night

# Git status (errori/modifiche)
style = "#f7768e"  # Rosso Tokyo Night

# Python/Linguaggi
style = "#e0af68"  # Giallo Tokyo Night

# Prompt character (Ocean Blue)
success_symbol = "[⮕](#61afef)"  # Blu chiaro
error_symbol = "[⮕](#e06c75)"    # Rosso soft
```

### Syntax Highlighting (Ocean Blue)

I colori della sintassi mentre digiti sono configurati con palette Ocean Blue:

```bash
ZSH_HIGHLIGHT_STYLES[command]='fg=#61afef'        # Comandi: blu chiaro
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#e06c75'  # Errori: rosso soft
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#56b6c2'        # Built-in: cyan
ZSH_HIGHLIGHT_STYLES[alias]='fg=#528bff'          # Alias: blu elettrico
ZSH_HIGHLIGHT_STYLES[path]='fg=#89b4fa'           # Path: azzurro
```

### Icone Nerd Font

Le icone usate sono codici Unicode Nerd Font:

| Elemento | Icona | Codice |
|----------|-------|--------|
| Linux (Fedora) | 🐧 | `\uf303` |
| Git Branch | 🌿 | `\ue0a0` |
| GitHub | 🐙 | `\uf1d3` |
| Python | 🐍 | `\ue73c` |
| Modified | ✏️ | `\uf040` |
| Staged | ✅ | `\uf00c` |
| Untracked | ❓ | `\uf128` |

Per modificare le icone, modifica `starship.toml` e cambia i codici `\uf...` o `\ue...`.

### Aggiungere Altri Linguaggi

Esempio per aggiungere Ruby:

```toml
[ruby]
symbol = " "
format = "[$symbol]($style)[($version )]($style)"
style = "#e06c75"
```

Poi aggiungi `$ruby` alla stringa `format` in cima al file.

## 🔧 Configurazione Avanzata

### Disabilitare Username

```toml
[username]
disabled = true  # Cambia a true
```

### Mostrare Sempre la Versione Python

```toml
[python]
format = "[$symbol($version )]($style)[($virtualenv )]($style)"
```

### Cambiare Icona Linux

La configurazione usa Tux generico (\uf17c). Puoi cambiarla:

```toml
# Tux generico (default)
format = "\uf17c [$user]($style) "

# Logo Fedora
format = "\uf303 [$user]($style) "

# Logo Ubuntu
format = "\uf31b [$user]($style) "
```

### Aggiungere Orario

```toml
[time]
disabled = false
format = "[$time]($style) "
style = "#7dcfff"
```

E aggiungi `$time` al format principale.

## 📖 Documentazione Icone Git

| Stato | Icona | Significato |
|-------|-------|-------------|
| \uf040 | ✏️ | File modificati (non staged) |
| \uf00c | ✅ | File staged pronti per commit |
| \uf128 | ❓ | File non tracciati (untracked) |
| \uf05e | 🗑️ | File cancellati |
| \uf02b | 📝 | File rinominati |
| \uf0aa | ⬆️ | Commit ahead (da pushare) |
| \uf0ab | ⬇️ | Commit behind (da pullare) |
| \uf0ec | ⚠️ | Branch divergenti o conflitti |
| \uf448 | 📦 | Modifiche in stash |

## 🛠️ Troubleshooting

### Le icone appaiono come quadratini vuoti

**Problema**: Il terminale non usa un Nerd Font.

**Soluzione**:
1. Verifica che il font sia installato: `fc-list | grep "MesloLGS\|JetBrainsMono Nerd"`
2. Nelle preferenze del terminale, seleziona "MesloLGS NF" o "JetBrainsMono Nerd Font"
3. Chiudi COMPLETAMENTE il terminale e riaprilo
4. Testa con: `echo "\uf1d3 \ue0a0 \ue73c"`

### Starship non si avvia

**Problema**: `command not found: starship`

**Soluzione**:
```bash
# Verifica installazione
which starship

# Se non trovato, reinstalla
curl -sS https://starship.rs/install.sh | sh

# Verifica PATH
echo $PATH | grep ".local/bin"

# Aggiungi a .zshrc se manca
export PATH="$HOME/.local/bin:$PATH"
```

### Plugin Zsh non funzionano

**Problema**: Autosuggestions o syntax highlighting non attivi.

**Soluzione**:
```bash
# Verifica installazione plugin
ls ~/.oh-my-zsh/custom/plugins/

# Verifica .zshrc
grep "plugins=" ~/.zshrc

# Deve contenere:
plugins=(git zsh-autosuggestions zsh-syntax-highlighting ...)
```

### Python/linguaggi non rilevati

**Problema**: L'icona Python non appare.

**Soluzione**:
- Assicurati di essere in una directory con file `.py`, `requirements.txt`, o `pyproject.toml`
- Oppure attiva un virtual environment
- Verifica con: `starship module python`

## 📚 Risorse

- [Starship Documentation](https://starship.rs/config/)
- [Nerd Fonts](https://www.nerdfonts.com/)
- [Oh My Zsh](https://ohmyz.sh/)
- [Nerd Fonts Cheat Sheet](https://www.nerdfonts.com/cheat-sheet) - Cerca icone

## 🤝 Contributi

Hai miglioramenti o suggerimenti? Sentiti libero di modificare la configurazione!

## 📄 Licenza

Configurazione libera e open source. Usa e modifica come preferisci!

---

**Creato con ❤️ per uno sviluppo più produttivo e piacevole**
