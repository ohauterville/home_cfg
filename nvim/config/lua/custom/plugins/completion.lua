-- ==========================================================
-- AUTOCOMPLÉTION & SNIPPETS
-- ==========================================================
-- 1. Téléchargement des plugins
vim.pack.add {
  'https://github.com/hrsh7th/nvim-cmp',
  'https://github.com/hrsh7th/cmp-nvim-lsp',
  'https://github.com/L3MON4D3/LuaSnip',
  'https://github.com/saadparwaiz1/cmp_luasnip',
  'https://github.com/rafamadriz/friendly-snippets',
}

-- 2. Chargement des snippets préconfigurés (friendly-snippets)
-- pcall évite un crash si le plugin n'est pas encore téléchargé
-- pcall(function()
  -- Charge les snippets communautaires (friendly-snippets)
  require("luasnip.loaders.from_vscode").lazy_load()
  -- Charge my own local snippets
  require("luasnip.loaders.from_vscode").lazy_load({ 
    paths = { vim.fn.stdpath("config") .. "/lua/custom/snippets" } 
  })
-- end)

-- 3. Configuration du moteur d'autocomplétion
pcall(function()
  local cmp = require('cmp')
  local luasnip = require('luasnip')

  cmp.setup({
    -- Indique à nvim-cmp d'utiliser LuaSnip pour étendre les snippets
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    
    -- Raccourcis clavier pour le menu déroulant
    mapping = cmp.mapping.preset.insert({
      ['<C-n>'] = cmp.mapping.select_next_item(), -- Suivant (Next)
      ['<C-p>'] = cmp.mapping.select_prev_item(), -- Précédent (Previous)
      ['<C-y>'] = cmp.mapping.confirm { select = true }, -- Valider (Yes)
      ['<C-Space>'] = cmp.mapping.complete(), -- Forcer l'ouverture du menu
      
      -- Comportement intelligent avec la touche Tab
      ['<Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_locally_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end, { 'i', 's' }),
      
      ['<S-Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.locally_jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { 'i', 's' }),
    }),

    -- Sources d'où proviennent les suggestions
    sources = cmp.config.sources({
      { name = 'nvim_lsp' }, -- Suggestions intelligentes du serveur de langage (C++, Python...)
      { name = 'luasnip' },  -- Snippets
    })
  })
end)

vim.pack.add({
  { src = "https://github.com/benfowler/telescope-luasnip.nvim" },
})
require('telescope').load_extension('luasnip')
vim.keymap.set('n', '<leader>sn', '<cmd>Telescope luasnip<cr>', { desc = '[S]nippets [S]earch' })