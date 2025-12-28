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
❯
```

## ✨ Caratteristiche

### Prompt (Starship)
- **Tema**: Tokyo Night (modificato)
- **Colori**: Testo bianco per username e directory, colori custom per git e linguaggi
- **Git**: Icone dettagliate per ogni stato (modified, staged, untracked, ahead, behind, conflicts, etc.)
- **Linguaggi**: Rileva automaticamente Python, Node.js, Rust, Go, PHP, Java
- **Performance**: Timeout 500ms, prompt veloce e reattivo

### Zsh (Oh My Zsh)
- **Plugin attivi**:
  - `git` - Alias e funzioni per Git
  - `zsh-autosuggestions` - Suggerimenti mentre digiti
  - `zsh-syntax-highlighting` - Evidenziazione sintassi comandi
  - `zsh-history-substring-search` - Ricerca nell'history
  - `colored-man-pages` - Pagine man colorate
  - `command-not-found` - Suggerimenti per comandi non trovati

### Strumenti Moderni (opzionali)
- **eza** - `ls` moderno con icone
- **bat** - `cat` con syntax highlighting
- **ripgrep** - `grep` velocissimo
- **fd** - `find` user-friendly
- **zoxide** - `cd` intelligente con memoria
- **fzf** - Fuzzy finder interattivo

## 📋 Requisiti

- Sistema operativo: Fedora, RHEL, Ubuntu, Debian
- Git installato
- Accesso sudo (per installare pacchetti)
- Terminale con supporto colori 256

## 🚀 Installazione Rapida

### Installazione Automatica

```bash
cd ~/projects/zsh-starship-config
chmod +x install.sh
./install.sh
```

Lo script installerà automaticamente:
1. ✅ Zsh
2. ✅ Oh My Zsh
3. ✅ Plugin Zsh (autosuggestions, syntax-highlighting, etc.)
4. ✅ Starship
5. ✅ Nerd Fonts (MesloLGS NF + JetBrainsMono)
6. ✅ Configurazione custom
7. ⚙️ Strumenti moderni (opzionale)

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

# Prompt character
success_symbol = "[❯](#9ece6a)"  # Verde
error_symbol = "[❯](#f7768e)"    # Rosso
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
