# Changelog

## v2.1.0 - 2026-02-02

### 🚀 Major Update: Comprehensive Update Mechanism & Version Tracking

This release implements a robust update system that ensures existing users receive new features and fixes automatically.

### ✨ New Features

#### 1. Version Tracking System
- **`.config-version`**: Tracks individual component versions (starship.toml v2.1.0, .zshrc template v2.1.0)
- **Version history**: Maintains changelog of configuration changes
- **Installed version tracking**: Stores version in `~/.zsh-starship-config-version`
- **Version comparison**: Smart update decisions based on version differences

#### 2. Smart Diff-Based Updates (install.sh)
- **Intelligent starship.toml updates**:
  - ✅ Uses `diff` to check for actual changes (no blind overwriting)
  - ✅ Creates automatic timestamped backups before updating
  - ✅ Asks user confirmation in normal mode
  - ✅ Auto-updates in `--update` mode
  - ✅ Tracks update status (updated/skipped/unchanged)

- **Enhanced .zshrc merge**:
  - ✅ Checks **each** alias individually (not just "any eza alias")
  - ✅ Detects missing features: lsga, lsg3, lsgm, Bun config, dotfiles alias, Claude Code env vars
  - ✅ Adds only missing features (no duplication)
  - ✅ Preserves user customizations

- **Update summary report**:
  - Shows what was updated/skipped/unchanged
  - Lists new features added to .zshrc
  - Displayed in both update and normal modes

#### 3. Dedicated update.sh Script (Completely Rewritten)
- **Git repository check**: Fetches updates and shows recent commits
- **Pre-update configuration check**: Lists exactly what's missing before updating
- **Version comparison**: Shows installed vs available versions
- **Feature detection**: Lists missing .zshrc features (lsga, lsg3, lsgm, Bun, dotfiles, Claude vars)
- **Colored output**: Better UX with green/yellow/red/blue indicators
- **Confirmation prompts**: User control before making changes
- **Post-update instructions**: Clear next steps after update

### 🐛 Bug Fixes (GitHub Issue #1)

#### Directory Handling in install.sh
- **Root cause**: `install_nerd_fonts()` changed to `/tmp` but never returned
- **Fix**: Added `SCRIPT_DIR` global variable and directory restoration
- **Impact**: Script now works from any working directory

**Changes:**
- Added `SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"` global variable (line 10)
- Added directory restoration in `install_nerd_fonts()` (lines 165, 237)
- Added directory restoration in `update_eza_from_github()` (lines 362, 378)
- Changed to absolute path: `$SCRIPT_DIR/starship.toml` (line 507)

### 📊 System Customizations Synced (System → Repository)

#### New .zshrc Template Features
- **Custom eza aliases**:
  - `lsga`: Tree view with git status
  - `lsg3`: 3-level tree with git status
  - `lsgm`: Git status short format (`git status -s`)

- **Runtime configurations**:
  - Bun completions and PATH setup
  - Dotfiles bare git repository alias (`config` command)
  - Claude Code telemetry disabling environment variables

### 📝 Documentation Updates

- **Prompt symbol**: Updated `⮕` → `>` in EXAMPLES.md, QUICK_START.md, README.md
- **Matches configuration**: `success_symbol = "[>](bold green)"`, `error_symbol = "[>](bold red)"`

### 🔧 Technical Details

**Update Tracking Variables**:
```bash
STARSHIP_UPDATED/SKIPPED/UNCHANGED
ZSHRC_UPDATED/SKIPPED/UNCHANGED
```

**New Functions**:
- `show_update_summary()`: Displays update report
- Enhanced `merge_zshrc_config()`: Specific feature detection
- Improved `apply_starship_config()`: Diff-based updates

### 📦 Files Changed

**New Files:**
- `.config-version` - Component version tracking
- Enhanced `update.sh` (+177 lines) - Complete rewrite

**Updated Files:**
- `VERSION` - 1.7.0 → 2.1.0
- `install.sh` (+175 lines) - Smart diff updates + summary
- `EXAMPLES.md`, `QUICK_START.md`, `README.md` - Prompt symbol updates

