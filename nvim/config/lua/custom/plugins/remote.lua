-- ==========================================================
-- DEVCONTAINERS & REMOTE SSH (VS Code Style)
-- ==========================================================
-- BEWARE : This repo is archived
vim.pack.add { 'https://github.com/amitds1997/remote-nvim.nvim' }

pcall(function()
  require('remote-nvim').setup {
    ssh_config = {
      scp_binary = 'rsync', -- I had a bug with scp
    },
    -- Configuration par défaut. Le plugin détecte automatiquement
    -- Docker, Podman et le devcontainers-cli.
    devcontainer = {
      auto_clean = true, -- Nettoie les fichiers temporaires à la déconnexion
    },
    client_callback = function(port, workspace_config)
      -- Commande pour lancer le client local qui se connecte au serveur du conteneur
      local cmd = ('terminator -x nvim --server localhost:%s --remote-ui'):format(port)
      vim.fn.jobstart(cmd, {
        detach = true,
        on_exit = function(j, c, e) vim.notify('Déconnecté du Devcontainer', vim.log.levels.INFO) end,
      })
    end,
  }

  -- Raccourci magique pour lancer la connexion
  vim.keymap.set('n', '<leader>rc', '<Cmd>RemoteStart<CR>', { desc = '[R]emote [C]onnect (SSH/Devcontainer)' })
end)
