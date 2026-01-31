# Changelog

## v1.7.0 - 2026-01-31

### Nuove Funzionalità
- 🪟 **Supporto WSL2 Smart**: Rileva automaticamente l'ambiente WSL.
- 📤 **Auto-Export Font per Windows**: Copia i font scaricati nella cartella `Downloads/NerdFonts_Zsh_Setup` di Windows per facilitare l'installazione manuale sull'host.

## v1.6.0 - 2026-01-31

### Nuove Funzionalità
- 🔤 **Extended Nerd Fonts Support**: L'installer ora scarica e installa automaticamente anche:
  - **Hack Nerd Font**
  - **FiraMono Nerd Font**
  - **Cousine Nerd Font**
- 🛠️ **Installazione più robusta**: Migliorata la gestione dei download dei font.

## v1.5.0 - 2026-01-31

### Cambiamenti
- 🎨 **Nuovo Tema Verde**: Aggiornata la palette colori per maggiore coerenza con Hostname e Git.
- 🟢 **Prompt Character**: Il simbolo `>` ora è **verde grassetto** (successo) e **rosso grassetto** (errore).
- 🌈 **Syntax Highlighting Rivisitato**:
  - **Comandi**: Verde standard (pulito, no bold).
  - **Path**: Bianco (rimosso underline per leggibilità).
  - **Alias**: Verde acqua (teal) per distinzione.
  - **Pre-comandi**: Ciano grassetto per dare enfasi a `sudo` etc.
  - **Stringhe**: Giallo Tokyo Night (coerente con altri elementi).
  - **Globbing/Redirection**: Viola soft per contrasto.

## v1.4.0 - 2025-01-31

### Nuove Funzionalità
- 🤖 **Claude Code Status Line Enhanced**: Versione avanzata con funzionalità real-time
  - 📊 **Token Usage**: Mostra percentuale contesto utilizzato `[X%]`
  - 🔄 **Auto-update**: Si aggiorna dinamicamente dopo compaction
  - 🤖 **Model Display**: Mostra il modello Claude in uso (cyan)
  - 🎨 **Color-coded**: Colori Starship-matched per coerenza visiva
- 📁 **Smart Directory Truncation**: Path truncato a repository root (come Starship)
- 🔧 **Installer Migliorato**: Preserva configurazioni esistenti in settings.json

### File Aggiunti
- `data/claude-statusline-starship.sh` - Script statusline enhanced nel repository
- Configurazione automatica in `~/.claude/hooks/statusline-starship.sh`

### Documentazione
- Sezione "Integrazione Claude Code Status Line" completamente riscritta
- Nuova tabella con tutte le feature della statusline
- Esempi di output e caratteristiche avanzate documentate

### Breaking Changes
- Path statusline cambiato da `~/.claude/statusline-command.sh` a `~/.claude/hooks/statusline-starship.sh`
- L'installer fa backup automatico di configurazioni esistenti

## v1.3.0 - 2024-12-30

### Nuove Funzionalità
- 🔗 **Integrazione Claude Code Status Line**: Script dedicato per usare lo stesso tema Starship in Claude Code
- 📜 Nuovo file `.claude-statusline.sh` per status line personalizzata
- 🎨 Status line con icone e colori coerenti col tema Tokyo Night

### Documentazione
- Nuova sezione "Integrazione Claude Code Status Line" nel README
- Istruzioni per configurazione automatica

## v1.2.0 - 2024-12-28

### Nuove Funzionalità
- 📁 **Installazione automatica eza** da GitHub releases
- 🌳 **Tree intelligente**: `lt` esclude venv, node_modules, .git
- 📋 Nuovo alias `lta` per tree completo
- 🔧 Script install.sh migliorato con fallback per eza

### Miglioramenti
- Icona untracked cambiata a `\uf059` (? cerchiato più compatto)
- Documentazione aggiornata con nuovi alias

## v1.1.0 - 2024-12-28

### Cambiamenti
- 🎨 Cambiato tema da Tokyo Night a **Ocean Blue + Tokyo Night ibrido**
- ⮕ Nuovo prompt character: freccia moderna `⮕` invece di `❯`
- 🌊 Syntax highlighting con palette **Ocean Blue**:
  - Comandi validi: blu chiaro (#61afef)
  - Comandi non validi: rosso soft (#e06c75)
  - Built-in: cyan (#56b6c2)
  - Alias: blu elettrico (#528bff)
  - Path: azzurro (#89b4fa) con underline
  - Stringhe: cyan brillante (#7dcfff)
- 🐧 Icona Linux cambiata da Fedora a Tux generico
- 📝 Documentazione aggiornata con nuovi colori

### Configurazione
- Starship prompt character colors match Ocean Blue theme
- zsh-syntax-highlighting configurato con Ocean Blue palette
- Tutti gli esempi aggiornati con nuovo prompt character

## v1.0.0 - 2024-12-28

### Rilascio Iniziale
- ✨ Setup completo Zsh + Starship
- 📦 Script di installazione automatica
- 📖 Documentazione completa in italiano
- 🔤 Supporto Nerd Fonts (MesloLGS NF, JetBrainsMono)
- 🎨 Tema Tokyo Night
- 🐍 Supporto Python + venv
- 📊 Git status dettagliato con icone
