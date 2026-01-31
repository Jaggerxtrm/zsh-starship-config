# Changelog

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
