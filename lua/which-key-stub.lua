local M = {}

local function keymap(key, map, options)
  if vim.tbl_islist(map) and map[1] and map[2] then
    local rhs = map[1]
    local lhs = (options.prefix or '') .. key
    local mode = options.mode or 'n'
    local noremap = (not vim.startswith(rhs, '<Plug>')) and (options.noremap == nil and true or options.noremap)
    local expr = options.expr == nil and false or options.expr
    local silent = options.silent == nil and false or options.silent
    local map_options = {
      noremap = noremap, expr = expr,
      silent = silent
    }
    if options.buffer then
      vim.api.nvim_buf_set_keymap(options.buffer, mode, lhs, rhs, map_options)
    else
      vim.api.nvim_set_keymap(mode, lhs, rhs, map_options)
    end
  elseif type(map) == "table" then
    options.prefix = (options.prefix or '') .. key
    for subkey, submap in pairs(map) do
      keymap(subkey, submap, options)
    end
  end
end

function M.register (mappings, options)
  options = options or {}
  for key, value in pairs(mappings) do
    keymap(key, value, options)
  end
end

return M
