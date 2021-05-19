vim.o.completeopt = "menuone,noselect"

require('compe').setup {
  autocomplete = false,
  source = {
    path = true, buffer = true,
    nvim_lsp = true, nvim_lua = true,
    vsnip = true,
  }
}

vim.g.closer_no_mappings = 1

vim.cmd [[
  inoremap <silent><expr> <C-Space> compe#complete()
  inoremap <silent><expr> <CR>      compe#confirm('<CR><C-R>=closer#close()<CR>')
  inoremap <silent><expr> <C-e>     compe#close('<C-e>')
  inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
  inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })
]]
