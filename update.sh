#!/bin/bash
# Script wrapper per aggiornamento rapido
# Equivalente a: ./install.sh --update

echo "🔄 Zsh Starship Config - Update"
echo ""

# Vai alla directory dello script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Aggiorna repository se è un git repo
if [ -d ".git" ]; then
    echo "📥 Aggiornamento repository..."
    if git pull; then
        echo "✓ Repository aggiornato"
    else
        echo "⚠️  Impossibile aggiornare repository (continuo comunque)"
    fi
    echo ""
fi

# Esegui install.sh in modalità update
exec ./install.sh --update "$@"
