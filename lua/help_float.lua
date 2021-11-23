local M = {}

local buf_set_option = vim.api.nvim_buf_set_option

local auto_close = true
local win = nil
local win_config = {
  relative = "cursor",
  width = 67, height = 10,
  row = 0, col = 0,
  zindex = 50,
  style = 'minimal',
  noautocmd = true,
}

M.open = function()
  M.close()
  local word = vim.fn.expand('<cword>')
  -- Unlisted, not scratch
  local buf = vim.api.nvim_create_buf(false, false)
  buf_set_option(buf, 'buftype', 'help')
  buf_set_option(buf, 'filetype', 'help')
  win = vim.api.nvim_open_win(buf, false, win_config)
  if win == 0 then
    vim.api.nvim_err_writeln('Could not open window')
    win = nil
    return
  end
  local exists, _ = pcall(function()
    vim.api.nvim_buf_call(buf, function ()
      vim.api.nvim_command("help " .. word)
    end)
  end)
  if not exists then
    M.close()
    vim.api.nvim_err_writeln('No help for ' .. word)
    return
  end
  if auto_close then
    vim.api.nvim_command(
      'autocmd help_float CursorMoved,CursorMovedI,InsertEnter,BufLeave,WinClosed <buffer> ++once lua require"help_float".close()'
    )
  end
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

  if options.win_config ~= nil then
    win_config = vim.tbl_extend(win_config, options.win_config, "force")
  end
  if options.auto_close ~= nil then
    auto_close = options.auto_close
  end
end

return M
