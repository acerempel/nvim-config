if vim.g.simplicity == nil then
  local plugins = {
    "plenary.nvim",
    "which-key",
    "registers.nvim",
    "cokeline",
    "pqf", "vim-qf", "fastfold",
    "telescope",
    "vim-fugitive",
    "gitsigns.nvim",
    "Comment",
    "vim-matchup",
    "LuaSnip",
    "nvim-cmp", "cmp-nvim-lsp", "cmp_luasnip",
    "lspconfig",
    "renamer",
  }
  require('packer.load')(plugins, {}, _G.packer_plugins, false)
end

if vim.g.simplicity ~= nil then
  vim.api.nvim_command("set laststatus=1")
end
