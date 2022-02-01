command! -buffer -nargs=* RustRun call s:run(<f-args>)

function s:on_exit() abort dict
  call nvim_win_close(self.win)
endfunction

function! s:run(...) abort
  split
  enew
  let l:buf = bufnr()
  let l:win = win_getid()
  let l:cmd = ["cargo", "run", "--", a:000]
  let l:opts = {
        \ 'buf': l:buf, 'win': l:win
        \ }
  let l:chan = termopen()
endfunction
