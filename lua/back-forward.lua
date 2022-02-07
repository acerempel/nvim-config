local M = {}

local stack = {}
local pos = 0

function M.back()
  if pos > 1 then
    local prev_pos = pos - 1
    vim.api.nvim_set_current_buf(stack[prev_pos])
    pos = prev_pos
  else
    vim.api.nvim_err_writeln("Cannot go back")
  end
end

function M.forward()
  local next_pos = pos + 1
  if stack[next_pos] ~= nil then
    vim.api.nvim_set_current_buf(stack[next_pos])
    pos = next_pos
  else
    vim.api.nvim_err_writeln("Cannot go forward")
  end
end

function M.setup()
  vim.cmd [[
    augroup backforward
    au!
    au BufEnter * call luaeval('require("back-forward").push(_A)', +expand('<abuf>'))
    augroup END
  ]]
end

---@param bufnr number
function M.push(bufnr)
  if vim.api.nvim_buf_get_option(bufnr, 'buftype') == 'quickfix' then return end
  if pos and stack[pos] == bufnr then return end
  pos = pos + 1
  table.insert(stack, pos, bufnr)
end
