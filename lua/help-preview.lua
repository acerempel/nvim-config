local M = {}

local api = vim.api

function help_preview(word)
  word = word or vim.fn.expand("<cword>")
  local buf = api.nvim_create_buf(false, false) -- Not listed, not scratch
  api.nvim_buf_set_option(buf, 'modifiable', false)
  api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
  api.nvim_buf_set_option(buf, 'filetype', 'help')
  api.nvim_buf_set_option(buf, 'buftype', 'help')
  local cur_buf = api.nvim_get_current_buf()
  api.nvim_set_current_buf(buf)
  api.nvim_command('help ' .. word)
  local help_buf = api.nvim_get_current_buf()
  api.nvim_set_current_buf(cur_buf)

  local win_config = {
    relative = 'cursor',
    bufpos = { 0, 0 },
    width = 78,
    height = 15,
    style = 'minimal',
  }
  local win = api.nvim_open_win(help_buf, false, win_config)
  local events = {"CursorMoved", "CursorMovedI", "BufHidden", "BufLeave"}
  api.nvim_command("autocmd "..table.concat(events, ',').." <buffer> ++once lua pcall(vim.api.nvim_win_close, "..win..", true)")
end

M.help_preview = help_preview

return M
