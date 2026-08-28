-- ==========================================================
-- BARRE D'ONGLETS POUR LES BUFFERS (Look VS Code)
-- ==========================================================
vim.pack.add { 
  'https://github.com/akinsho/bufferline.nvim',
  'https://github.com/nvim-tree/nvim-web-devicons' -- (Déjà installé normalement)
}

pcall(function()
  local bufferline = require("bufferline")
  bufferline.setup({
    options = {
      mode = "buffers", -- Affiche les buffers (pas les vrais tabs de Vim)
      diagnostics = "nvim_lsp", -- Affiche une petite icône rouge s'il y a une erreur dans un fichier !
      offsets = {
        {
          filetype = "neo-tree",
          text = "File Explorer",
          highlight = "Directory",
          separator = true -- Aligne proprement la barre avec l'explorateur sur la gauche
        }
      }
    }
  })

  -- Raccourcis pour naviguer rapidement avec Majuscule + H ou L
  vim.keymap.set('n', '<S-h>', '<Cmd>BufferLineCyclePrev<CR>', { desc = 'Buffer précédent' })
  vim.keymap.set('n', '<S-l>', '<Cmd>BufferLineCycleNext<CR>', { desc = 'Buffer suivant' })
  -- Raccourci pour fermer le fichier actuel (Espace + c)
  vim.keymap.set('n', '<leader>c', '<Cmd>bd<CR>', { desc = '[C]lose Buffer' })
end)
