vim.o.completeopt = "menuone,noselect"

require('compe').setup {
  autocomplete = false,
  source = {
    path = true, buffer = true,
    nvim_lsp = true, nvim_lua = true,
  }
}

vim.cmd [[
  inoremap <silent><expr> <C-Space> compe#complete()
  inoremap <silent><expr> <CR>      compe#confirm({ 'keys': "\<Plug>delimitMateCR", 'select': v:true, 'mode': '' })
  inoremap <silent><expr> <C-e>     compe#close('<C-e>')
  inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
  inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })
]]

-- Use tab and shift-tab
local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn['compe#complete']()
  end
end

_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  else
    return t "<S-Tab>"
  end
end

_G.snip_expand_or_jump = function()
  if vim.fn["vsnip#available"]({1}) == 1 then
    return t "<Plug>(vsnip-expand-or-jump)"
  else
    vim.cmd 'echomsg "No snippet available!"'
    return ''
  end
end

_G.snip_jump_prev = function()
  if vim.fn["vsnip#jumpable"]({-1}) == 1 then
    return t "<Plug>(vsnip-jump-prev)"
  else
    vim.cmd 'echomsg "No snippet jumpable!"'
    return ''
  end
end

vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "…", "v:lua.snip_expand_or_jump()", {expr = true})
vim.api.nvim_set_keymap("i", "æ", "v:lua.snip_jump_prev()", {expr = true})
