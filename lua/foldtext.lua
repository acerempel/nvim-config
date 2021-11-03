str_remove = function(str, thing)
  istart, iend = str:find(thing, 1, true)
  if istart == nil then return str end
  before = str:sub(1, istart - 1)
  after = str:sub(iend + 1, -1)
  return before .. after
end

get_commentstring = function()
  return str_remove(vim.o.commentstring, "%s")
end

M = {}

M.foldtext = function()
  start_lno = vim.v.foldstart
  end_lno = vim.v.foldend
  start_line = vim.api.nvim_buf_get_lines(0, start_lno - 1, start_lno, true)[1]
  end_line = vim.api.nvim_buf_get_lines(0, end_lno - 1, end_lno, true)[1]
  if vim.o.foldmethod == 'marker' then
    start_marker, end_marker = unpack(vim.split(vim.o.foldmarker, ',', { plain = true }))
    start_marker = start_marker:gsub('%p', '%%%0') .. '%d?%s*$'
    end_marker = end_marker:gsub('%p', '%%%0') .. '%d?%s*$'
    start_line = start_line:gsub(start_marker, "")
    end_line = end_line:gsub(end_marker, "")
    -- TODO: get commentstring using treesitter. Tricky 'cause the plugin uses the cursor position.
    comment_str = get_commentstring()
    if comment_str ~= '' then
      start_line = start_line:gsub(comment_str .. '%s*$', '')
      end_line = end_line:gsub(comment_str .. '%s*$', '')
    end
  end
  start_line = start_line:match("^%s*.*%S") or start_line
  end_line = vim.trim(end_line)
  if #end_line ~= 0 then end_line = ' … ' .. end_line end
  num_lines = end_lno - start_lno + 1
  return start_line .. end_line .. string.format(' │%d├', num_lines)
end

return M
