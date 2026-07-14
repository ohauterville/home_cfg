#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Starting 'just'..."

# ---------------------------------------------------------
# 1. INSTALLATION DE JUST (Si non présent)
# ---------------------------------------------------------
if ! command -v just &> /dev/null; then
    echo "⬇️ 'just' will be installed in ~/.local/bin..."
    mkdir -p ~/.local/bin
    
    # Script officiel d'installation de just
    curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to ~/.local/bin
    
    # Ajout du dossier au PATH dans le .bashrc si ce n'est pas déjà le cas
    if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' ~/.bashrc; then
        echo "" >> ~/.bashrc
        echo "# Ajout du dossier local bin au PATH (pour just)" >> ~/.bashrc
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
    fi
    # On l'ajoute pour la session en cours
    export PATH="$HOME/.local/bin:$PATH"
else
    echo "just is already installed."
fi

# ---------------------------------------------------------
# 2. AUTOCOMPLÉTION DANS .bashrc
# ---------------------------------------------------------
AUTOCOMP_LINE='eval "$(just --completions bash)"'

# On vérifie si la ligne existe déjà dans le .bashrc
if grep -Fq "$AUTOCOMP_LINE" ~/.bashrc; then
    echo "Autocomplete already in ~/.bashrc."
else
    echo "Adding autocomplete to ~/.bashrc..."
    echo "" >> ~/.bashrc
    echo "# Just autocomplete" >> ~/.bashrc
    echo "$AUTOCOMP_LINE" >> ~/.bashrc
fi

# ---------------------------------------------------------
# 3. COPIE DE JUSTFILE ET JUSTFILES/ VERS $HOME
# ---------------------------------------------------------
echo "Linking to $HOME..."

# Copie du justfile
if [ -f "$SCRIPT_DIR/justfile" ]; then
    ln -sf "$SCRIPT_DIR/justfile" "$HOME/justfile"
    echo "   -> justfile linked."
else
    echo "   ❌ No justfile found in $SCRIPT_DIR"
fi

# Copie du dossier justfiles/
if [ -d "$SCRIPT_DIR/justfiles" ]; then
    ln -sfn "$SCRIPT_DIR/justfiles" "$HOME/justfiles"
    echo "   -> justfiles/ linked."
else
    echo "   ❌ No 'justfiles/' found in $SCRIPT_DIR"
fi

echo "Installation complete !"
echo "Please source this terminal."
