if vim.g.vscode == nil then
  local plugins = {
    "nvim-nonicons",
    "lush", "zenbones",
    "nvim-autopairs",
    "lualine",
  }
  require('packer.load')(plugins, {}, _G.packer_plugins, false)
end

if vim.g.simplicity == nil and vim.g.vscode == nil then
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
  }
  require('packer.load')(plugins, {}, _G.packer_plugins, false)
  require('lsp')
end

if vim.g.simplicity ~= nil then
  vim.api.nvim_command("set laststatus=1")
end
