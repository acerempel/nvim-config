local get_hex = require('cokeline.hlgroups').get_hl_attr
local mappings = require('cokeline.mappings')

local blurred_fg = get_hex('Comment', 'fg')
local blurred_bg = get_hex('ColorColumn', 'bg')
local focused_fg = get_hex('Normal', 'fg')
local focused_bg = get_hex('Normal', 'bg')

require('cokeline').setup({
  default_hl = {
    fg = function (buffer)
      return buffer.is_focused and focused_fg or blurred_fg
    end,
    bg = function (buffer)
      return buffer.is_focused and focused_bg or blurred_bg
    end,
  },

  components = {
    { text = function (buffer) return buffer.index ~= 1 and '▎' or '' end, },
    {
      text = function(buffer)
        local id
        if mappings.is_picking_focus() or mappings.is_picking_close() then
          id = buffer.pick_letter
        else
          id = buffer.index
        end
        return ' ' .. id .. ' '
      end,
    },
    {
      text = function(buffer) return buffer.unique_prefix end,
      hl = {
        fg = get_hex('Comment', 'fg'),
        style = 'italic',
      },
    },
    {
      text = function(buffer) return buffer.filename .. ' ' end,
      hl = {
        style = function(buffer) return buffer.is_focused and 'bold' or nil end,
      },
    },
    {
      text = function (buffer) return buffer.is_modified and '⚫︎ ' or '🟂  ' end,
      delete_buffer_on_left_click = true,
    },
  },
})
