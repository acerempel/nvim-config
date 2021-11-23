if exists(':Gui') == 3
  GuiFont JetBrains\ Mono:h13
  GuiPopupmenu 0
  GuiTabline 0
  GuiLinespace 0
  GuiScrollBar 1
  GuiRenderLigatures 1
  call GuiClipboard()
  nnoremap <silent><RightMouse> <Cmd>call GuiShowContextMenu()<CR>
  inoremap <silent><RightMouse> <Cmd>call GuiShowContextMenu()<CR>
  vnoremap <silent><RightMouse> <Cmd>call GuiShowContextMenu()<CR>
endif

set title
augroup dirtitle
  autocmd!
  autocmd DirChanged * let &titlestring = v:event.cwd
augroup END

noremap <D-s> <Cmd>w<CR>
inoremap <D-s> <Cmd>w<CR>
noremap <D-v> p
inoremap <D-v> <C-o>p
noremap <D-c> y
noremap <D-x> d
noremap <D-p> <Cmd>lua require('telescope.builtin').find_files()<CR>
noremap <S-D-P> <Cmd>lua require('telescope.builtin').commands()<CR>
noremap <S-D-p> <Cmd>lua require('telescope.builtin').commands()<CR>
noremap <D-q> <Cmd>qall<CR>
noremap <D-w> <Cmd>BufferClose<CR>
noremap <S-D-W> <Cmd>tabclose<CR>
noremap <S-D-N> <Cmd>tabnew<CR>
noremap <D-n> <Cmd>enew<CR>
noremap <D-z> u
inoremap <D-z> <C-o>u
noremap <S-D-Z> <C-r>
inoremap <S-D-Z> <C-o><C-r>
inoremap <D-CR> <Cmd>stopinsert<Bar>wq<CR>
noremap <D-,> <Cmd>edit $MYVIMRC<CR>
noremap <D-o> <Cmd>lua require('telescope.builtin').file_browser()<CR>
inoremap <D-o> <Cmd>lua require('telescope.builtin').file_browser()<CR>
noremap <D-t> <Cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>
lua <<END
_G.workspace_query_input = function(input)
  if input then
    require('telescope.builtin').lsp_workspace_symbols({ query = input })
  else
    return
  end
end
END
noremap <S-D-T> <Cmd>lua vim.ui.input({ prompt = "Query: " }, workspace_query_input)<CR>
noremap <S-D-t> <Cmd>lua vim.ui.input({ prompt = "Query: " }, workspace_query_input)<CR>
noremap <S-D-]> <Cmd>BufferNext<CR>
noremap <S-D-[> <Cmd>BufferPrevious<CR>
noremap <D-[> <C-O>
noremap <D-]> <C-I>
