# 🚀 Quick Start - 5 Minuti

## Installazione Automatica

```bash
cd ~/projects/zsh-starship-config
./install.sh
```

Lo script ti guiderà attraverso l'installazione completa.

## Dopo l'Installazione

### 1. Configura il Font del Terminale

**GNOME Console / GNOME Terminal:**
1. Apri Preferenze (☰ menu)
2. Sezione "Carattere" o "Font"
3. Disabilita "Usa carattere di sistema"
4. Seleziona: **MesloLGS NF** (raccomandato)
5. Dimensione: **11** o **12**

**Konsole (KDE):**
1. Settings → Edit Current Profile
2. Appearance → Font
3. Seleziona: **MesloLGS NF**
4. Apply

**Alacritty:**
```yaml
# ~/.config/alacritty/alacritty.yml
font:
  normal:
    family: MesloLGS NF
  size: 11.0
```

**Kitty:**
```ini
# ~/.config/kitty/kitty.conf
font_family MesloLGS NF
font_size 11.0
```

### 2. Riavvia il Terminale

```bash
# Chiudi completamente e riapri
# Oppure
source ~/.zshrc
```

### 3. Test Icone

```bash
echo "\uf1d3 \ue0a0 \ue73c \uf303"
```

Dovresti vedere: 🐙 🌿 🐍 🐧

### 4. Test Syntax Highlighting

Digita un comando (senza premere invio):
```bash
ls -la
```

Dovresti vedere `ls` in **blu chiaro** e `-la` in **azzurro**. Se digiti un comando inesistente, apparirà in **rosso**.

## Test Completo

```bash
# Vai in una repo git
cd ~/projects/qualche-repo

# Dovresti vedere:
#  dawid ~/projects/qualche-repo  main
# >

# Fai modifiche per testare git status
touch test.txt
# Dovresti vedere:  (file untracked)

# In progetto Python con venv
cd ~/projects/python-project
source venv/bin/activate
# Dovresti vedere:  (venv)
```

## Personalizzazione Veloce

### Cambiare Colori

Modifica `~/.config/starship.toml`:

```toml
# Username rosso invece di bianco
[username]
style_user = "red"

# Directory verde
[directory]
style = "green"
```

Poi:
```bash
source ~/.zshrc
```

### Rimuovere Username

```toml
[username]
disabled = true
```

### Aggiungere Docker

```toml
[docker_context]
symbol = " "
format = "via [$symbol$context]($style) "
```

E aggiungi `$docker_context` al format principale.

## Problemi Comuni

### ❌ Icone non visibili
→ Seleziona "MesloLGS NF" nel terminale e riavvia

### ❌ Starship non trovato
→ `export PATH="$HOME/.local/bin:$PATH"` in .zshrc

### ❌ Plugin Zsh non funzionano
→ Verifica che siano in `~/.oh-my-zsh/custom/plugins/`

## Comandi Utili

```bash
# Mostra configurazione Starship attuale
starship config

# Test modulo specifico
starship module git_branch
starship module python

# Info versione
starship --version
eza --version

# Lista font installati
fc-list | grep Nerd

# Alias disponibili
ls    # lista con icone
ll    # lista dettagliata
la    # lista con file nascosti
lt    # tree (esclude venv, node_modules)
lta   # tree completo
```

## Prossimi Passi

- 📖 Leggi [README.md](README.md) per personalizzazione avanzata
- 🎨 Esplora [Starship Config](https://starship.rs/config/)
- 🔤 Cerca icone su [Nerd Fonts Cheat Sheet](https://www.nerdfonts.com/cheat-sheet)

---

**Tutto pronto! Buon coding! 🎉**
