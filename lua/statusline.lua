local vi_mode_utils = require('feline.providers.vi_mode')

local icon = require('nvim-nonicons').get

mode_short_names = {
  n = 'N ',
  o = 'OP',
  v = 'VC',
  V = 'VL',
  ['\022'] = 'VB',
  s = 'SC',
  S = 'SL',
  ['\019'] = 'SB',
  R = 'R ',
  i = 'I ',
  c = 'C ',
  r = 'M ',
  ['!'] = 'SH',
  t = 'T ',
}

mode_long_names = {
  n = ' Normal ',
  o = 'Operator',
  v = ' V-char ',
  V = ' V-line ',
  ['\022'] = ' V-block',
  s = ' S-char ',
  S = ' S-line ',
  ['\019'] = ' S-block',
  R = 'Replace ',
  i = ' Insert ',
  c = 'Command ',
  r = '  More  ',
  ['!'] = ' Shell  ',
  t = 'Terminal',
}

mode_medium_names = {
  n = 'NORM',
  o = 'OPER',
  v = 'V-CH',
  V = 'V-LN',
  ['\022'] = 'V-BK',
  s = 'S-CH',
  S = 'S-LN',
  ['\019'] = 'S-BK',
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
          return mode_medium_names[mode:sub(1,1)]
        end,
        short_provider = function()
          local mode = vim.api.nvim_get_mode().mode
          return mode_short_names[mode:sub(1,1)]
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
        icon = '⊗'
    },
    {
        provider = 'diagnostic_warnings',
        hl = { fg = 'yellow' },
        priority = -4,
        truncate_hide = true,
        left_sep = 'block',
        icon = '⚠'
    },
    {
        provider = 'diagnostic_hints',
        hl = { fg = 'cyan' },
        priority = -5,
        truncate_hide = true,
        left_sep = 'block',
        icon = '¶'
    },
    {
        provider = 'diagnostic_info',
        hl = { fg = 'skyblue' },
        priority = -6,
        truncate_hide = true,
        left_sep = 'block',
        icon = 'ℹ'
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
        right_sep = {
          'block',
          {
            str = 'slant_left_thin',
            hl = { fg = 'skyblue', bg = 'bg_dim', },
          },
        },
        priority = 1,
        truncate_hide = true,
    },
    {
        provider = '%2l/%-3L',
        hl = {
            fg = 'skyblue',
            bg = 'bg_dim',
        },
        right_sep = 'block',
        left_sep = 'block',
    },
    {
        provider = 'scroll_bar',
        hl = {
            fg = 'skyblue',
            bg = 'bg_dim',
            style = 'bold',
        }
    },
}

M.inactive[1] = {
    {
        provider = 'file_info',
        enabled = function() return vim.bo.buftype ~= 'quickfix' and vim.bo.buftype ~= "terminal" end,
        hl = {
            fg = 'bg_dim',
            bg = 'skyblue',
            style = 'bold'
        },
        left_sep = 'block',
        right_sep = {
            'block',
            'slant_right'
        },
    },
    {
      provider = function() return vim.fn.win_gettype() end,
      enabled = function() return vim.bo.buftype == 'quickfix' end,
      hl = {
          fg = 'bg_dim',
          bg = 'skyblue',
          style = 'bold'
      },
      left_sep = 'block',
      right_sep = {
          'block',
          {
            str = 'slant_right',
            hl = { fg = 'skyblue', bg = 'bg_dim' },
          }
      },
    },
    {
      provider = function()
        local which = vim.fn.win_gettype()
        local title
        if which == "quickfix" then
          title = vim.fn.getqflist({ title = 1 }).title
        elseif which == "loclist" then
          title = vim.fn.getloclist(0, { title = 1 }).title
        elseif vim.bo.buftype == 'terminal' then
          title = vim.b.term_title
        else
          title = vim.api.nvim_buf_get_name(0)
        end
        return title
      end,
      enabled = function() return vim.bo.buftype == 'quickfix' or vim.bo.buftype == 'terminal' end,
      hl = {
          style = 'bold',
          bg = 'bg_dim',
      },
      left_sep = 'block',
      right_sep = {
        'block',
        'slant_right',
      },
    },
}

M.inactive[2] = {
    {
        provider = '%2l/%-3L',
        hl = {
            fg = 'skyblue',
            bg = 'bg_dim',
        },
        right_sep = 'block',
        left_sep = 'block',
    },
    {
        provider = 'scroll_bar',
        hl = {
            fg = 'skyblue',
            bg = 'bg_dim',
            style = 'bold',
        }
    },
}

local palette = require('zenbones.palette')[vim.o.background]

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
  theme = colors,
  force_inactive = {
    filetypes = {
      '^NvimTree$',
      '^packer$',
      '^fugitive$',
      '^fugitiveblame$',
    },
    buftypes = {
      '^quickfix$',
      '^help$',
    },
  },
  disable = {
    filetypes = {
      '^TelescopePrompt$',
    },
  },
}
