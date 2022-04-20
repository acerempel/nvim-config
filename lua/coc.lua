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
  { 'go', '<Cmd>lua require("telescope").extensions.coc.document_symbols{}', 'Search document symbols' },
  { 'gO', 'showOutline', 'Show document outline' },
  { '<D-k>', 'definitionHover', 'Show definition' },
  { 'gt', 'jumpTypeDefinition', 'Go to type definition' },
  { 'gD', 'jumpDeclaration', 'Go to declaration' },
  { 'g]', '<Cmd>lua require("telescope").extensions.coc.references_used(require("telescope.themes").get_ivy({ layout_config = { height = 10 }, initial_mode = "normal" }))', 'Find references' },
  { 'gW', '<Cmd>lua require("telescope").extensions.coc.workspace_symbols{}', 'Search workspace symbols' },
  { '<Leader>kr', 'rename', 'Rename' },
  { '<Leader>kR', 'refactor', 'Refactor' },
  { '<Leader>dk', 'diagnosticInfo', 'Expand diagnostic under cursor' },
  { '<Leader>dl', 'diagnosticList', 'List all diagnostics' },
}

M.coc_buf_maps = function ()
  local bufnr = vim.api.nvim_get_current_buf()

  if not vim.fn.CocAction('ensureDocument') then
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

  local map_opts =  { silent = true, buffer = bufnr }

  if vim.fn.CocHasProvider('hover') then
    vim.keymap.set({'n', 'x'}, 'K', "<Cmd>call CocActionAsync('doHover')", map_opts)
  end

  if vim.fn.CocHasProvider('definition') then
    vim.keymap.set({'n', 'x'}, 'gd', "<Cmd>call CocActionAsync('jumpDefinition')", map_opts)
  end

  if vim.fn.CocHasProvider('codeAction') then
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'z=', '<Plug>(coc-codeaction-cursor)', {})
    vim.api.nvim_buf_set_keymap(bufnr, 'x', 'z=', '<Plug>(coc-codeaction-selected)', {})
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<M-D-.>', '<Plug>(coc-fix-current)', {})
  end

  vim.api.nvim_buf_set_keymap(bufnr, 'n', ']g', '<Plug>(coc-diagnostic-next)', {})
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '[g', '<Plug>(coc-diagnostic-prev)', {})

  if vim.fn.CocHasProvider('codeLens') then
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<D-CR>', "<Cmd>call CocActionAsync('codeLensAction')<CR>", { noremap = true })
  end

  vim.cmd [[
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

  if vim.fn.CocHasProvider('documentHighlight') then
    local highlight_autocmd = string.format(
      "autocmd coc_highlight CursorHold <buffer=%d> silent call CocActionAsync('highlight')",
      bufnr
    )
    vim.api.nvim_command(highlight_autocmd)
  end

  if vim.fn.CocHasProvider('formatRange') then
    vim.api.nvim_buf_set_option(bufnr, 'formatexpr', "CocActionAsync('formatSelected')")
  end
end

M.setup_coc_maps = function()
  vim.api.nvim_command('augroup coc_config')
  vim.api.nvim_command('au!')
  vim.api.nvim_command [[au FileType * lua require("coc").coc_buf_maps()]]
  vim.api.nvim_command('augroup END')
  vim.cmd [[
    augroup coc_highlight
    au!
    augroup END
  ]]

  local bufs = vim.api.nvim_list_bufs()
  for _, buf in ipairs(bufs) do
    vim.api.nvim_buf_call(buf, M.coc_buf_maps)
  end
end

return M
