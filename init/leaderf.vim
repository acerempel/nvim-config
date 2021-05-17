let g:Lf_WindowPosition = 'popup'
let g:Lf_PreviewInPopup = 1
let g:Lf_ShortcutF = '<Leader>ff'
let g:Lf_ShortcutB = '<Leader>fb'
let g:Lf_UseCache = 0
let g:Lf_WildIgnore = {
  \ 'dir': ['.git', 'dist-newstyle', '.stack-work', 'undo', 'node_modules', 'target', 'vendor'],
  \ 'file': ['*.o', '*.hi']
  \ }
let g:Lf_ExternalCommand = 'fd . "%s" -t f'
let g:Lf_RootMarkers = ['cabal.project', 'stack.yaml', 'composer.json', 'Cargo.toml', '.git', 'package.json']
let g:Lf_WorkingDirectoryMode = 'AF'
let g:Lf_ShowHidden = 1
let g:Lf_HideHelp = 1
let g:Lf_UseVersionControlTool = 0
let g:Lf_ShowDevIcons = 0
let g:Lf_IgnoreCurrentBufferName = 1
let g:Lf_CommandMap = {
  \ '<C-X>': ['<C-S>'], '<C-]>': ['<C-V>'],
  \ }

nnoremap <Leader>fc :Leaderf --fuzzy --cword file<CR>
