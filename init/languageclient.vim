let g:LanguageClient_serverCommands = {
  \ 'haskell': ['~/.local/bin/ghcide', '--lsp'],
  \ 'rust': ['rust-analyzer'],
  \ }
" 'haskell': ['~/.local/bin/ghcide', '--lsp'],
" 'haskell': ['~/.local/bin/hie', '--lsp', '--bios-verbose', '--logfile', '/Users/alan/.local/share/hie/hie-ale-nvim.log'],
let g:LanguageClient_rootMarkers = {
  \ 'haskell': ['hie.yaml'],
  \ }
let g:LanguageClient_changeThrottle = 0.1
let g:LanguageClient_loggingFile = "/Users/alan/.local/share/nvim/LanguageClient.log"
let g:LanguageClient_loggingLevel = 'INFO'
let g:LanguageClient_trace = 'messages'
let g:LanguageClient_windowLogMessageLevel = 'Info'
let g:LanguageClient_hoverPreview = 'Always'
let g:LanguageClient_useVirtualText = 'CodeLens'
let g:LanguageClient_useFloatingHover = 1
let g:LanguageClient_echoProjectRoot = 1
let g:LanguageClient_selectionUI = 'quickfix'
let g:LanguageClient_diagnosticsList = 'Location'
let g:LanguageClient_autoStart = 0
let g:LanguageClient_autoStop = 1

function! LanguageClient_mappings() abort
  nnoremap <silent><buffer> K :call LanguageClient#textDocument_hover()<CR>
  nnoremap <silent><buffer> gd :call LanguageClient#textDocument_definition()<CR>
  nnoremap <silent><buffer> <Leader>gt :call LanguageClient#textDocument_typeDefinition()<CR>
  nnoremap <silent><buffer> <Leader>gi :call LanguageClient#textDocument_implementation()<CR>
  nnoremap <silent><buffer> <Leader>ko :call LanguageClient#textDocument_documentSymbol()<CR>
  nnoremap <silent><buffer> <Leader>kw :call LanguageClient#workspace_symbol()<CR>
  nnoremap <silent><buffer> <Leader>ke :call LanguageClient#explainErrorAtPoint()<CR>
endfunction

function! LCStart() abort
  LanguageClientStart
  call LanguageClient_mappings()
endfunction
