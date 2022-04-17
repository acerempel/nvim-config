if exists(':Gui') == 3
  GuiFont Iosevka:h14
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

let g:neovide_input_use_logo = v:true
let g:neovide_cursor_animation_length = 0.07
let g:neovide_cursor_trail_length = 0.4

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
noremap <D-,> <Cmd>edit $MYVIMRC<CR>
noremap <D-o> <Cmd>lua require('telescope.builtin').file_browser()<CR>
inoremap <D-o> <Cmd>lua require('telescope.builtin').file_browser()<CR>
nmap <S-D-o> gO
nmap <S-D-O> gO
nmap <D-t> gW
nmap <D-.> z=
xmap <D-.> z=
nnoremap <S-D-v> <Cmd>G<CR><C-w>L56<C-w><Bar>
nmap <S-D-]> <Plug>(cokeline-focus-next)
nmap <S-D-[> <Plug>(cokeline-focus-prev)
nmap <S-D-}> <Plug>(cokeline-focus-next)
nmap <S-D-{> <Plug>(cokeline-focus-prev)
nmap <C-tab> <cmd>lua require('telescope.builtin').buffers({ sort_mru = true, ignore_current_buffer = true })<cr>
lua for i = 1,9 do vim.api.nvim_set_keymap('n', ('<D-%s>'):format(i), ('<Plug>(cokeline-focus-%s)'):format(i),  { silent = true }) end
nnoremap <S-D-a> <Cmd>lua require'telescope.builtin'.buffers()<CR>
nmap <D-[> <C-O>
nmap <D-]> <C-I>
inoremap <D-[> <C-D>
inoremap <D-]> <C-T>
nnoremap <M-D-p> <Cmd>CocList commands<CR>
nnoremap <S-D-m> <Cmd>lua require("telescope").extensions.coc.workspace_diagnostics(require("telescope.themes").get_ivy({ layout_config = { height = 10 }, initial_mode = "normal" }))<CR>
nmap <D-/> gcc
xmap <D-/> gC
smap <D-/> <C-g>gC