### 🎯 Impact on Existing Users

**Before v2.1.0:**
- ❌ starship.toml: Always overwritten (no backup, no choice)
- ❌ New aliases: Ignored (only checked "any eza alias")
- ❌ New features: Never propagated to existing users
- ❌ No version tracking

**After v2.1.0:**
- ✅ starship.toml: Diff-based update with backups
- ✅ Each feature checked individually
- ✅ New features automatically added
- ✅ Version tracking enables smart decisions

### 💡 Usage

**For existing users:**
```bash
./update.sh              # Smart update with version check (recommended)
# OR
./install.sh --update    # Direct update mode
```

**Check version:**
```bash
cat ~/.zsh-starship-config-version  # Shows: 2.1.0
```

### 🔗 References
- Fixes #1 (GitHub Issue)
- Related commits: 88a0496, df4e699

---

## v2.0.0 - 2026-02-01

### 🎉 Major Release: Update System & Smart Configuration

Questa è una major release che risolve i problemi di aggiornamento e introduce un sistema intelligente di gestione configurazioni.

### 🔄 Nuove Funzionalità

#### Sistema di Update
- **Flag `--update`**: Modalità update dedicata per aggiornare installazioni esistenti
- **Verifica versioni**: Controlla versioni Starship, eza prima di reinstallare
- **Update interattivo**: Chiede conferma prima di aggiornare ogni componente
- **Script wrapper `update.sh`**: Shortcut per `./install.sh --update` + `git pull`
- **Flag `--verbose`**: Output dettagliato per debugging

#### Merge Intelligente .zshrc
- **NON sovrascrive più** le personalizzazioni utente!
- **Merge automatico**: Aggiunge solo elementi mancanti (plugin, alias, Starship)
- **Backup automatico**: Crea `~/.zshrc.backup.TIMESTAMP` ad ogni modifica
- **Rilevamento configurazione**: Controlla se Starship è già configurato
- **Prompt intelligente**: Chiede cosa fare in caso di conflitto

#### Installazione Automatica Font Windows (WSL)
- **PowerShell automation**: Installa font su Windows automaticamente da WSL
- **User-level install**: Non richiede privilegi amministratore
- **Registry integration**: Registra font in Windows Registry
- **Fallback manuale**: Se PowerShell fallisce, istruzioni manuali chiare
- **Update-aware**: Non ricopia font se già presenti (in modalità normale)

#### Verifica Post-Installazione
- **Auto-check**: Verifica automatica di tutti i componenti installati
- **Report dettagliato**: Mostra versioni installate e componenti mancanti
- **Contatore errori/warning**: Distingue errori critici da avvisi
- **Test rendering**: (con `--verbose`) Verifica che Starship funzioni

#### Ordine di Installazione Corretto
- **FIX CRITICO**: `apply_starship_config()` ora eseguito PRIMA di `install_claude_code_statusline()`
- Garantisce che Claude Code statusline abbia accesso alla configurazione Starship

### 📝 File Nuovi/Modificati

#### Nuovi File
- `scripts/install-fonts-windows.ps1` - Script PowerShell per installazione automatica font
- `UPGRADE.md` - Guida completa all'aggiornamento
- `update.sh` - Script wrapper per update rapido

#### File Modificati
- `install.sh` - Completamente rivisitato con nuove funzionalità
- `README.md` - Sezioni update, WSL e opzioni CLI
- `CHANGELOG.md` - Questo file

### 🔧 Miglioramenti Funzioni

#### `install_starship()`
- Rileva versione corrente
- Confronta versioni prima/dopo update
- Prompt interattivo per aggiornamento
- Supporto `--update` mode

#### `install_eza()`
- Update da package manager (se installato così)
- Update da GitHub releases (fallback)
- Helper function `update_eza_from_github()`
- Verifica versione installata

