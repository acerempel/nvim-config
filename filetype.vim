if exists("did_load_filetypes")
  finish
endif

augroup filetypedetect

autocmd BufNewFile,BufRead,BufWritePre *.txt                setf text
autocmd BufNewFile,BufRead,BufWritePre *.tbl,*.table        setf table
autocmd BufNewFile,BufRead,BufWritePre *.tsx,*.jsx          setf typescriptreact
autocmd BufNewFile,BufRead,BufWritePre *.antlers.html       setf html.antlers

augroup END
