if !has('nvim-0.5')
  echoerr "Neovim too old!!"
  exit
endif

source <sfile>:h/init/settings.vim

set termguicolors
source <sfile>:h/init/colours_gruvbox.vim
highlight! link Conceal Normal

source <sfile>:h/init/autocmds.vim

lua << ENDLUA
  require('plugins')
  require('lsp')
  require('completion')
ENDLUA

source <sfile>:h/init/mappings.vim
source <sfile>:h/init/pandoc.vim
source <sfile>:h/init/vimwiki.vim
source <sfile>:h/init/lightline.vim
source <sfile>:h/init/misc_plugin_settings.vim
