#!/bin/bash
# Script di installazione automatica per Zsh + Starship + Nerd Fonts
# Compatibile con Fedora/RHEL e Debian/Ubuntu

set -e

# Variabili globali
UPDATE_MODE=false
VERBOSE=false

# Funzione di help
show_help() {
    cat << EOF
Usage: ./install.sh [OPTIONS]

Installazione automatica di Zsh + Starship + Nerd Fonts

OPTIONS:
    -u, --update        Modalità update: aggiorna componenti già installati
    -v, --verbose       Output dettagliato
    -h, --help          Mostra questo messaggio

EXAMPLES:
    ./install.sh                # Installazione normale
    ./install.sh --update       # Aggiorna tutti i componenti
    ./install.sh -u -v          # Aggiorna con output verboso

EOF
}

# Parse argomenti
while [[ $# -gt 0 ]]; do
    case $1 in
        -u|--update)
            UPDATE_MODE=true
            shift
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            echo "Opzione sconosciuta: $1"
            show_help
            exit 1
            ;;
    esac
done

echo "==================================="
if [ "$UPDATE_MODE" = true ]; then
    echo "Update Zsh + Starship Setup"
else
    echo "Installazione Zsh + Starship Setup"
fi
echo "==================================="

# Rileva la distribuzione
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
else
    echo "Impossibile rilevare la distribuzione"
    exit 1
fi

# Funzione per installare pacchetti base
install_base_packages() {
    echo -e "\n📦 Installazione pacchetti base..."

    if [ "$OS" = "fedora" ] || [ "$OS" = "rhel" ] || [ "$OS" = "centos" ]; then
        sudo dnf install -y zsh git curl wget unzip tar
        sudo dnf install -y util-linux-user  # Per chsh
    elif [ "$OS" = "ubuntu" ] || [ "$OS" = "debian" ]; then
        sudo apt update
        sudo apt install -y zsh git curl wget unzip tar
    else
        echo "⚠️  Distribuzione non supportata: $OS"
        echo "Installa manualmente: zsh git curl wget unzip tar"
        exit 1
    fi
}

# Installa Oh My Zsh
install_oh_my_zsh() {
    echo -e "\n🎨 Installazione Oh My Zsh..."

    if [ -d "$HOME/.oh-my-zsh" ]; then
        echo "✓ Oh My Zsh già installato"
    else
        RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    fi
}

# Installa plugin Zsh
install_zsh_plugins() {
    echo -e "\n🔌 Installazione plugin Zsh..."

    ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

    # zsh-autosuggestions
    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    else
        echo "✓ zsh-autosuggestions già installato"
    fi

    # zsh-syntax-highlighting
    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
    else
        echo "✓ zsh-syntax-highlighting già installato"
    fi

    # zsh-history-substring-search
    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-history-substring-search" ]; then
        git clone https://github.com/zsh-users/zsh-history-substring-search "$ZSH_CUSTOM/plugins/zsh-history-substring-search"
    else
        echo "✓ zsh-history-substring-search già installato"
    fi
}

# Installa Starship
install_starship() {
    echo -e "\n⭐ Installazione Starship..."

    if command -v starship &> /dev/null; then
        CURRENT_VERSION=$(starship --version | grep -oP 'starship \K[\d.]+' || echo "unknown")
        echo "✓ Starship già installato (v$CURRENT_VERSION)"

        if [ "$UPDATE_MODE" = true ]; then
            echo "🔄 Aggiornamento Starship..."
            curl -sS https://starship.rs/install.sh | sh -s -- -y --force
            NEW_VERSION=$(starship --version | grep -oP 'starship \K[\d.]+' || echo "unknown")
            if [ "$NEW_VERSION" != "$CURRENT_VERSION" ]; then
                echo "✓ Starship aggiornato: v$CURRENT_VERSION → v$NEW_VERSION"
            else
                echo "✓ Starship già alla versione più recente"
            fi
        else
            read -p "Vuoi aggiornare Starship? (s/N) " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Ss]$ ]]; then
                curl -sS https://starship.rs/install.sh | sh -s -- -y --force
                NEW_VERSION=$(starship --version | grep -oP 'starship \K[\d.]+' || echo "unknown")
                echo "✓ Starship aggiornato a v$NEW_VERSION"
            fi
        fi
    else
        echo "Installazione Starship..."
        curl -sS https://starship.rs/install.sh | sh -s -- -y
        echo "✓ Starship installato"
    fi
}

