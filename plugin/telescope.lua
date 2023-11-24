local installed, telescope = pcall(require, 'telescope')
if not installed then
  vim.notify('telescope not installed', vim.log.levels.WARN)
  return
end

local actions = require('telescope.actions')
local layout_actions = require('telescope.actions.layout')
local themes = require('telescope.themes')
local ctrl_y = vim.api.nvim_replace_termcodes('<C-y>', true, false, true)

telescope.setup({
  defaults = {
    disable_devicons = true,
    color_devicons = false,
    layout_strategy = 'vertical',
    layout_config = {
      horizontal = { height = 0.5 },
      cursor = { height = 0.5 },
      bottom_pane = {
        height = 0.325,
        prompt_position = 'bottom',
      },
      vertical = {
        height = 0.625,
        preview_cutoff = 10,
        width = 0.5,
      },
    },
    preview = false,
    results_title = false,
    prompt_title = false,
    mappings = {
      i = {
        ["<Esc>"] = actions.close,
        ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
        ["<D-CR>"] = actions.smart_send_to_qflist + actions.open_qflist,
        ["<S-D-CR>"] = actions.smart_send_to_loclist + actions.open_loclist,
        ["<C-Space>"] = actions.complete_tag,
        ["<C-u>"] = false,
        ["<C-d>"] = false,
        ["<D-k>"] = layout_actions.toggle_preview,
        ["<C-tab>"] = actions.move_selection_worse,
        ["<S-C-tab>"] = actions.move_selection_better,
        ["<CR>"] = function(...)
          if vim.fn.pumvisible() == 1 then
            vim.api.nvim_feedkeys(ctrl_y, 'n', false)
          else
            actions.select_default(...)
          end
        end
      },
    },
  },
  pickers = {
    buffers = {
      show_all_buffers = true, ignore_current_buffer = true,
      sort_mru = true, bufnr_width = 3,
      disable_devicons = true,
    },
    find_files = {
      disable_devicons = true,
      prompt_title = false,
      prompt_prefix = 'Files› ',
      find_command = { 'fd', '-tf', '-LHu', '--strip-cwd-prefix', '-E.git', '-Enode_modules', '-Etarget', '-E.stack-work', '-Edist-newstyle', '-Evendor'  },
    },
    diagnostics = themes.get_ivy {
      no_unlisted = true,
      results_title = false,
      initial_mode = 'normal',
    },
    help_tags = {
      prompt_title = false,
      prompt_prefix = 'Help› ',
      mappings = {
        i = {
          ["<CR>"] = actions.select_vertical,
        },
      },
    },
    man_pages = {
      mappings = {
        i = {
          ["<CR>"] = actions.select_vertical,
        },
      },
    }
  },
  extensions = {
    ["ui-select"] = themes.get_cursor({ border = false }),
    frecency = {
      disable_devicons = true,
    },
    lsp_handlers = {
      location = {
        telescope = themes.get_ivy({
          initial_mode = 'normal',
          results_title = false,
        })
      },
    },
  },
})

telescope.load_extension('fzf')
telescope.load_extension('yank_history')

vim.keymap.set('n', '<Leader>h', function() require('telescope.builtin').help_tags() end, { desc = "Search help tags" })
vim.keymap.set('n', '<Leader>f', function() require('telescope.builtin').find_files() end, { desc = "Search files" })
vim.keymap.set('n', '<Leader>c', function() require('telescope.builtin').colorscheme({enable_preview = true}) end, { desc = "Search colorschemes" })
vim.keymap.set('n', '<Leader>-', function() require('telescope.builtin').commands() end, { desc = "Search commands" })
vim.keymap.set('n', 'gO', function() require('telescope.builtin').treesitter() end)
vim.keymap.set({'n', 'x'}, '<Leader>p', function() require("telescope").extensions.yank_history.yank_history({ }) end, { desc = "Open Yank History" })
