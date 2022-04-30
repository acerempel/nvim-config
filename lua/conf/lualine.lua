local function diff_source()
  local gitsigns = vim.b.gitsigns_status_dict
  if gitsigns then
    return {
      added = gitsigns.added,
      modified = gitsigns.changed,
      removed = gitsigns.removed
    }
  end
end

local gps = require('nvim-gps')

local function is_special()
  local buftype = vim.bo.buftype
  return buftype == 'help' or buftype == 'quickfix' or buftype == 'terminal'
end

local function special_filename()
  local buftype = vim.bo.buftype
  if buftype == 'help' then
    return vim.fn.expand('%:t')
  elseif buftype == 'quickfix' then
    local wintype = vim.fn.win_gettype()
    if wintype == 'quickfix' then
      return vim.fn.getqflist({title = 1}).title
    elseif wintype == 'loclist' then
      return  vim.fn.getloclist({title = 1}).title
    end
  elseif buftype == 'terminal' then
    return vim.b.term_title
  else
    return '???'
  end
end

local function min_width(w)
  return function ()
    local name = vim.api.nvim_buf_get_name(0)
    local winw = vim.api.nvim_win_get_width(0)
    return winw - #name >= w
  end
end

local section_a = {
  {
    'filename', path = 1,
    symbols = { modified = ' ⊕', readonly = ' ⊖', unnamed = '‹no name›' },
    cond = function() return not is_special() end,
  },
  {
    special_filename,
    cond = is_special,
  },
}

local section_b = {
  {'diff', source = diff_source}, {'b:gitsigns_head', icon = '', cond = min_width(80) }
}

require('lualine').setup {
  options = {
    theme = 'zenbones_light_bright',
  },
  sections = {
    lualine_a = section_a,
    lualine_b = section_b,
    lualine_c = { {gps.get_location, cond = function () return gps.is_available() and min_width(65)() end} },
    lualine_x = { {function () return vim.fn['coc#status']() end, cond = min_width(50)} },
    lualine_y = {'progress'},
    lualine_z = {'mode'},
  },
  inactive_sections = {
    lualine_a = section_a,
    lualine_b = section_b,
    lualine_c = {},
    lualine_x = {},
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
  }
}
