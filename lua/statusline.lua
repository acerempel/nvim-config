local M = {}

function M.setup ()
  require('lualine').setup {
    options = {
      icons_enabled = false,
      theme = "gruvbox_light",
    },
    sections = {
      lualine_b = {
        'b:gitsigns_head',
      },
      lualine_c = {
        { 'filename', file_status = true, path = 1 },
        'b:gitsigns_status',
      },
      lualine_x = {
        {
          'diagnostics',
          sources = { 'coc' },
          sections = { 'error', 'warn' }
        }
      },
      lualine_y = { 'filetype' },
      lualine_z = { 'progress' },
    },
    inactive_sections = {
      lualine_b = { 'filename' },
      lualine_c = { 'b:gitsigns_status' },
      lualine_x = { 'filetype' },
      lualine_y = { 'progress' },
    }
  }
end

return M
