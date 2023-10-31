call plug#begin('~/.vim/plugged')
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'https://github.com/windwp/nvim-autopairs'
Plug 'luochen1990/rainbow'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'ur4ltz/surround.nvim'
Plug 'djoshea/vim-autoread'
Plug 'https://github.com/joshdick/onedark.vim'
Plug 'nvim-telescope/telescope-live-grep-args.nvim'
Plug 'nvim-telescope/telescope-file-browser.nvim'
Plug 'akinsho/toggleterm.nvim'
Plug 'wellle/context.vim'
Plug 'wadackel/vim-dogrun'
call plug#end()


colorscheme dogrun
set number " Line numbers
set noshowmode " Remove mode from under status bar
set relativenumber " Turns on relative line numbers by default
set laststatus=3 " One global status line for all windows in buffer instead of 1 for each
set smartindent
set tabstop=4
set shiftwidth=4
set expandtab
set termguicolors
set hidden

" Highlight current line in active buffer only
augroup CursorLine
    au!
    au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
    au WinLeave * setlocal nocursorline
augroup END

augroup NumberToggleInsert
    " Disables relative line numbers in insert mode
    autocmd InsertEnter * set norelativenumber|set number
    autocmd InsertLeave * set relativenumber|set nonumber
augroup END

augroup NumberToggleCmd
    " Disables relative line numbers in command mode
    autocmd CmdlineEnter * if &l:number != "number" || &l:relativenumber != "relativenumber" | set norelativenumber|set number|redraw | endif
    autocmd CmdlineLeave * if &l:number != "number" || &l:relativenumber != "relativenumber" | set relativenumber|set nonumber|redraw | endif
augroup END

let mapleader = "!" " The leader used for Telescope commands and barbar bindings
let g:rainbow_active = 1
let g:rainbow_conf = {
            \    'guifgs': ['#F1E8B8', '#2EC4B6', '#7067CF', '#F25F5C'],
            \}

let g:context_add_mappings = 0

set shm+=I

let g:neoformat_try_node_exe = 1 
let &shell='/opt/homebrew/bin/bash --rcfile /Users/uglyluigi/.bashrc'
" barbar stuff

noremap <silent> L :BufferLineCycleNext<cr>
noremap <silent> H :BufferLineCyclePrev<cr>

" Telescope commands
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope file_browser<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader><Up> <C-w><Up>
nnoremap <leader><Down> <C-w><Down>
nnoremap <leader><Left> <C-w><Left>
nnoremap <leader><Right> <C-w><Right>
nnoremap <silent> <leader>pb :BufferLineTogglePin<cr>
nnoremap <leader>= <C-w>=
nnoremap <C-`> :ToggleTerm<cr>
nnoremap <leader>cb :BufferLinePickClose<cr>
nnoremap <leader>cl :BufferLineCloseLeft<cr>
nnoremap <leader>cr :BufferLineCloseRight<cr>

inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <s-cr> <Esc>o

map J 5j
map K 5k
map E ea
map Q A;<Esc>

tnoremap <Esc> <C-\><C-n>
" Push escape to remove highlighting after search, substitution, etc.
map <silent> <Esc> :noh<CR>

" Lualine config
lua << END
require('lualine').setup {
    options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '', right = ''},
        section_separators = { left = '', right = ''},
    },

    sections = {
        lualine_a = {'mode'},
        lualine_b = {'filename'}, 
        lualine_c = {''},
        lualine_x = {'encoding'},
        lualine_y = {'branch', 'diff', {'diagnostics', sources = {'coc'}}},
        lualine_z = {'%l of %L'},
    },
}

telescope = require('telescope')
telescope.load_extension("live_grep_args")
telescope.load_extension("file_browser")
telescope.setup{ 
    defaults = { 
        file_ignore_patterns = {"node_modules", "target"},
        layout_strategy = 'vertical',
        layout_config = {
            vertical = {width = 0.5}
        },
        initial_mode = 'normal',
    },
}

require('colorizer').setup {}

require('surround').setup {}

require("toggleterm").setup {
    direction = 'float',
    shell = vim.o.shell,
    persist_mode = false,

    float_opts = {
        border = 'curved',
        width = 85,
        height = 25,
        winblend = 3,
    }
}

END


function OpenConfig()
    e ~/.config/nvim/init.vim
endfunction

" COC STUFF
" Set internal encoding of vim, not needed on neovim, since coc.nvim using some
" unicode characters in the file autoload/float.vim
set encoding=utf-8

" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes:1

noremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! CheckBackspace() abort 
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

autocmd TermOpen * setlocal nonumber norelativenumber scl=no

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

function! Terminal_cd()
        if &buftype == 'terminal'
                call chansend(b:terminal_job_id, 'NVIM_LISTEN_ADDRESS= cd "' . getcwd() . "\"\<cr>")
        endif
endfunction

function! Terminal_restore()
        let curtab = tabpagenr()
        let curwin = winnr()
        tabdo windo call Terminal_cd()
        exec curtab . 'tabn'
        exec curwin . 'wincmd w'
endfunction
