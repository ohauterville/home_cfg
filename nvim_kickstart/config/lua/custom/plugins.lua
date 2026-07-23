-- 1. File Explorer (Neo-tree)
vim.pack.add {
  'https://github.com/nvim-neo-tree/neo-tree.nvim',
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/nvim-tree/nvim-web-devicons',
  'https://github.com/MunifTanjim/nui.nvim',
}

require('neo-tree').setup {
  close_if_last_window = true,
  window = { width = 30 },
  filesystem = {
    filtered_items = {
      visible = true,
      hide_dotfiles = true,
      hide_gitignored = false,
    },
  },
}
vim.keymap.set('n', '<leader>e', '<Cmd>Neotree toggle<CR>', { desc = 'Toggle [E]xplorer' })

-- 2. Integrated Terminal (Toggleterm)
vim.pack.add { 'https://github.com/akinsho/toggleterm.nvim' }

require('toggleterm').setup {
  size = 15,
  open_mapping = [[<c-\>]],
  direction = 'horizontal',
}

vim.keymap.set('n', '<leader>i', function()
  vim.cmd 'Neotree show'
  vim.cmd 'ToggleTerm'
  vim.cmd 'wincmd k'
  print 'IDE Mode activated!'
end, { desc = 'Activate [I]DE Layout (VS Code style)' })

-- 3. nvim-ros2
vim.pack.add {
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/nvim-telescope/telescope.nvim',
  'https://github.com/nvim-treesitter/nvim-treesitter',
  'https://github.com/ErickKramer/nvim-ros2',
}

require('nvim-ros2').setup {
  picker = 'telescope',
  autocmds = true,
  treesitter = true,
  tuner = true,
  tuner_match_mode = 'smart',
  tuner_open_mode = 'hide',
}

-- ==========================================================
-- (Conversion de la section "config") : Autocommands RPC
-- ==========================================================
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "ROS_CALL_*",
  callback = function(args)
    local bufnr = args.buf
    local map_opts = { buffer = bufnr, silent = true }

    -- Execute the payload
    vim.keymap.set("n", "<CR>", "<cmd>RosRpc send<CR>", vim.tbl_extend("force", map_opts, { desc = "Send RPC Call" }))
    -- Gracefully cancel
    vim.keymap.set("n", "s", "<cmd>RosRpc stop<CR>", vim.tbl_extend("force", map_opts, { desc = "Stop RPC Call" }))
    -- Save with metadata
    vim.keymap.set("n", "<leader>s", "<cmd>RosRpc save<CR>", vim.tbl_extend("force", map_opts, { desc = "Save Payload" }))
    -- Smart Load compatible payloads
    vim.keymap.set("n", "<leader>l", function() require("nvim-ros2.pickers").saved_payloads() end, vim.tbl_extend("force", map_opts, { desc = "Load Payload" }))
    -- Quick exit
    vim.keymap.set("n", "q", "<cmd>q<CR>", vim.tbl_extend("force", map_opts, { desc = "Close RPC Buffer" }))
  end,
})

-- ==========================================================
-- (Conversion de la section "keys") : Raccourcis globaux
-- ==========================================================
-- Base Pickers
vim.keymap.set("n", "<leader>li", function() require("nvim-ros2").pickers.interfaces() end, { desc = "[ROS 2]: List interfaces" })
vim.keymap.set("n", "<leader>ln", function() require("nvim-ros2").pickers.nodes() end, { desc = "[ROS 2]: List nodes" })
vim.keymap.set("n", "<leader>la", function() require("nvim-ros2").pickers.actions() end, { desc = "[ROS 2]: List actions" })
vim.keymap.set("n", "<leader>lt", function() require("nvim-ros2").pickers.topics_info() end, { desc = "[ROS 2]: List topics with info" })
vim.keymap.set("n", "<leader>le", function() require("nvim-ros2").pickers.topics_echo() end, { desc = "[ROS 2]: List topics with echo" })
vim.keymap.set("n", "<leader>ls", function() require("nvim-ros2").pickers.services() end, { desc = "[ROS 2]: List services" })

-- Workspace Navigator
vim.keymap.set("n", "<leader>fp", function() require("nvim-ros2").pickers.packages() end, { desc = "[F]ind ROS2 [P]ackage" })
vim.keymap.set("n", "<leader>pf", function() require("nvim-ros2").pickers.find_files_package() end, { desc = "Find in Package" })
vim.keymap.set("n", "<leader>pg", function() require("nvim-ros2").pickers.grep_package() end, { desc = "Grep in Package" })
vim.keymap.set("n", "<leader>pc", function() require("nvim-ros2").pickers.edit_cmake() end, { desc = "Edit CMakeLists.txt" })
vim.keymap.set("n", "<leader>pp", function() require("nvim-ros2").pickers.edit_package_xml() end, { desc = "Edit package.xml" })

-- Snipers
vim.keymap.set("n", "<leader>pm", function() require("nvim-ros2").pickers.sniper("msg") end, { desc = "Sniper: msg/" })
vim.keymap.set("n", "<leader>ps", function() require("nvim-ros2").pickers.sniper("srv") end, { desc = "Sniper: srv/" })
vim.keymap.set("n", "<leader>pa", function() require("nvim-ros2").pickers.sniper("action") end, { desc = "Sniper: action/" })
vim.keymap.set("n", "<leader>pi", function() require("nvim-ros2").pickers.sniper("include") end, { desc = "Sniper: include/" })

-- Tuner
vim.keymap.set("n", "<leader>rt", "<cmd>RosTune<cr>", { desc = "Start ROS Tuner" })
vim.keymap.set("n", "<leader>rs", "<cmd>RosTune resync<CR>", { desc = "[T]uner [R]esync" })
vim.keymap.set("n", "<leader>rp", "<cmd>RosTune resync --pull<CR>", { desc = "[T]uner [P]ull Missing Params" })