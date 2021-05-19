source <sfile>:h/init/settings.vim
source <sfile>:h/init/autocmds.vim

if has('nvim-0.5')
lua << ENDLUA
  require('plugins')
  require('lsp')
  require('completion')
ENDLUA
else
  call plug#begin('~/.local/share/nvim/plug')
  source <sfile>:h/init/plugins.vim
  source <sfile>:h/init/colours.vim
  call plug#end()
endif

source <sfile>:h/init/mappings.vim
source <sfile>:h/init/pandoc.vim
source <sfile>:h/init/vimwiki.vim
source <sfile>:h/init/lightline.vim
source <sfile>:h/init/misc_plugin_settings.vim

if !has('nvim-0.5')
  source <sfile>:h/init/coc.vim
  source <sfile>:h/init/ale.vim
endif
