let $NVIM_TUI_ENABLE_TRUE_COLOR=1

source $HOME/.config/nvim/config/editor.vim
source $HOME/.config/nvim/config/plugins.vim
source $HOME/.config/nvim/config/keys.vim
source $HOME/.config/nvim/config/autocmds.vim
" source $HOME/.config/nvim/config/myline.vim

""" Load Theme
syntax enable
filetype plugin on
set termguicolors
set background=light
colorscheme NeoSolarized

""" Set font for GUI
if has('gui_running')
    set guifont=Hack:h16
end

set shortmess=O