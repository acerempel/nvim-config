if vim.g.vscode == nil then
  local plugins = {
    "plenary.nvim", "pqf", "vim-qf", "fastfold", "auto-session",
    "which-key.nvim", "registers.nvim", "vim-fugitive", "vim-rhubarb",
    "gitsigns.nvim", "nvim-nonicons", "zenbones.nvim",
    "auto_pairs",
    "bufferline",
    "coc",
    "fzf",
    "fzf-preview",
    "chadtree",
  }
  require('packer.load')(plugins, {}, _G.packer_plugins, false)
end
