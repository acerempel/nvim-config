local function gs(f)
  return ("<Cmd>lua require('gitsigns').%s<CR>"):format(f)
end

function _G.select_git_action()
  local actions = require('gitsigns').get_actions()
  local items = vim.tbl_keys(actions)
  local perform = function (item)
    if item ~= nil then actions[item]() end
  end
  local format = function (item) return item end
  local prompt = "Git action:"
  vim.ui.select(items, {
    prompt = prompt,
    format = format,
  }, perform)
end

require('gitsigns').setup {
  on_attach = function (buf)
    local whichkey = require('which-key')
    whichkey.register(
      {
        p = { gs('preview_hunk()'), "Preview hunk diff" },
        r = { gs('reset_hunk()'), "Restore hunk from the index" },
        R = { gs('reset_buffer()'), "Restore all hunks from the index" },
        s = { gs('stage_hunk()'), "Stage hunk" },
        S = { gs('stage_buffer()'), "Stage buffer" },
        u = { gs('undo_stage_hunk()'), "Undo stage hunk" },
        U = { gs('reset_buffer_index()'), "Restore buffer from the index" },
        b = { gs('blame_line()'), "Show last commit affecting this line" },
        d = { gs('diffthis()'), "Diff file against index" },
        c = { '<Cmd>lua select_git_action()<CR>', "Select git action" },
      },
      { prefix = '<Leader>c', buffer = buf }
    )
    whichkey.register(
      {
        ['[c'] = { gs('prev_hunk()'), 'Go to previous change' },
        [']c'] = { gs('next_hunk()'), 'Go to next hunk' }
      },
      { buffer = buf }
    )
  end
}