#### `handle_wsl_fonts()`
- Integrazione script PowerShell
- Conversione path WSL → Windows (`wslpath`)
- Pulizia directory in UPDATE_MODE
- Fallback manuale se PowerShell fallisce

#### `configure_zshrc()`
- **Breaking change**: Non sovrascrive più automaticamente
- Nuove funzioni helper:
  - `create_new_zshrc()` - Crea .zshrc da zero
  - `merge_zshrc_config()` - Merge elementi mancanti
  - `add_starship_to_existing_zshrc()` - Aggiunge solo Starship
- Backup automatico con timestamp
- Rilevamento configurazione esistente

#### `verify_installation()`
- **Nuova funzione**: Verifica completa post-installazione
- Check componenti: Zsh, Starship, eza, jq, font, Claude statusline
- Report formattato con ✓ ⚠️ ❌
- Return code 1 se errori critici

### 🎯 Edge Cases Risolti

1. **Starship già installato**: Non reinstalla, propone update
2. **eza già installato**: Verifica package manager vs GitHub install
3. **Font WSL duplicati**: Non ricopia se già presenti
4. **`.zshrc` personalizzato**: Merge invece di overwrite
5. **Configurazione Starship mancante**: Rilevata e corretta
6. **Claude statusline prima di starship.toml**: Ordine corretto

### 🪟 WSL: Dettagli Tecnici

#### Font Installation Flow
```bash
1. Copia font → /mnt/c/Users/$WIN_USER/Downloads/NerdFonts_Zsh_Setup
2. Genera script PowerShell → /tmp/install-fonts.ps1
3. Converti path → wslpath -w
4. Esegui PowerShell → powershell.exe -ExecutionPolicy Bypass
5. Installa font → $env:LOCALAPPDATA\Microsoft\Windows\Fonts
6. Registra → HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts
```

#### Registry Key Format
```powershell
Name: "FontBaseName (TrueType)"  # o (OpenType)
Value: "FontFileName.ttf"
```

### 📖 Documentazione

- **UPGRADE.md**: Guida completa 2000+ parole con:
  - Comparazione Before/After
  - Troubleshooting dedicato
  - Best practices
  - Esempi pratici
- **README.md**: Sezioni aggiornate per update e WSL
- **Help integrato**: `./install.sh --help`

### ⚠️ Breaking Changes

1. **Comportamento .zshrc**: Non sovrascrive più automaticamente
   - **Migrazione**: Se vuoi il vecchio comportamento, usa `--update` e conferma overwrite
2. **Ordine esecuzione**: `apply_starship_config` spostato prima di Claude statusline
   - **Impatto**: Nessuno per utenti finali, fix interno

### 🔄 Upgrade Path

Da v1.x a v2.0:
```bash
cd ~/projects/zsh-starship-config
git pull
./install.sh --update
```

Risultato:
- ✅ Starship aggiornato
- ✅ .zshrc preservato (merge solo elementi mancanti)
- ✅ Font Windows auto-installati (se WSL)
- ✅ Verifica automatica componenti

### 🐛 Bug Fixes

- **FIX**: Starship config applicato dopo Claude statusline (ora prima)
- **FIX**: Font WSL copiati ad ogni run (ora solo se necessario)
- **FIX**: .zshrc sovrascritto senza chiedere (ora merge intelligente)
- **FIX**: Nessuna verifica post-install (ora automatica)
- **FIX**: Versioni componenti non verificate (ora controllate)

### 📊 Statistiche

- **Linee di codice**: ~870 (era ~506, +72%)
- **Nuove funzioni**: 7 (`merge_zshrc_config`, `add_starship_to_existing_zshrc`, `create_new_zshrc`, `verify_installation`, `update_eza_from_github`, `show_help`, PowerShell script)
- **Nuovi file**: 3 (UPGRADE.md, update.sh, install-fonts-windows.ps1)
- **Flag CLI**: 3 (--update, --verbose, --help)

### 🙏 Grazie

Questa release è stata sviluppata per risolvere problemi reali di utenti che aggiornavano da versioni precedenti.

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
