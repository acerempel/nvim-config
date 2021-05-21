" Return to last edit position when opening files -------- "
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

augroup quickfix
    autocmd!

    autocmd QuickFixCmdPost [^l]* cwindow
    autocmd QuickFixCmdPost l*    lwindow
    autocmd VimEnter        *     cwindow
    autocmd BufWinLeave * lclose
augroup END

if has('nvim-0.5')
  augroup packer
    autocmd!
    " Automatically enable changes to plugin configuration
    autocmd BufWritePost plugins.lua PackerCompile
  augroup END
endif

augroup terminal
  au!
  au TermOpen * tnoremap <buffer> <Esc> <c-\><c-n>
augroup END

if has('nvim-0.5')
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup END
endif

augroup filetypes
autocmd!

autocmd FileType html,vimwiki setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType prose,vimwiki     setlocal nonumber fo+=t tw=72
autocmd FileType markdown setlocal nospell
autocmd FileType prose setlocal spell
autocmd FileType gitcommit      setlocal textwidth=67
autocmd FileType qf     setlocal wrap linebreak
autocmd FileType table setlocal tabstop=28 noexpandtab nolist
autocmd FileType cabal au BufWritePre <buffer=abuf> %!cabal-fmt

autocmd BufReadPost,BufNew *.wiki ++once packadd vimwiki

augroup END
