let g:Lf_WindowPosition = 'popup'
let g:Lf_PreviewInPopup = 1
let g:Lf_ShortcutF = '<Leader>ff'
let g:Lf_ShortcutB = '<Leader>fb'
let g:Lf_UseCache = 0
let g:Lf_WildIgnore = {
  \ 'dir': ['.git', 'dist-newstyle', '.stack-work', 'undo'],
  \ 'file': ['*.o', '*.hi']
  \ }
let g:Lf_ExternalCommand = 'fd . "%s" -t f'
let g:Lf_RootMarkers = ['cabal.project', 'stack.yaml', '.git']
let g:Lf_WorkingDirectoryMode = 'AF'
let g:Lf_ShowHidden = 1
let g:Lf_HideHelp = 1
let g:Lf_IgnoreCurrentBufferName = 1
let g:Lf_CommandMap = {
  \ '<C-X>': ['<C-S>'], '<C-]>': ['<C-V>'],
  \ '<C-K>': ['<C-P>'], '<C-J>': ['<C-N>']
  \ }

nnoremap <Leader>fc :Leaderf --fuzzy --cword file<CR>
