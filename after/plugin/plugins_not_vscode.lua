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
  }
  require('packer.load')(plugins, {}, _G.packer_plugins, false)
end

if vim.g.simplicity ~= nil then
  vim.api.nvim_command("set laststatus=1")
end
