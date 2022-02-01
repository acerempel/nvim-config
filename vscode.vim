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

xnoremap <silent> zV <Cmd>call VSCodeNotifyVisual('editor.foldAllExcept', v:false)<CR>

nnoremap gD <Cmd>call VSCodeNotify('editor.action.revealDeclaration')<CR>
xnoremap gD <Cmd>call VSCodeNotify('editor.action.revealDeclaration')<CR>
nnoremap g] <Cmd>call VSCodeNotify('editor.action.referenceSearch.trigger')<CR>
xnoremap g] <Cmd>call VSCodeNotify('editor.action.referenceSearch.trigger')<CR>
nnoremap g} <Cmd>call VSCodeNotify('editor.action.goToReferences')<CR>
xnoremap g} <Cmd>call VSCodeNotify('editor.action.goToReferences')<CR>
nnoremap gO <Cmd>call VSCodeNotify('workbench.action.showAllSymbols')<CR>
nnoremap go <Cmd>call VSCodeNotify('workbench.action.gotoSymbol')<CR>

nnoremap <Leader>jd <Cmd>call VSCodeNotify('workbench.action.view.problems')<CR>
nnoremap <Leader>jo <Cmd>call VSCodeNotify('workbench.action.output.toggleOutput')<CR>
nnoremap <Leader>jt <Cmd>call VSCodeNotify('workbench.action.terminal.toggleTerminal')<CR>

" VSCode doesn't have commands for these apparently.
nnoremap zv <Nop>
nnoremap zr <Nop>
nnoremap zm <Nop>

nnoremap ]d <Cmd>call VSCodeNotify('editor.action.marker.nextInFiles')<CR>
nnoremap [d <Cmd>call VSCodeNotify('editor.action.marker.prevInFiles')<CR>
nnoremap ]c <Cmd>call VSCodeNotify('workbench.editor.action.nextChange')<CR>
nnoremap [c <Cmd>call VSCodeNotify('workbench.editor.action.prevChange')<CR>
nnoremap ]v <Cmd>call VSCodeNotify('editor.action.dirtydiff.next')<CR>
nnoremap [v <Cmd>call VSCodeNotify('editor.action.dirtydiff.prev')<CR>
nnoremap zk <Cmd>call VSCodeNotify('editor.gotoPreviousFold')<CR>
nnoremap zj <Cmd>call VSCodeNotify('editor.gotoPreviousFold')<CR>
nnoremap g<Tab> <Cmd>call VSCodeNotify('workbench.action.openPreviousRecentlyUsedEditor')<CR>
nnoremap g<S-Tab> <Cmd>call VSCodeNotify('workbench.action.openNextRecentlyUsedEditor')<CR>

nnoremap gh <Cmd>call VSCodeNotify('editor.action.changeAll')<Bar>startinsert<CR>
xnoremap gh <Cmd>call VSCodeNotifyVisual('editor.action.selectHighlights', v:true)<Bar>startinsert<CR>

nnoremap - <Cmd>call VSCodeNotify('editor.action.smartSelect.expand')<CR>
xnoremap - <Cmd>call VSCodeNotifyVisual('editor.action.smartSelect.expand')<CR>
xnoremap _ <Cmd>call VSCodeNotifyVisual('editor.action.smartSelect.shrink')<CR>
nnoremap _ <Cmd>call VSCodeNotify('editor.action.smartSelect.shrink')<CR>

" Allow remapping, since gj and gk are mapped to VSCode commands.
map <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
map <silent> <expr> k (v:count == 0 ? 'gk' : 'k')

" no matchparen
let g:loaded_matchparen = 1

" Don't remember the buffers list, VSCode manages that
set shada-=%
