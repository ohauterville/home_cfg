return {
  -- 1. File Explorer (Neo-tree)
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({
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
      -- Optional shortcut to just toggle the explorer
      vim.keymap.set('n', '<leader>e', '<Cmd>Neotree toggle<CR>', { desc = 'Toggle [E]xplorer' })
    end,
  },

  -- 2. Integrated Terminal (Toggleterm)
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        size = 15,
        open_mapping = [[<c-\>]], -- Ctrl + \ to toggle terminal quickly
        direction = 'horizontal',
      })

      -- 3. THE MAGIC IDE SHORTCUT (Space + i)
      vim.keymap.set('n', '<leader>i', function()
        -- Open Neo-tree on the left
        vim.cmd('Neotree show')
        -- Open terminal at the bottom
        vim.cmd('ToggleTerm')
        -- Move cursor back to the main code window
        vim.cmd('wincmd k')
        print("IDE Mode activated!")
      end, { desc = 'Activate [I]DE Layout (VS Code style)' })
    end,
  }
}
