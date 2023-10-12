local M = {}

local references = {}

-- check for cursor row in [start,end]
-- check for cursor col in [start,end]
-- While the end is technically exclusive based on the highlighting, we treat it as inclusive to match the server.
local function point_in_range(point, range)
    if point.row == range['start']['line'] and point.col < range['start']['character'] then
        return false
    end
    if point.row == range['end']['line'] and point.col > range['end']['character'] then
        return false
    end
    return point.row >= range['start']['line'] and point.row <= range['end']['line']
end

local function cursor_in_references(bufnr)
    if not references[bufnr] then
        return false
    end
    if vim.api.nvim_win_get_buf(0) ~= bufnr then
        return false
    end
    local crow, ccol = unpack(vim.api.nvim_win_get_cursor(0))
    crow = crow - 1 -- reference ranges are (0,0)-indexed for (row,col)
    for _, reference in pairs(references[bufnr]) do
        local range = reference.range
        if point_in_range({row=crow,col=ccol}, range) then
            return true
        end
    end
    return false
end

-- returns r1 < r2 based on start of range
local function before_by_start(r1, r2)
    if r1['start'].line < r2['start'].line then return true end
    if r2['start'].line < r1['start'].line then return false end
    if r1['start'].character < r2['start'].character then return true end
    return false
end

-- returns r1 < r2 base on start and if they are disjoint
local function before_disjoint(r1, r2)
    if r1['end'].line < r2['start'].line then return true end
    if r2['start'].line < r1['end'].line then return false end
    if r1['end'].character < r2['start'].character then return true end
    return false
end

local function handle_document_highlight(result, bufnr, client_id)
    if not bufnr or not vim.api.nvim_buf_is_loaded(bufnr) then return end
    if type(result) ~= 'table' then
        vim.lsp.util.buf_clear_references(bufnr)
        return
    end
    vim.lsp.util.buf_clear_references(bufnr)
    if cursor_in_references(bufnr) then
        local client = vim.lsp.get_client_by_id(client_id)
        vim.lsp.util.buf_highlight_references(bufnr, result, client.offset_encoding)
    end
    table.sort(result, function(a, b)
        return before_by_start(a.range, b.range)
    end)
    references[bufnr] = result
end

function M.get_document_highlights(bufnr)
  return references[bufnr]
end

local function valid(bufnr, range)
  return range
    and range.start.line < vim.api.nvim_buf_line_count(bufnr)
    and range.start.character < #vim.fn.getline(range.start.line + 1)
end

function M.next_reference(opts)
  local opt = M.opts
  opt.reverse = (opts or {}).reverse and true or false

  local before
  if opt.range_ordering == 'start' then
    before = before_by_start
  else
    before = before_disjoint
  end
  local bufnr = vim.api.nvim_get_current_buf()
  local refs = M.get_document_highlights(bufnr)
  if not refs or #refs == 0 then return nil end

  local next = nil
  local nexti = nil
  local crow, ccol = unpack(vim.api.nvim_win_get_cursor(0))
  local crange = {start={line=crow-1,character=ccol}}

  for i, ref in ipairs(refs) do
    local range = ref.range
    if valid(bufnr, range) then
      if opt.reverse then
        if before(range, crange) and (not next or before(next, range)) then
          next = range
          nexti = i
        end
      else
        if before(crange, range) and (not next or before(range, next)) then
          next = range
          nexti = i
        end
      end
    end
  end
  if not next and opt.wrap then
    nexti = opt.reverse and #refs or 1
    next = refs[nexti].range
  end
  if next then
    local row, col = next.start.line + 1, next.start.character
    vim.api.nvim_win_set_cursor(0, {row, col})
    if not opt.silent then
      print('['..nexti..'/'..#refs..']')
    end
  end
  return next
end

local function clear_references(bufnr)
  if not cursor_in_references(bufnr) then
    vim.lsp.util.buf_clear_references(bufnr)
    references[bufnr] = nil
  end
end

function M.setup(opts)
  M.opts = vim.tbl_extend('force', {wrap=false, range_ordering='start', silent=false}, opts or {})
  vim.lsp.handlers['textDocument/documentHighlight'] = function(...)
    handle_document_highlight(select(2, ...), select(3, ...).bufnr, select(3, ...).client_id)
  end

  return function (bufnr)
    vim.api.nvim_buf_attach(bufnr, false, {
      on_lines = clear_references(bufnr),
    })
  end
end

return M
