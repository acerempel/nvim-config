if vim.g.vscode == nil then
  local plugins = {
    "nvim-nonicons",
    "newpaper",
    "lualine",
    "which-key.nvim", "registers.nvim",
    "auto_pairs",
    "fzf",
  }
  require('packer.load')(plugins, {}, _G.packer_plugins, false)
else
  vim.api.nvim_command("set laststatus=0")
end

if vim.g.simplicity == nil and vim.g.vscode == nil then
  local plugins = {
    "plenary.nvim", "pqf", "vim-qf", "fastfold", "auto-session",
    "vim-fugitive", "vim-rhubarb",
    "gitsigns.nvim",
    "coc",
    "fzf-preview",
    "bufferline",
  }
  require('packer.load')(plugins, {}, _G.packer_plugins, false)
end
