" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" ~~ elmelmelmelmelmelmelmelmelmelmelm ~~
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

augroup elm
autocmd!

autocmd FileType elm    map <buffer> <LocalLeader>e <Plug>(elm-error-detail) |
                     \  map <buffer> <LocalLeader>ds <Plug>(elm-show-docs)   |
                     \  map <buffer> <LocalLeader>db <Plug>(elm-browse-docs)

augroup END

let g:elm_setup_keybindings=0
let g:elm_jump_to_error=1
let g:elm_make_show_warnings=1
let g:elm_detailed_complete=1
let g:elm_format_autosave=1
let g:elm_format_args = "--elm-version 0.17"
