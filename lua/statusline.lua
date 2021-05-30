local M = {}

function M.setup ()
  require('lualine').setup {
    options = {
      icons_enabled = false,
      theme = "gruvbox_light",
    },
    sections = {
      lualine_b = {
        { 'filename', file_status = true, path = 1 }
      },
      lualine_c = { 'b:gitsigns_head', 'b:gitsigns_status' },
      lualine_x = {
        {
          'diagnostics',
          sources = { 'nvim_lsp' },
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
