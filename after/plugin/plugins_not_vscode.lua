if vim.g.simplicity == nil then
  local plugins = {
    "registers.nvim",
    "cokeline",
    "plenary.nvim", "pqf", "vim-qf", "fastfold",
    "telescope",
    "vim-fugitive",
    "which-key",
    "gitsigns.nvim",
    "Comment",
    "vim-matchup",
    "nvim-cmp",
    "lspconfig",
    "renamer",
  }
  require('packer.load')(plugins, {}, _G.packer_plugins, false)
  require('lsp')
end

if vim.g.simplicity ~= nil then
  vim.api.nvim_command("set laststatus=1")
end
