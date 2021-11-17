if vim.g.vscode == nil then
  local plugins = {
    "plenary.nvim", "pqf", "vim-qf", "fastfold", "auto-session",
    "which-key.nvim", "registers.nvim", "vim-fugitive", "vim-rhubarb",
    "gitsigns.nvim", "nvim-nonicons", "zenbones.nvim",
    "nvim-lspconfig", "auto_pairs", "LuaSnip", "nvim-cmp",
  }
  require('packer.load')(plugins, {}, _G.packer_plugins, false)
end
