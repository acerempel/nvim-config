if vim.g.vscode == nil then
  local plugins = {
    "nvim-nonicons",
    "lush", "zenbones",
    "lualine",
    "registers.nvim",
    "auto_pairs",
    "fzf",
    "bufferline",
  }
  require('packer.load')(plugins, {}, _G.packer_plugins, false)
else
  vim.api.nvim_command("set laststatus=0")
end

if vim.g.simplicity == nil and vim.g.vscode == nil then
  local plugins = {
    "plenary.nvim", "pqf", "vim-qf", "fastfold",
    "telescope",
    "vim-fugitive", "vim-rhubarb",
    "gitsigns.nvim",
    "coc",
    "fzf-preview",
    "which-key",
    "Comment",
    "vim-matchup",
  }
  require('packer.load')(plugins, {}, _G.packer_plugins, false)
end
