function keys(ks)
  vim.api.nvim_feedkeys(ks, 'n', true)
end

local M = {}

M.coc_tab = function ()
  if vim.fn.pumvisible() == 1 then
    keys(term('<C-n>'))
  elseif check_back_space() then
    keys(term('<Tab>'))
  else
    vim.fn['coc#start']()
  end
end

M.coc_map_config = {
  { 'K', 'doHover', 'Show documentation' },
  { 'gd', 'jumpDefinition', 'Go to definition' },
  { 'go', '<Cmd>CocList symbols', 'Search workspace symbols' },
  { 'gO', 'showOutline', 'Show document outline' },
  { '<Leader>kd', 'definitionHover', 'Show definition' },
  { 'gt', 'jumpTypeDefinition', 'Go to type definition' },
  { 'gD', 'jumpDeclaration', 'Go to declaration' },
  { 'g]', '<Cmd>CocList references', 'Search references' },
  { 'g}', 'jumpReferences', 'Go to references' },
  { '<Leader>kr', 'rename', 'Rename' },
  { '<Leader>kR', 'refactor', 'Refactor' },
  { '<Leader>dk', 'diagnosticInfo', 'Expand diagnostic under cursor' },
  { '<Leader>dl', 'diagnosticList', 'List all diagnostics' },
}

filetypes = {}

M.coc_update_fts = function ()
  local services = vim.fn.CocAction('services')
  for _, service in ipairs(services) do
    print(vim.inspect(service.languageIds))
    for _, ft in ipairs(service.languageIds) do
      filetypes[ft] = true
    end
  end
end

M.coc_buf_maps = function (bufnr)
  if not vim.api.nvim_buf_call(bufnr, function() return vim.fn.CocAction('ensureDocument') end) then
    vim.cmd([[echom 'Document not COCified ]] .. bufnr .. [[']])
    return nil
  end
  local whichkey = require('which-key')
  local mappings = {}
  for _, map in ipairs(M.coc_map_config) do
    local command = ''
    if vim.startswith(map[2], '<Cmd>') then
      command = map[2] .. '<CR>'
    else
      command = '<Cmd>call CocActionAsync("' .. map[2] .. '")<CR>'
    end
    mappings[map[1]] = { command, map[3] }
  end
  whichkey.register(mappings, { buffer = bufnr })
  vim.api.nvim_buf_set_var(bufnr, 'coc_did_mappings', true)
end

M.setup_coc_maps = function()
  vim.api.nvim_command [[echom 'Setting up COC mappings']]
  local extensions = vim.fn.CocAction('extensionStats')
  local filetypes = {}
  for _, ext in ipairs(extensions) do
    for _, event in ipairs(ext.packageJSON.activationEvents) do
      local ft_match = event:match('^onLanguage:([%w%._-]+)$')
      if ft_match then
        filetypes[ft_match] = true
      end
    end
  end
  local fts_pat = table.concat(vim.tbl_keys(filetypes), ',')
  vim.api.nvim_command(
    string.format([[au FileType %s call luaeval('coc_buf_maps(_A+0)', expand('<abuf>'))]], fts_pat)
  )
  local bufs = vim.api.nvim_list_bufs()
  for _, buf in ipairs(bufs) do
    local ft = vim.api.nvim_buf_get_option(buf, 'filetype')
    if filetypes[ft] then
      M.coc_buf_maps(buf)
    end
  end
end

vim.cmd [[
" inoremap <silent><expr> <TAB>
"       \ pumvisible() ? "\<C-n>" :
"       \ <SID>check_back_space() ? "\<TAB>" :
"       \ coc#refresh()
inoremap <Tab> <Cmd>lua require('coc').coc_tab()<CR>
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter
" inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
"                               \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
]]

return M
