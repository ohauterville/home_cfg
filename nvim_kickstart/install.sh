#!/usr/bin/env bash
#
# install.sh - Install kickstart.nvim and IDE layout linked to dotfiles
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_CONFIG_DIR="${SCRIPT_DIR}/config"
NVIM_CONFIG_DIR="${HOME}/.config/nvim"
KICKSTART_REPO="https://github.com/nvim-lua/kickstart.nvim.git"

info()  { echo "[INFO] $1"; }
warn()  { echo "[WARN] $1"; }
error() { echo "[ERROR] $1" >&2; }

# ----------------------------
# 1. Check neovim is installed
# ----------------------------
if ! command -v nvim &> /dev/null; then
    error "neovim is not installed. Install it first, then re-run this script."
    exit 1
fi

NVIM_VERSION=$(nvim --version | head -n1 | grep -oP '\d+\.\d+' | head -n1 || echo "unknown")
info "Found neovim version: ${NVIM_VERSION}"

# ----------------------------
# 2. Setup Kickstart in the repository
# ----------------------------
if [[ ! -d "$REPO_CONFIG_DIR" ]]; then
    info "Cloning kickstart.nvim into local repository (${REPO_CONFIG_DIR})..."
    git clone "$KICKSTART_REPO" "$REPO_CONFIG_DIR"
    
    # Remove the .git folder so you can track it in your own dotfiles repo
    rm -rf "${REPO_CONFIG_DIR}/.git"

    # NOUVEAU : On décommente la ligne require 'custom.plugins' !
    info "Enabling custom plugins in init.lua..."
    sed -i "s/-- require 'custom.plugins'/require 'custom.plugins'/g" "$REPO_CONFIG_DIR/init.lua"
else
    info "Kickstart config already exists in repository."
fi

# ----------------------------
# 3. Inject VS Code IDE Layout (Neo-tree + Toggleterm)
# ----------------------------
CUSTOM_LUA_DIR="${REPO_CONFIG_DIR}/lua/custom"
mkdir -p "$CUSTOM_LUA_DIR"

IDE_PLUGIN_FILE="${CUSTOM_LUA_DIR}/plugins.lua"

info "Injecting IDE layout configuration..."
cat << 'EOF' > "$IDE_PLUGIN_FILE"
-- Fonction utilitaire requise par vim.pack
local function gh(repo) return 'https://github.com/' .. repo end

-- 1. File Explorer (Neo-tree) et ses dépendances
vim.pack.add { 
  gh 'nvim-lua/plenary.nvim',
  gh 'nvim-tree/nvim-web-devicons',
  gh 'MunifTanjim/nui.nvim',
  gh 'nvim-neo-tree/neo-tree.nvim'
}

require('neo-tree').setup({
  close_if_last_window = true,
  window = { width = 30 },
  filesystem = {
      filtered_items = {
          visible = true,
          hide_dotfiles = true,
          hide_gitignored = false,
      }
  }
})

-- 2. Integrated Terminal (Toggleterm)
vim.pack.add { gh 'akinsho/toggleterm.nvim' }

require("toggleterm").setup({
  size = 15,
  open_mapping = [[<c-\>]], -- Ctrl + \ pour ouvrir/fermer rapidement
  direction = 'horizontal',
})

-- 3. THE MAGIC IDE SHORTCUT (Space + i)
vim.keymap.set('n', '<leader>i', function()
  -- Ouvre l'explorateur à gauche
  vim.cmd('Neotree show')
  -- Ouvre le terminal en bas
  vim.cmd('ToggleTerm')
  -- Ramène le curseur sur le code
  vim.cmd('wincmd k')
  print("Mode IDE activé !")
end, { desc = 'Activer le layout [I]DE (VS Code)' })

-- Raccourci bonus juste pour l'explorateur
vim.keymap.set('n', '<leader>e', '<Cmd>Neotree toggle<CR>', { desc = 'Toggle [E]xplorer' })

-- 4. Plugin ROS 2 (nvim-ros2)
-- Téléchargement du plugin
vim.pack.add { gh 'ErickKramer/nvim-ros2' }

-- Initialisation du plugin (Obligatoire)
-- pcall évite un crash de Neovim si le plugin n'est pas encore téléchargé
pcall(function()
  require("nvim-ros2").setup({
    -- Le plugin utilise Telescope par défaut, on laisse les options vides
  })
  
  -- Injection dans Telescope
  require("telescope").load_extension("ros2")
end)

-- Raccourci clavier personnalisé pour ouvrir le menu ROS (Espace + r)
vim.keymap.set('n', '<leader>r', '<Cmd>Telescope ros2<CR>', { desc = 'Menu [R]OS 2' })
EOF

# ----------------------------
# 4. Backup existing system config & create symlink
# ----------------------------
if [[ -e "$NVIM_CONFIG_DIR" && ! -L "$NVIM_CONFIG_DIR" ]]; then
    BACKUP_DIR="${NVIM_CONFIG_DIR}.backup.$(date +%Y%m%d_%H%M%S)"
    warn "Existing raw nvim config found at ${NVIM_CONFIG_DIR}"
    warn "Backing it up to ${BACKUP_DIR}"
    mv "$NVIM_CONFIG_DIR" "$BACKUP_DIR"
    
    # Also back up local share/state/cache dirs to avoid conflicts with old plugins
    for dir in "${HOME}/.local/share/nvim" "${HOME}/.local/state/nvim" "${HOME}/.cache/nvim"; do
        if [[ -d "$dir" ]]; then
            BACKUP="${dir}.backup.$(date +%Y%m%d_%H%M%S)"
            warn "Backing up ${dir} to ${BACKUP}"
            mv "$dir" "$BACKUP"
        fi
    done
elif [[ -L "$NVIM_CONFIG_DIR" ]]; then
    info "Removing old symlink at ${NVIM_CONFIG_DIR}"
    rm "$NVIM_CONFIG_DIR"
fi

info "Creating symlink: ${NVIM_CONFIG_DIR} -> ${REPO_CONFIG_DIR}"
ln -sfn "$REPO_CONFIG_DIR" "$NVIM_CONFIG_DIR"

# ----------------------------
# 5. Headless plugin install
# ----------------------------
info "Installing plugins (headless)..."
nvim --headless +qa

info "Done. Launch nvim to verify the setup."