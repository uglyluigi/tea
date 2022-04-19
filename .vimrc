call plug#begin('~/.vim/plugged')
Plug 'https://github.com/jeffkreeftmeijer/vim-numbertoggle'
Plug 'https://github.com/vim-airline/vim-airline'
Plug 'https://github.com/joshdick/onedark.vim'
Plug 'preservim/nerdtree'
Plug 'https://github.com/sainnhe/gruvbox-material'
Plug 'https://github.com/tpope/vim-dadbod'
call plug#end()

color gruvbox-material
set number
set showmatch
set spell
set shiftwidth=4
nnoremap <C-b> :NERDTreeToggle<CR>

