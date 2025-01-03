" plug
" install first
" curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
call plug#begin()
Plug 'christoomey/vim-tmux-navigator'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'preservim/nerdtree'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
" Plug 'nathanaelkane/vim-indent-guides'
call plug#end()

" tmux navigator
let g:tmux_navigator_no_mappings = 1
nnoremap <silent> <c-h> :<C-U>TmuxNavigateLeft<cr>
nnoremap <silent> <c-j> :<C-U>TmuxNavigateDown<cr>
nnoremap <silent> <c-k> :<C-U>TmuxNavigateUp<cr>
nnoremap <silent> <c-l> :<C-U>TmuxNavigateRight<cr>
nnoremap <silent> <c-p> :<C-U>TmuxNavigatePrevious<cr>

" font
" set guifont=DejaVu\ Sans\ Mono\ for\ Powerline:h12

" airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#branch#enabled=1
let g:airline#extensions#tabline#enabled = 1


" syntax
syntax enable

" filetype
filetype plugin on
filetype indent on

" system clipboard
set clipboard=unnamedplus,unnamed,autoselect " always use system one

" general configs
set noshowmode
set nobackup
set nowritebackup
set noswapfile
set tabstop=4
set shiftwidth=4            "Indent by 2 spaces when using >>, <<, == etc.
set softtabstop=4           "Indent by 2 spaces when pressing <TAB>
set expandtab               "Use softtabstop spaces instead of tab characters for indentation
set autoindent              "Keep indentation from previous line
set smartindent             "Automatically inserts indentation in some cases
set cindent                 "Like smartindent, but stricter and more customisable
set colorcolumn=100
set nu rnu                  " line numbers relative with current position
set guicursor=n:ver25-Cursor/lCursor,i:hor20-Cursor/lcursor,v:block-Cursor
set cursorline
set scrolloff=5
set nowrap
set ignorecase
set smartcase
set formatoptions-=cro
set backspace=2             " indent,eol,start
set hlsearch                " hilight search result
set listchars=tab:»\ ,extends:›,precedes:‹,nbsp:·,trail:·
set list

" indent
" let g:indent_guides_start_level = 2
" let g:indent_guides_guides_size = 1

" cursorline
hi Cursorline cterm=bold term=bold
hi CursorLineNr term=bold cterm=bold gui=bold guifg=#1034a6 ctermfg=013

" map leader
let mapleader= " "

" make ctrl-c behave like esc
imap <C-c> <ESC>

" Key bindings
map <leader>t :NERDTreeToggle<CR>
map <leader>f :Files<CR>
map <leader>l :ls<CR>
map <leader>d :bdelete<CR>
map <leader>nh :nohl<CR>
"  window management
nnoremap <leader>v <C-w>v
nnoremap <leader>h <C-w>s
nnoremap <leader>e <C-w>=
nnoremap <leader>x :close<CR>