# Installa Nerd Fonts
install_nerd_fonts() {
    echo -e "\n🔤 Installazione Nerd Fonts..."

    FONT_DIR="$HOME/.local/share/fonts"
    mkdir -p "$FONT_DIR"

    # MesloLGS NF (raccomandato da Powerlevel10k)
    if fc-list | grep -qi "MesloLGS NF"; then
        echo "✓ MesloLGS NF già installato"
    else
        echo "Scaricando MesloLGS NF..."
        cd /tmp
        wget -q https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
        wget -q https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
        wget -q https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
        wget -q https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
        mv MesloLGS*.ttf "$FONT_DIR/"
        echo "✓ MesloLGS NF installato"
    fi

    # JetBrainsMono Nerd Font
    if fc-list | grep -qi "JetBrainsMono Nerd Font"; then
        echo "✓ JetBrainsMono Nerd Font già installato"
    else
        echo "Scaricando JetBrainsMono Nerd Font..."
        cd /tmp
        wget -q https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz
        mkdir -p "$FONT_DIR/JetBrainsMonoNerdFont"
        tar -xf JetBrainsMono.tar.xz -C "$FONT_DIR/JetBrainsMonoNerdFont"
        rm JetBrainsMono.tar.xz
        echo "✓ JetBrainsMono Nerd Font installato"
    fi

    # Hack Nerd Font
    if fc-list | grep -qi "Hack Nerd Font"; then
        echo "✓ Hack Nerd Font già installato"
    else
        echo "Scaricando Hack Nerd Font..."
        cd /tmp
        wget -q https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.tar.xz
        mkdir -p "$FONT_DIR/HackNerdFont"
        tar -xf Hack.tar.xz -C "$FONT_DIR/HackNerdFont"
        rm Hack.tar.xz
        echo "✓ Hack Nerd Font installato"
    fi

    # FiraMono Nerd Font
    if fc-list | grep -qi "FiraMono Nerd Font"; then
        echo "✓ FiraMono Nerd Font già installato"
    else
        echo "Scaricando FiraMono Nerd Font..."
        cd /tmp
        wget -q https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraMono.tar.xz
        mkdir -p "$FONT_DIR/FiraMonoNerdFont"
        tar -xf FiraMono.tar.xz -C "$FONT_DIR/FiraMonoNerdFont"
        rm FiraMono.tar.xz
        echo "✓ FiraMono Nerd Font installato"
    fi

    # Cousine Nerd Font
    if fc-list | grep -qi "Cousine Nerd Font"; then
        echo "✓ Cousine Nerd Font già installato"
    else
        echo "Scaricando Cousine Nerd Font..."
        cd /tmp
        wget -q https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Cousine.tar.xz
        mkdir -p "$FONT_DIR/CousineNerdFont"
        tar -xf Cousine.tar.xz -C "$FONT_DIR/CousineNerdFont"
        rm Cousine.tar.xz
        echo "✓ Cousine Nerd Font installato"
    fi

    # Refresh cache
    fc-cache -fv "$FONT_DIR" > /dev/null 2>&1
}

