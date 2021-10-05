if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

augroup ft_cabal
autocmd BufWritePre <buffer> %!cabal-fmt | norm g'.
augroup END

let b:undo_ftplugin = "autocmd! ft_cabal"
