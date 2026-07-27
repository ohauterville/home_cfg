-- lua/custom/plugins/cursor-anim.lua

vim.pack.add({
  { src = "https://github.com/sphamba/smear-cursor.nvim" },
})

require("smear_cursor").setup({
  stiffness = 0.6,
  trailing_stiffness = 0.4,
  --distance_stop_animating = 0.5,
  hide_target_hack = true,
  --legacy_computing_symbols_support = true, -- utile en terminal (alacritty/wezterm), sinon désactive
   -- color for catppuccin mocha
  cursor_color = '#f5c2e7', -- pink de catppuccin, ou 'none' pour hériter du curseur natif
})