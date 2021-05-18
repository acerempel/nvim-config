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
augroup END

augroup vimrc
autocmd!

if has('nvim-0.5')
  " Automatically enable changes to plugin configuration
  autocmd BufWritePost plugins.lua PackerCompile
endif

autocmd BufWinLeave * lclose
autocmd FileType html,vimwiki setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType text,markdown,pandoc,vimwiki     setlocal nonumber fo+=t tw=72
autocmd FileType text setlocal nospell
autocmd FileType markdown,pandoc call AR_autotoggle_list()
autocmd FileType gitcommit      setlocal textwidth=67
autocmd FileType qf     setlocal wrap linebreak
autocmd FileType haskell,markdown,pandoc setlocal nofoldenable
autocmd FileType table setlocal tabstop=28 noexpandtab nolist
autocmd FileType cabal au BufWritePre <buffer=abuf> %!cabal-fmt

augroup END

function! AR_autotoggle_list()
    augroup list
        autocmd!
        autocmd InsertEnter <buffer=abuf> setlocal nolist
        autocmd InsertLeave <buffer=abuf> setlocal list
    augroup END
endfunction
