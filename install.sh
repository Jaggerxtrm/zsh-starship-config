#!/bin/bash
# Script di installazione automatica per Zsh + Starship + Nerd Fonts
# Compatibile con Fedora/RHEL e Debian/Ubuntu

set -e

echo "==================================="
echo "Installazione Zsh + Starship Setup"
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
        echo "✓ Starship già installato ($(starship --version))"
    else
        curl -sS https://starship.rs/install.sh | sh -s -- -y
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
        fc-cache -fv "$FONT_DIR" > /dev/null 2>&1
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
        fc-cache -fv "$FONT_DIR/JetBrainsMonoNerdFont" > /dev/null 2>&1
        echo "✓ JetBrainsMono Nerd Font installato"
    fi
}

# Installa eza
install_eza() {
    echo -e "\n📁 Installazione eza (modern ls)..."

    if command -v eza &> /dev/null; then
        echo "✓ eza già installato ($(eza --version | head -1))"
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
        echo "✓ eza installato in ~/.local/bin/"
    else
        echo "⚠️  Architettura $ARCH non supportata per download automatico"
        echo "   Installa manualmente da: https://github.com/eza-community/eza/releases"
    fi
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

    # Backup del .zshrc esistente
    if [ -f "$HOME/.zshrc" ]; then
        cp "$HOME/.zshrc" "$HOME/.zshrc.backup.$(date +%Y%m%d_%H%M%S)"
        echo "✓ Backup .zshrc creato"
    fi

    # Crea nuovo .zshrc
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

# Syntax highlighting colors - Ocean Blue theme
ZSH_HIGHLIGHT_STYLES[command]='fg=#61afef'                      # Comandi validi: blu chiaro
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#e06c75'                # Non validi: rosso soft
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#56b6c2'                      # Built-in: cyan
ZSH_HIGHLIGHT_STYLES[alias]='fg=#528bff'                        # Alias: blu elettrico
ZSH_HIGHLIGHT_STYLES[path]='fg=#89b4fa,underline'               # Path: azzurro
ZSH_HIGHLIGHT_STYLES[globbing]='fg=#74c7ec'                     # Glob: acqua
ZSH_HIGHLIGHT_STYLES[precommand]='fg=#82aaff'                   # sudo, time: blu intenso
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#7dcfff'       # 'stringa': cyan brillante
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#7dcfff'       # "stringa": cyan brillante
ZSH_HIGHLIGHT_STYLES[redirection]='fg=#4fc1ff'                  # >, <, |: blu cielo
ZSH_HIGHLIGHT_STYLES[comment]='fg=#5c6370,italic'               # # commenti: grigio

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

    echo "✓ .zshrc configurato"
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

# Main
main() {
    install_base_packages
    install_oh_my_zsh
    install_zsh_plugins
    install_starship
    install_nerd_fonts
    install_eza
    install_modern_tools
    apply_starship_config
    configure_zshrc
    change_shell_to_zsh

    echo -e "\n==================================="
    echo "✅ Installazione completata!"
    echo "==================================="
    echo ""
    echo "⚠️  PROSSIMI PASSI:"
    echo "1. Configura il terminale per usare 'MesloLGS NF' o 'JetBrainsMono Nerd Font'"
    echo "2. Chiudi e riapri il terminale (o esegui: source ~/.zshrc)"
    echo "3. Se hai cambiato shell, fai logout e login"
    echo ""
    echo "📖 Per maggiori informazioni, leggi il README.md"
    echo ""
}

main