# Gestione Font per WSL (Windows Subsystem for Linux)
handle_wsl_fonts() {
    # Verifica se siamo in WSL
    if grep -qEi "(Microsoft|WSL)" /proc/version; then
        echo -e "\n🪟 Rilevato ambiente WSL!"
        echo "I font devono essere installati anche su Windows per essere usati nel Terminale."

        # Trova l'username Windows corrente
        WIN_USER=$(cmd.exe /c "echo %USERNAME%" 2>/dev/null | tr -d '\r')

        if [ -n "$WIN_USER" ]; then
            WIN_DEST="/mnt/c/Users/$WIN_USER/Downloads/NerdFonts_Zsh_Setup"

            # Copia font in Windows solo se non esistono già o se in UPDATE_MODE
            if [ "$UPDATE_MODE" = true ] || [ ! -d "$WIN_DEST" ]; then
                echo "Copia dei font in Windows ($WIN_DEST)..."
                mkdir -p "$WIN_DEST"

                # Pulisci directory se in UPDATE_MODE
                if [ "$UPDATE_MODE" = true ]; then
                    rm -f "$WIN_DEST"/*.ttf "$WIN_DEST"/*.otf 2>/dev/null || true
                fi

                cp "$HOME/.local/share/fonts/"*.ttf "$WIN_DEST/" 2>/dev/null || true
                cp "$HOME/.local/share/fonts/JetBrainsMonoNerdFont/"* "$WIN_DEST/" 2>/dev/null || true
                cp "$HOME/.local/share/fonts/HackNerdFont/"* "$WIN_DEST/" 2>/dev/null || true
                cp "$HOME/.local/share/fonts/FiraMonoNerdFont/"* "$WIN_DEST/" 2>/dev/null || true
                cp "$HOME/.local/share/fonts/CousineNerdFont/"* "$WIN_DEST/" 2>/dev/null || true

                echo "✓ Font copiati in Windows"
            else
                echo "✓ Font già copiati in $WIN_DEST"
            fi

            # Trova lo script PowerShell
            SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
            PS_SCRIPT="$SCRIPT_DIR/scripts/install-fonts-windows.ps1"

            if [ -f "$PS_SCRIPT" ]; then
                echo ""
                echo "🚀 Installazione automatica font su Windows..."

                # Converte path WSL in Windows path
                WIN_PS_SCRIPT=$(wslpath -w "$PS_SCRIPT")

                # Esegui script PowerShell
                if powershell.exe -ExecutionPolicy Bypass -File "$WIN_PS_SCRIPT" 2>&1; then
                    echo "✓ Font installati automaticamente su Windows!"
                    echo ""
                    echo "⚠️  AZIONE RICHIESTA:"
                    echo "1. Riavvia Windows Terminal"
                    echo "2. Impostazioni → Profili → Ubuntu/WSL → Aspetto"
                    echo "3. Tipo di carattere: 'MesloLGS NF'"
                else
                    echo "⚠️  Installazione automatica fallita. Procedura manuale:"
                    echo ""
                    echo "1. Apri la cartella 'Download/NerdFonts_Zsh_Setup' su Windows"
                    echo "2. Seleziona tutti i file .ttf/.otf"
                    echo "3. Tasto destro → 'Installa' (o 'Installa per tutti gli utenti')"
                    echo "4. Configura Windows Terminal per usare 'MesloLGS NF'"
                fi
            else
                echo ""
                echo "⚠️  Script PowerShell non trovato. AZIONE RICHIESTA SU WINDOWS:"
                echo "1. Apri la cartella 'Download/NerdFonts_Zsh_Setup' su Windows"
                echo "2. Seleziona tutti i file .ttf/.otf"
                echo "3. Tasto destro → 'Installa' (o 'Installa per tutti gli utenti')"
                echo "4. Configura Windows Terminal per usare 'MesloLGS NF'"
            fi
        else
            echo "⚠️  Impossibile determinare l'utente Windows. Copia manuale richiesta."
        fi
    fi
}

# Installa eza
install_eza() {
    echo -e "\n📁 Installazione eza (modern ls)..."

    if command -v eza &> /dev/null; then
        CURRENT_VERSION=$(eza --version | head -1)
        echo "✓ eza già installato ($CURRENT_VERSION)"

        if [ "$UPDATE_MODE" = true ]; then
            echo "🔄 Aggiornamento eza..."
            # Se installato da repo, usa package manager
            if [ "$OS" = "fedora" ] && sudo dnf list installed eza &> /dev/null; then
                sudo dnf update -y eza
            else
                # Reinstalla da GitHub
                update_eza_from_github
            fi
        else
            read -p "Vuoi aggiornare eza? (s/N) " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Ss]$ ]]; then
                if [ "$OS" = "fedora" ] && sudo dnf list installed eza &> /dev/null; then
                    sudo dnf update -y eza
                else
                    update_eza_from_github
                fi
            fi
        fi
        return
    fi

    # Prova prima dai repo
    if [ "$OS" = "fedora" ]; then
        echo "Tentativo installazione da Copr..."
        if sudo dnf copr enable -y atim/eza 2>/dev/null && sudo dnf install -y eza 2>/dev/null; then
            echo "✓ eza installato da Copr"
            return
        fi
    fi

    # Fallback: installa da GitHub releases
    update_eza_from_github
}

# Helper per aggiornare eza da GitHub
update_eza_from_github() {
    echo "Installazione da GitHub releases..."
    cd /tmp
    ARCH=$(uname -m)
    if [ "$ARCH" = "x86_64" ]; then
        wget -q https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz
        tar -xzf eza_x86_64-unknown-linux-gnu.tar.gz
        mkdir -p "$HOME/.local/bin"
        mv eza "$HOME/.local/bin/"
        chmod +x "$HOME/.local/bin/eza"
        rm eza_x86_64-unknown-linux-gnu.tar.gz
        NEW_VERSION=$(eza --version | head -1)
        echo "✓ eza installato/aggiornato: $NEW_VERSION"
    else
        echo "⚠️  Architettura $ARCH non supportata per download automatico"
        echo "   Installa manualmente da: https://github.com/eza-community/eza/releases"
    fi
}

# Installa jq (richiesto per Claude Code status line)
install_jq() {
    echo -e "\n📊 Installazione jq (JSON parser)..."

    if command -v jq &> /dev/null; then
        echo "✓ jq già installato"
        return
    fi

    if [ "$OS" = "fedora" ] || [ "$OS" = "rhel" ] || [ "$OS" = "centos" ]; then
        sudo dnf install -y jq
    elif [ "$OS" = "ubuntu" ] || [ "$OS" = "debian" ]; then
        sudo apt install -y jq
    fi
}

# Configura Claude Code status line
install_claude_code_statusline() {
    echo -e "\n🔗 Configurazione Claude Code Status Line..."

    # Verifica che jq sia installato
    if ! command -v jq &> /dev/null; then
        echo "⚠️  jq non installato. Installo prima jq..."
        install_jq
    fi

    # Crea directory Claude hooks
    mkdir -p "$HOME/.claude/hooks"

    # Copia lo script della status line dal repository
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    if [ -f "$SCRIPT_DIR/data/claude-statusline-starship.sh" ]; then
        cp "$SCRIPT_DIR/data/claude-statusline-starship.sh" "$HOME/.claude/hooks/statusline-starship.sh"
        chmod +x "$HOME/.claude/hooks/statusline-starship.sh"
        echo "✓ Script statusline copiato da repository"
    else
        echo "⚠️  Script statusline non trovato in data/, creo versione base..."
        # Fallback: crea versione base se il file non esiste
        cat > "$HOME/.claude/hooks/statusline-starship.sh" << 'EOF'
#!/bin/bash
# Starship-inspired status line for Claude Code
# Format: model [usage%] username@hostname directory git_branch git_status python_venv

input=$(cat)
model_display=$(echo "$input" | jq -r '.model.display_name // .model.id // "unknown"')
token_percentage=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
if [ -n "$token_percentage" ]; then
  token_display=$(printf "[%.0f%%]" "$token_percentage")
  model_display="$model_display $token_display"
fi
dir=$(echo "$input" | jq -r '.workspace.current_dir')
user=$(whoami)
host=$(hostname -s)
repo_root=$(cd "$dir" 2>/dev/null && git rev-parse --show-toplevel 2>/dev/null)
if [ -n "$repo_root" ]; then
  rel_path=$(realpath --relative-to="$repo_root" "$dir" 2>/dev/null || echo ".")
  if [ "$rel_path" = "." ]; then
    display_dir=$(basename "$repo_root")
  else
    display_dir="$(basename "$repo_root")/$rel_path"
  fi
else
  display_dir=$(echo "$dir" | sed "s|^$HOME|home|")
fi
git_info=""
git_status_icon=""
if cd "$dir" 2>/dev/null && git rev-parse --git-dir >/dev/null 2>&1; then
  branch=$(git -c core.useBuiltinFSMonitor=false branch --show-current 2>/dev/null || echo "HEAD")
  git_icon=$(printf '\uf09b')
  git_info=" $git_icon $branch"
  status=$(git -c core.useBuiltinFSMonitor=false status --porcelain 2>/dev/null)
  if [ -n "$status" ]; then
    mod_icon=$(printf '\uf040')
    git_status_icon=" $mod_icon"
  fi
fi
venv=""
if [ -n "$VIRTUAL_ENV" ]; then
  py_icon=$(printf '\ue73c')
  venv=" $py_icon ($(basename "$VIRTUAL_ENV"))"
fi
printf '\033[36m%s\033[0m \033[37m%s\033[0m@\033[1;32m%s\033[0m \033[37m%s\033[0m\033[32m%s%s\033[0m\033[33m%s\033[0m' \
  "$model_display" "$user" "$host" "$display_dir" "$git_info" "$git_status_icon" "$venv"
EOF
        chmod +x "$HOME/.claude/hooks/statusline-starship.sh"
    fi

    # Crea/aggiorna settings.json preservando altre configurazioni
    if [ -f "$HOME/.claude/settings.json" ]; then
        # Backup esistente
        cp "$HOME/.claude/settings.json" "$HOME/.claude/settings.json.backup.$(date +%Y%m%d_%H%M%S)"
        # Aggiorna solo statusLine usando jq
        jq '. + {"statusLine": {"command": "~/.claude/hooks/statusline-starship.sh"}}' \
            "$HOME/.claude/settings.json" > "$HOME/.claude/settings.json.tmp" && \
            mv "$HOME/.claude/settings.json.tmp" "$HOME/.claude/settings.json"
    else
        echo '{"statusLine": {"command": "~/.claude/hooks/statusline-starship.sh"}}' > "$HOME/.claude/settings.json"
    fi

    echo "✓ Claude Code status line configurata (Enhanced)"
    echo "  - Script: ~/.claude/hooks/statusline-starship.sh"
    echo "  - Config: ~/.claude/settings.json"
    echo "  - Features: Model name, token usage %, git status, Python venv"
}

# Installa strumenti moderni (opzionale)
install_modern_tools() {
    echo -e "\n🛠️  Installazione strumenti moderni (opzionale)..."

    read -p "Vuoi installare bat, ripgrep, fd, zoxide? (s/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Ss]$ ]]; then
        if [ "$OS" = "fedora" ]; then
            sudo dnf install -y bat ripgrep fd-find zoxide fzf
        elif [ "$OS" = "ubuntu" ] || [ "$OS" = "debian" ]; then
            sudo apt install -y bat ripgrep fd-find fzf
            echo "⚠️  Per zoxide su Ubuntu, consulta la documentazione ufficiale"
        fi
    fi
}

# Applica configurazione Starship
apply_starship_config() {
    echo -e "\n⚙️  Applicazione configurazione Starship..."

    mkdir -p "$HOME/.config"
    cp starship.toml "$HOME/.config/starship.toml"
    echo "✓ Configurazione Starship copiata"
}

# Configura .zshrc
configure_zshrc() {
    echo -e "\n📝 Configurazione .zshrc..."

    ZSHRC="$HOME/.zshrc"

    # Se .zshrc non esiste, crea nuovo file
    if [ ! -f "$ZSHRC" ]; then
        echo "Creazione nuovo .zshrc..."
        create_new_zshrc
        echo "✓ .zshrc creato"
        return
    fi

    # .zshrc esiste: fai backup
    BACKUP="$HOME/.zshrc.backup.$(date +%Y%m%d_%H%M%S)"
    cp "$ZSHRC" "$BACKUP"
    echo "✓ Backup creato: $BACKUP"

    # Controlla se ha già configurazione Starship
    if grep -q "starship init zsh" "$ZSHRC"; then
        echo "✓ Configurazione Starship già presente"

        # In UPDATE_MODE, chiedi se sovrascrivere
        if [ "$UPDATE_MODE" = true ]; then
            read -p "Vuoi sovrascrivere completamente .zshrc? (s/N) " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Ss]$ ]]; then
                create_new_zshrc
                echo "✓ .zshrc sovrascritto"
            else
                echo "✓ .zshrc mantenuto (usa backup se serve: $BACKUP)"
                merge_zshrc_config
            fi
        else
            # Modalità normale: aggiungi solo elementi mancanti
            merge_zshrc_config
        fi
    else
        # Non ha Starship: chiedi se sovrascrivere o aggiungere
        echo "⚠️  .zshrc esistente senza configurazione Starship"
        read -p "Vuoi sovrascrivere .zshrc? (s=sovrascrivi, N=aggiungi Starship) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Ss]$ ]]; then
            create_new_zshrc
            echo "✓ .zshrc sovrascritto"
        else
            add_starship_to_existing_zshrc
            echo "✓ Starship aggiunto a .zshrc esistente"
        fi
    fi
}

# Helper: crea .zshrc completo da zero
create_new_zshrc() {
    cat > "$HOME/.zshrc" << 'EOF'
# Oh My Zsh configuration
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""

# Plugins
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-history-substring-search
    colored-man-pages
    command-not-found
)

source $ZSH/oh-my-zsh.sh

# Syntax highlighting colors - Green Theme (Custom)
ZSH_HIGHLIGHT_STYLES[command]='fg=green'                        # Comandi validi: verde standard (no bold)
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#f7768e,bold'           # Non validi: rosso Tokyo Night
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#bb9af7'                      # Built-in: viola soft
ZSH_HIGHLIGHT_STYLES[alias]='fg=#73daca,bold'                   # Alias: verde acqua (teal)
ZSH_HIGHLIGHT_STYLES[path]='fg=white'                           # Path: bianco (no underline)
ZSH_HIGHLIGHT_STYLES[globbing]='fg=#bb9af7'                     # Glob: viola soft
ZSH_HIGHLIGHT_STYLES[precommand]='fg=#7dcfff,bold'              # sudo, time: ciano (per attenzione)
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#e0af68'       # 'stringa': giallo Tokyo Night
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#e0af68'       # "stringa": giallo Tokyo Night
ZSH_HIGHLIGHT_STYLES[redirection]='fg=#bb9af7'                  # >, <, |: viola soft
ZSH_HIGHLIGHT_STYLES[comment]='fg=#56b6c2,italic'               # # commenti: ciano scuro

# FZF integration (se disponibile)
if [ -f /usr/share/fzf/shell/key-bindings.zsh ]; then
    source /usr/share/fzf/shell/key-bindings.zsh
    export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
    export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range :500 {} 2>/dev/null || cat {}'"
fi

# Zoxide initialization (se disponibile)
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh)"
fi

# Alias moderni (se i tool sono disponibili)
if command -v eza &> /dev/null; then
    alias ls='eza --icons --group-directories-first'
    alias ll='eza -l --icons --group-directories-first'
    alias la='eza -la --icons --group-directories-first'
    alias lt='eza --tree --icons --group-directories-first --git-ignore --ignore-glob="venv|.venv|env|.env|node_modules|.git"'
    alias lta='eza --tree --icons --group-directories-first'  # tree ALL (senza esclusioni)
fi

if command -v bat &> /dev/null; then
    alias cat='bat --style=auto'
fi

if command -v rg &> /dev/null; then
    alias grep='rg'
fi

if command -v fd &> /dev/null; then
    alias find='fd'
fi

if command -v zoxide &> /dev/null; then
    alias cd='z'
fi

# Starship prompt
if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
fi

# NVM (se installato)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# PATH
export PATH="$HOME/.local/bin:$PATH"
EOF
}

# Helper: merge configurazione in .zshrc esistente
merge_zshrc_config() {
    echo "Aggiornamento elementi mancanti in .zshrc..."

    ZSHRC="$HOME/.zshrc"

    # Aggiungi plugin mancanti
    REQUIRED_PLUGINS=("zsh-autosuggestions" "zsh-syntax-highlighting" "zsh-history-substring-search")
    for plugin in "${REQUIRED_PLUGINS[@]}"; do
        if ! grep -q "$plugin" "$ZSHRC"; then
            echo "Aggiunta plugin: $plugin"
            # Trova la linea plugins=() e aggiungi il plugin
            sed -i "/^plugins=(/a\    $plugin" "$ZSHRC"
        fi
    done

    # Verifica PATH per .local/bin
    if ! grep -q 'PATH.*\.local/bin' "$ZSHRC"; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$ZSHRC"
        echo "✓ PATH aggiornato"
    fi

    # Verifica alias eza se non presenti
    if command -v eza &> /dev/null && ! grep -q "alias.*eza" "$ZSHRC"; then
        cat >> "$ZSHRC" << 'EOF'

# Alias eza (modern ls)
if command -v eza &> /dev/null; then
    alias ls='eza --icons --group-directories-first'
    alias ll='eza -l --icons --group-directories-first'
    alias la='eza -la --icons --group-directories-first'
    alias lt='eza --tree --icons --group-directories-first --git-ignore --ignore-glob="venv|.venv|env|.env|node_modules|.git"'
    alias lta='eza --tree --icons --group-directories-first'
fi
EOF
        echo "✓ Alias eza aggiunti"
    fi

    echo "✓ .zshrc aggiornato (merge)"
}

# Helper: aggiungi solo Starship a .zshrc esistente
add_starship_to_existing_zshrc() {
    ZSHRC="$HOME/.zshrc"

    # Aggiungi init Starship alla fine
    cat >> "$ZSHRC" << 'EOF'

# Starship prompt (added by zsh-starship-config installer)
if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
fi
EOF

    # Aggiungi PATH se mancante
    if ! grep -q 'PATH.*\.local/bin' "$ZSHRC"; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$ZSHRC"
    fi

    echo "✓ Starship aggiunto a .zshrc"
}

# Cambia shell a zsh
change_shell_to_zsh() {
    echo -e "\n🐚 Cambio shell predefinita a Zsh..."

    if [ "$SHELL" = "$(which zsh)" ]; then
        echo "✓ Zsh già shell predefinita"
    else
        read -p "Vuoi impostare Zsh come shell predefinita? (s/N) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Ss]$ ]]; then
            chsh -s "$(which zsh)"
            echo "✓ Shell cambiata a Zsh (richiede logout)"
        fi
    fi
}

# Verifica post-installazione
verify_installation() {
    echo -e "\n🔍 Verifica installazione..."
    echo ""

    ERRORS=0
    WARNINGS=0

    # Verifica Zsh
    if command -v zsh &> /dev/null; then
        ZSH_VER=$(zsh --version | cut -d' ' -f2)
        echo "✓ Zsh: v$ZSH_VER"
    else
        echo "❌ Zsh non trovato"
        ((ERRORS++))
    fi

    # Verifica Oh My Zsh
    if [ -d "$HOME/.oh-my-zsh" ]; then
        echo "✓ Oh My Zsh: installato"
    else
        echo "❌ Oh My Zsh non trovato"
        ((ERRORS++))
    fi

    # Verifica plugin Zsh
    ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
    if [ -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
        echo "✓ Plugin zsh-autosuggestions: installato"
    else
        echo "⚠️  Plugin zsh-autosuggestions non trovato"
        ((WARNINGS++))
    fi

    # Verifica Starship
    if command -v starship &> /dev/null; then
        STARSHIP_VER=$(starship --version | grep -oP 'starship \K[\d.]+' || echo "unknown")
        echo "✓ Starship: v$STARSHIP_VER"

        # Verifica config Starship
        if [ -f "$HOME/.config/starship.toml" ]; then
            echo "✓ Configurazione Starship: presente"
        else
            echo "⚠️  Configurazione Starship non trovata"
            ((WARNINGS++))
        fi

        # Test rendering Starship
        if [ "$VERBOSE" = true ]; then
            TEST_OUTPUT=$(starship prompt 2>&1)
            if [ $? -eq 0 ]; then
                echo "✓ Test rendering Starship: OK"
            else
                echo "⚠️  Starship warning: $TEST_OUTPUT"
                ((WARNINGS++))
            fi
        fi
    else
        echo "❌ Starship non trovato"
        ((ERRORS++))
    fi

    # Verifica Nerd Fonts
    if fc-list | grep -qi "MesloLGS NF"; then
        echo "✓ Font MesloLGS NF: installato"
    else
        echo "⚠️  Font MesloLGS NF non installato"
        ((WARNINGS++))
    fi

    # Verifica eza
    if command -v eza &> /dev/null; then
        EZA_VER=$(eza --version | head -1)
        echo "✓ eza: $EZA_VER"
    else
        echo "⚠️  eza non installato (opzionale)"
    fi

    # Verifica jq (per Claude Code)
    if command -v jq &> /dev/null; then
        echo "✓ jq: installato"
    else
        echo "⚠️  jq non installato (richiesto per Claude Code)"
        ((WARNINGS++))
    fi

    # Verifica Claude Code statusline
    if [ -f "$HOME/.claude/hooks/statusline-starship.sh" ]; then
        echo "✓ Claude Code statusline: configurata"
    else
        echo "⚠️  Claude Code statusline non configurata"
    fi

    # Verifica .zshrc
    if [ -f "$HOME/.zshrc" ]; then
        if grep -q "starship init zsh" "$HOME/.zshrc"; then
            echo "✓ .zshrc: configurato con Starship"
        else
            echo "⚠️  .zshrc non contiene init Starship"
            ((WARNINGS++))
        fi
    else
        echo "❌ .zshrc non trovato"
        ((ERRORS++))
    fi

    # Sommario
    echo ""
    echo "==================================="
    if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
        echo "✅ Tutte le verifiche passate!"
    elif [ $ERRORS -eq 0 ]; then
        echo "✅ Installazione completata con $WARNINGS avvisi"
    else
        echo "⚠️  Installazione completata con $ERRORS errori e $WARNINGS avvisi"
        return 1
    fi
    echo "==================================="
}

# Main
main() {
    install_base_packages
    install_oh_my_zsh
    install_zsh_plugins
    install_starship
    install_nerd_fonts
    handle_wsl_fonts
    install_eza
    install_jq
    apply_starship_config          # IMPORTANTE: prima di Claude Code statusline
    install_claude_code_statusline  # Usa la config Starship
    install_modern_tools
    configure_zshrc
    change_shell_to_zsh

    # Verifica installazione
    verify_installation

    echo -e "\n==================================="
    if [ "$UPDATE_MODE" = true ]; then
        echo "✅ Update completato!"
    else
        echo "✅ Installazione completata!"
    fi
    echo "==================================="
    echo ""
    echo "⚠️  PROSSIMI PASSI:"
    echo "1. Configura il terminale per usare 'MesloLGS NF' o 'JetBrainsMono Nerd Font'"
    echo "2. Chiudi e riapri il terminale (o esegui: source ~/.zshrc)"
    echo "3. Se hai cambiato shell, fai logout e login"
    echo ""
    echo "🔗 Claude Code status line configurata! Riavvia Claude Code per vederla."
    echo ""
    echo "📖 Per maggiori informazioni, leggi il README.md"
    echo ""

    # Suggerimenti per UPDATE_MODE
    if [ "$UPDATE_MODE" = true ]; then
        echo "💡 TIP: Se hai fatto update, esegui 'source ~/.zshrc' per ricaricare la config"
        echo ""
    fi
}

main
