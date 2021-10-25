local vi_mode_utils = require('feline.providers.vi_mode')

local icon = require('nvim-nonicons').get

mode_short_names = {
  n = 'N ',
  o = 'OP',
  v = 'VC',
  V = 'VL',
  ['\016'] = 'VB',
  s = 'SC',
  S = 'SL',
  ['\013'] = 'SB',
  R = 'R ',
  i = 'I ',
  c = 'C ',
  r = 'M ',
  ['!'] = 'SH',
  t = 'T ',
}

mode_long_names = {
  n = 'Normal ',
  o = 'Operato',
  v = 'V-char ',
  V = 'V-line ',
  ['\016'] = 'V-block',
  s = 'S-char ',
  S = 'S-line ',
  ['\013'] = 'S-block',
  R = 'Replace',
  i = 'Insert ',
  c = 'Command',
  r = 'More   ',
  ['!'] = 'Shell  ',
  t = 'Termina',
}

mode_medium_names = {
  n = 'NORM',
  o = 'OPER',
  v = 'V-CH',
  V = 'V-LN',
  ['\016'] = 'V-BK',
  s = 'S-CH',
  S = 'S-LN',
  ['\013'] = 'S-BK',
  R = 'REPL',
  i = 'INS ',
  c = 'CMD ',
  r = 'MORE',
  ['!'] = 'SHL ',
  t = 'TERM',
}

local M = {
    active = {},
    inactive = {}
}

M.active[1] = {
    {
        provider = function()
          local mode = vim.api.nvim_get_mode().mode
          return mode_medium_names[mode]
        end,
        short_provider = function()
          local mode = vim.api.nvim_get_mode().mode
          return mode_short_names[mode]
        end,
        priority = -1,
        hl = function()
            return {
                name = vi_mode_utils.get_mode_highlight_name(),
                bg = vi_mode_utils.get_mode_color(),
                fg = 'bg',
                style = 'bold'
            }
        end,
        left_sep = 'block',
        right_sep = 'block',
    },
    {
        provider = 'file_info',
        hl = {
            style = 'bold',
            bg = 'bg_dim',
        },
        left_sep = 'block',
        right_sep = {
          str = 'slant_right',
          hl = { fg = 'bg_dim' },
        },
    },
    {
        provider = 'diagnostic_errors',
        hl = { fg = 'red' },
        priority = -3,
        truncate_hide = true,
        left_sep = 'block',
    },
    {
        provider = 'diagnostic_warnings',
        hl = { fg = 'yellow' },
        priority = -4,
        truncate_hide = true,
    },
    {
        provider = 'diagnostic_hints',
        hl = { fg = 'cyan' },
        priority = -5,
        truncate_hide = true,
    },
    {
        provider = 'diagnostic_info',
        hl = { fg = 'skyblue' },
        priority = -6,
        truncate_hide = true,
    },
    {
        provider = function() return require('nvim-gps').get_location() end,
        enabled = function() return require('nvim-gps').is_available() end,
        hl = { fg = 'leaf' },
        priority = -10,
        truncate_hide = true,
        left_sep = 'block',
    },
}

M.active[2] = {
    {
        provider = 'git_diff_added',
        icon = icon('diff-added'),
        hl = {
            fg = 'green',
            bg = 'bg_dim'
        },
        left_sep = {
          { str = 'slant_left', always_visible = true },
          { str = 'block', always_visible = true },
        },
        right_sep = 'block',
    },
    {
        provider = 'git_diff_changed',
        icon = icon('diff-modified'),
        hl = {
            fg = 'orange',
            bg = 'bg_dim'
        },
        right_sep = 'block',
    },
    {
        provider = 'git_diff_removed',
        icon = icon('diff-removed'),
        hl = {
            fg = 'red',
            bg = 'bg_dim'
        },
        right_sep = 'block',
    },
    {
        provider = 'git_branch',
        icon = ' ',
        hl = {
            fg = 'white',
            bg = 'bg_dim',
            style = 'bold'
        },
        right_sep = 'block',
        priority = 1,
        truncate_hide = true,
    },
    {
        provider = 'scroll_bar',
        hl = {
            fg = 'skyblue',
            bg = 'bg_dim',
            style = 'bold',
        }
    },
    {
        provider = 'line_percentage',
        hl = {
            fg = 'black',
            bg = 'skyblue',
            style = 'bold',
        },
        left_sep = 'block',
        right_sep = 'block',
    },
}

M.inactive[1] = {
    {
        provider = 'file_info',
        hl = {
            fg = 'white',
            bg = 'skyblue',
            style = 'bold'
        },
        left_sep = {
            str = ' ',
            hl = {
                fg = 'NONE',
                bg = 'oceanblue'
            }
        },
        right_sep = {
            {
                str = ' ',
                hl = {
                    fg = 'NONE',
                    bg = 'oceanblue'
                }
            },
            'slant_right'
        }
    },
    -- Empty component to fix the highlight till the end of the statusline
    {
    }
}

local palette = require('zenbones.palette')

local colors = {
  white = palette.fg1.hex,
  black = palette.bg1.hex,
  oceanblue = palette.wood.hex,
  skyblue = palette.water.hex,
  red = palette.rose.hex,
  yellow = palette.blossom.hex,
  cyan = palette.sky.hex,
  green = palette.leaf1.hex,
  orange = palette.blossom1.hex,
  violet = palette.rose1.hex,
}

setmetatable(colors, {
  __index = function (table, index)
    local palette_color = palette[index]
    if palette_color == nil then return nil end
    local color = palette_color.hex
    table[index] = color
    return color
  end,
})

require('feline').setup {
  components = M,
  colors = colors,
  force_inactive = {
    filetypes = {},
    buftypes = {},
  },
}
