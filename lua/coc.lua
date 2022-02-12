local M = {}

local util = require('util')

M.tab = function ()
  if vim.fn.pumvisible() == 1 then
    return util.term('<C-n>')
  elseif util.check_back_space() then
    return util.term('<Tab>')
  elseif vim.fn['coc#expandableOrJumpable']() then
    return util.term("<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])<CR>")
  else
    return vim.fn['coc#refresh']()
  end
end

M.s_tab = function ()
  if vim.fn.pumvisible() == 1 then
    return util.term('<C-p>')
  elseif util.check_back_space() then
    return util.term('<S-Tab>')
  else
    return util.term('<C-d>')
  end
end

M.coc_map_config = {
  { 'K', 'doHover', 'Show documentation' },
  { 'gd', 'jumpDefinition', 'Go to definition' },
  { 'go', '<Cmd>CocList outline', 'Search document symbols' },
  { 'gO', 'showOutline', 'Show document outline' },
  { '<Leader>kd', 'definitionHover', 'Show definition' },
  { 'gt', 'jumpTypeDefinition', 'Go to type definition' },
  { 'gD', 'jumpDeclaration', 'Go to declaration' },
  { 'g]', '<Cmd>CocList references', 'Search references' },
  { 'g}', 'jumpReferences', 'Go to references' },
  { 'gW', '<Cmd>CocList symbols', 'Search workspace symbols' },
  { '<Leader>kr', 'rename', 'Rename' },
  { '<Leader>kR', 'refactor', 'Refactor' },
  { '<Leader>dk', 'diagnosticInfo', 'Expand diagnostic under cursor' },
  { '<Leader>dl', 'diagnosticList', 'List all diagnostics' },
}

--[[ local filetypes = {}

M.coc_update_fts = function ()
  local services = vim.fn.CocAction('services')
  for _, service in ipairs(services) do
    print(vim.inspect(service.languageIds))
    for _, ft in ipairs(service.languageIds) do
      filetypes[ft] = true
    end
  end
end ]]

M.coc_buf_maps = function (bufnr)
  if not vim.api.nvim_buf_call(bufnr, function() return vim.fn.CocAction('ensureDocument') end) then
    return nil
  end
  local whichkey = require('which-key')
  local mappings = {}
  for _, map in ipairs(M.coc_map_config) do
    local command = ''
    if type(map[2]) == "string" and vim.startswith(map[2], '<Cmd>') then
      command = map[2] .. '<CR>'
    else
      local action
      if type(map[2]) == "table" then
        local action_args = {}
        for _, arg in ipairs(map[2]) do
          table.insert(action_args, "'" .. arg .. "'")
        end
        action = table.concat(action_args, ', ')
      else
        action = "'" .. map[2] .. "'"
      end
      command = '<Cmd>call CocActionAsync(' .. action .. ')<CR>'
    end
    mappings[map[1]] = { command, map[3] }
  end
  whichkey.register(mappings, { buffer = bufnr })
  whichkey.register(mappings, { buffer = bufnr, mode = 'v' })
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'z=', '<Plug>(coc-codeaction-cursor)', {})
  vim.api.nvim_buf_set_keymap(bufnr, 'x', 'z=', '<Plug>(coc-codeaction-selected)', {})
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<S-D-.>', '<Plug>(coc-fix-current)', {})
  vim.api.nvim_buf_set_keymap(bufnr, 'n', ']g', '<Plug>(coc-diagnostic-next)', {})
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '[g', '<Plug>(coc-diagnostic-prev)', {})
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<D-CR>', "<Cmd>call CocActionAsync('codeLensAction')<CR>", { noremap = true })

  vim.cmd [[
  " inoremap <silent><expr> <TAB>
  "       \ pumvisible() ? "\<C-n>" :
  "       \ v:lua.require'util'.check_back_space() ? "\<TAB>" :
  "       \ coc#refresh()
  inoremap <silent><buffer><expr> <Tab> luaeval("require('coc').tab()")
  inoremap <silent><buffer><expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<S-Tab>"
  inoremap <silent><buffer><expr> <C-Space> coc#refresh()
  snoremap <silent><buffer><expr> <Tab> luaeval("require('coc').tab()")
  snoremap <silent><buffer><expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<S-Tab>"
  snoremap <silent><buffer><expr> <C-Space> coc#refresh()

  " Make <CR> auto-select the first completion item and notify coc.nvim to
  " format on enter
  inoremap <silent><buffer><expr> <cr> pumvisible() ? coc#_select_confirm()
                                \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
  snoremap <silent><buffer><expr> <cr> pumvisible() ? coc#_select_confirm()
                                \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
  ]]

  vim.api.nvim_buf_set_option(bufnr, 'formatexpr', "CocActionAsync('formatSelected')")

  vim.api.nvim_buf_set_var(bufnr, 'coc_did_mappings', true)
end

local command = vim.api.nvim_command

M.setup_coc_maps = function()
  local extensions = vim.fn.CocAction('extensionStats')
  local filetypes = { haskell = true }
  for _, ext in ipairs(extensions) do
    for _, event in ipairs(ext.packageJSON.activationEvents) do
      local ft_match = event:match('^onLanguage:([%w%._-]+)$')
      if ft_match then
        filetypes[ft_match] = true
      elseif ext.id == 'coc-html' then
        filetypes['html'] = true
      end
    end
  end
  local fts_pat = table.concat(vim.tbl_keys(filetypes), ',')
  command('augroup coc_buf_config')
  command('au!')
  local fts_autocmd = [[au FileType %s call luaeval('require("coc").coc_buf_maps(_A+0)', expand('<abuf>'))]]
  command(string.format(fts_autocmd, fts_pat))
  command([[autocmd CursorHold * silent call CocActionAsync('highlight')]])
  command('augroup END')
  local bufs = vim.api.nvim_list_bufs()
  for _, buf in ipairs(bufs) do
    local ft = vim.api.nvim_buf_get_option(buf, 'filetype')
    if filetypes[ft] then
      M.coc_buf_maps(buf)
    end
  end
end

return M
