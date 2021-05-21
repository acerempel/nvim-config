source <sfile>:h/init/settings.vim

set termguicolors
source <sfile>:h/init/colours_gruvbox.vim
highlight! link Conceal Normal

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

  source <sfile>:h/init/coc.vim
  source <sfile>:h/init/ale.vim
endif

source <sfile>:h/init/mappings.vim
source <sfile>:h/init/pandoc.vim
source <sfile>:h/init/vimwiki.vim
source <sfile>:h/init/lightline.vim
source <sfile>:h/init/misc_plugin_settings.vim
