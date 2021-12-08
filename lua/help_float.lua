local M = {}

local buf_set_option = vim.api.nvim_buf_set_option

local auto_close = true
local win, win_config
local default_win_config = {
  relative = "cursor",
  width = 67, height = 10,
  row = 0, col = 0,
  zindex = 50,
  style = 'minimal',
  noautocmd = true,
}

local taglist_buf

local function create_buf()
  -- Unlisted, not scratch
  local buf = vim.api.nvim_create_buf(false, false)
  buf_set_option(buf, 'buftype', 'help')
  buf_set_option(buf, 'filetype', 'help')
  return buf
end

local did_setup

local function ensure_setup()
  return did_setup or M.setup()
end

M.open = function()
  ensure_setup()
  M.close()

  local word = vim.fn.expand('<cword>')
  -- Sometimes a keyword that could reference a help tag is enclosed in
  -- backticks – ignore those.
  local match = word:match('^`([^`]*)`$')
  if match ~= nil then word = match
  else
    -- Ignore trailing punctuation for option names (because the delimiters,
    -- single quotes, are keyword characters too, unlike bars) – note the lack
    -- of $ at the end of the pattern.
    match = word:match("^'(%w+)'")
    if match ~= nil then word = match end
  end

  local tags = vim.api.nvim_buf_call(taglist_buf, function()
    return vim.fn.taglist('\\V\\^' .. word .. '\\$')
  end)
  local nonempty, tag = next(tags)
  if not nonempty then
    vim.api.nvim_err_writeln('No help for ' .. word)
    return
  end

  local buf = vim.fn.bufadd(tag.filename)
  vim.fn.bufload(buf)

  local prev_shortmess = vim.o.shortmess
  vim.opt.shortmess:append('F')
  win = vim.api.nvim_open_win(buf, false, win_config)
  vim.o.shortmess = prev_shortmess

  if win == 0 then
    vim.api.nvim_err_writeln('Could not open window')
    win = nil
    return
  end

  if auto_close then
    vim.api.nvim_command(
      'autocmd help_float CursorMoved,CursorMovedI,InsertEnter,BufLeave,WinClosed <buffer> ++once lua require"help_float".close()'
    )
  end

  vim.api.nvim_win_set_option(win, 'scrolloff', 0)
  vim.api.nvim_win_set_option(win, 'sidescrolloff', 0)

  vim.api.nvim_win_call(win, function()
    local cmd = tag.cmd
    if cmd:sub(1,1) == '/' then
      vim.fn.search('\\V' .. cmd:sub(2, -1), 'w')
    else
      vim.api.nvim_command(cmd)
    end
    vim.api.nvim_command('normal! zt')
  end)
end

M.close = function()
  if win then
    vim.api.nvim_win_close(win, false)
    win = nil
  end
end

M._on_win_closed = function ()
  if win ~= nil and tonumber(vim.fn.expand('<afile>')) == win then
    win = nil
  end
end

M.setup = function (options)
  vim.cmd [[
    augroup help_float
    autocmd!
    autocmd WinClosed * lua require"help_float"._on_win_closed()
    augroup END
  ]]

  if options == nil then
    options = {}
  end
  win_config = vim.tbl_extend("force", default_win_config, options.win_config or {})
  if options.auto_close ~= nil then
    auto_close = options.auto_close
  end

  taglist_buf = create_buf()

  did_setup = true
end

return M
