-- ==========================================================
-- AUTO-FORMATAGE (Conform.nvim)
-- ==========================================================
vim.pack.add { 'https://github.com/stevearc/conform.nvim' }

pcall(function()
  require('conform').setup({
    -- Configuration du formatage automatique à la sauvegarde
    format_on_save = {
      timeout_ms = 500,
      lsp_format = "fallback", -- Utilise le formateur externe d'abord, sinon utilise le LSP
    },
    
    -- Assignation des formateurs par langage
    formatters_by_ft = {
      -- Python : On utilise d'abord isort (pour trier les imports) puis black (pour le code)
      python = { "isort", "black" },
      
      -- C / C++ : On utilise le standard clang-format
      c = { "clang-format" },
      cpp = { "clang-format" },
      
      -- Bonus : Formatage des fichiers CMake
      cmake = { "cmake_format" },
    },
  })

  -- Raccourci optionnel pour forcer le formatage manuellement (Espace + f)
  vim.keymap.set({ 'n', 'v' }, '<leader>f', function()
    require('conform').format({ async = true, lsp_fallback = true })
  end, { desc = '[F]ormatter le buffer' })
end)
