local lspconfig = require('lspconfig')
local util = require('lspconfig.util')

lspconfig.intelephense.setup {
  root_dir = util.root_pattern("composer.json")
}
