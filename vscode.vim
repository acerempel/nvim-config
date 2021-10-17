" Use VS Code's comment support
xmap gc  <Plug>VSCodeCommentary
nmap gc  <Plug>VSCodeCommentary
omap gc  <Plug>VSCodeCommentary
nmap gcc <Plug>VSCodeCommentaryLine

nnoremap <silent> za <Cmd>call VSCodeNotify('editor.toggleFold')<CR>
nnoremap <silent> zR <Cmd>call VSCodeNotify('editor.unfoldAll')<CR>
nnoremap <silent> zM <Cmd>call VSCodeNotify('editor.foldAll')<CR>
nnoremap <silent> zo <Cmd>call VSCodeNotify('editor.unfold')<CR>
nnoremap <silent> zO <Cmd>call VSCodeNotify('editor.unfoldRecursively')<CR>
nnoremap <silent> zc <Cmd>call VSCodeNotify('editor.fold')<CR>
nnoremap <silent> zC <Cmd>call VSCodeNotify('editor.foldRecursively')<CR>

nnoremap <silent> z1 <Cmd>call VSCodeNotify('editor.foldLevel1')<CR>
nnoremap <silent> z2 <Cmd>call VSCodeNotify('editor.foldLevel2')<CR>
nnoremap <silent> z3 <Cmd>call VSCodeNotify('editor.foldLevel3')<CR>
nnoremap <silent> z4 <Cmd>call VSCodeNotify('editor.foldLevel4')<CR>
nnoremap <silent> z5 <Cmd>call VSCodeNotify('editor.foldLevel5')<CR>
nnoremap <silent> z6 <Cmd>call VSCodeNotify('editor.foldLevel6')<CR>
nnoremap <silent> z7 <Cmd>call VSCodeNotify('editor.foldLevel7')<CR>

xnoremap <silent> zV <Cmd>call VSCodeNotify('editor.foldAllExcept')<CR>

nnoremap gD <Cmd>call VSCodeNotify('editor.action.revealDeclaration')<CR>
xnoremap gD <Cmd>call VSCodeNotify('editor.action.revealDeclaration')<CR>
nnoremap g] <Cmd>call VSCodeNotify('editor.action.referenceSearch.trigger')<CR>
xnoremap g] <Cmd>call VSCodeNotify('editor.action.referenceSearch.trigger')<CR>
nnoremap g} <Cmd>call VSCodeNotify('editor.action.goToReferences')<CR>
xnoremap g} <Cmd>call VSCodeNotify('editor.action.goToReferences')<CR>
nnoremap gO <Cmd>call VSCodeNotify('workbench.action.showAllSymbols')<CR>
nnoremap go <Cmd>call VSCodeNotify('workbench.action.gotoSymbol')<CR>

" VSCode doesn't have commands for these apparently.
noremap zv <Nop>
noremap zr <Nop>
noremap zm <Nop>

noremap ]d <Cmd>call VSCodeNotify('editor.action.marker.nextInFiles')<CR>
noremap [d <Cmd>call VSCodeNotify('editor.action.marker.prevInFiles')<CR>

nnoremap gh <Cmd>call VSCodeNotify('editor.action.changeAll')<CR>
xnoremap gh <Cmd>call VSCodeNotifyVisual('editor.action.selectHighlights', v:false)<CR>

" Allow remapping, since gj and gk are mapped to VSCode commands.
map <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
map <silent> <expr> k (v:count == 0 ? 'gk' : 'k')

" no matchparen
let g:loaded_matchparen = 1
