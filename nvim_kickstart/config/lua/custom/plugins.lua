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
