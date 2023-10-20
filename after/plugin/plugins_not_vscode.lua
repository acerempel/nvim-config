if vim.g.pager == nil then
  local plugins = {
    'nvim-autopairs',
    'yanky.nvim',
    'substitute',
    'nvim-gps',
    'lualine',
    'persisted',
  }
  require('packer.load')(plugins, {}, _G.packer_plugins, false)
else
  vim.api.nvim_command("set laststatus=1")
  return
end

if vim.g.simplicity == nil then
  local plugins = {
    "vim-eunuch",
    "plenary.nvim",
    "replacer.nvim",
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
    'lspconfig', 'lsp-installer', 'lsp_signature',
    'rust-tools', 'fidget', 'lightbulb',
  }
  require('packer.load')(plugins, {}, _G.packer_plugins, false)
else
  vim.api.nvim_command("set laststatus=1")
end
