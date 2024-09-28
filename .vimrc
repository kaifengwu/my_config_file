syntax on               " Set syntax highlighting
set number              " Set the line number
set softtabstop=4           " Set an indent to account for 4 spaces
set autoindent          " Set up automatic indentation
set mouse=a             " Set mouse is always available, set mouse= (empty) cancel
"set cc=80               " Column 80 highlighted, set cc=0 cancellation
set cursorline          " Settings to highlight the current row
set cindent             " Format C language
set st=4                " Set the width of the soft tab to 4 spaces
set shiftwidth=4        " The width automatically indented when setting a new line is 4 spaces
set sts=4               " Set the number of spaces inserted when the Tab key is pressed in insertion mode to 4
set ruler               " Show the status of the last line
set showmode            " The status of this row is displayed in the lower left corner.
set bg=dark             " Show different background tones
set hlsearch            " Enable Search Highlight
set laststatus=2        " Always display the status bar
set list lcs=tab:\|\   		" Set to use a vertical bar "|" when displaying Tab characters
" Set Automatically Complete Parentheses
"inoremap ' ''<ESC>i
"inoremap " ""<ESC>i
inoremap ) )<ESC>i
inoremap ] ]<ESC>i
inoremap > ><ESC>i
inoremap } <CR>}<ESC>O
map <C-s> :w<CR>
map <C-q> :wq<CR>
inoremap <C-a> <C-p>
nmap - 0
nmap = $
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#_select_confirm()
        \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Configure the NERDTree plugin mapping button
" Automatically open NERDTree after opening the file
autocmd VimEnter * NERDTree | wincmd p 
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
" Key F2: Map other tabs
map <F2> :NERDTreeMirror<CR>
" Key F3: Expand/shrink NERDTree
map <F3> :NERDTreeToggle<CR>
" Key f: In the NERDTree window, jump the cursor to the currently open file.
map f :NERDTreeFind<CR>
" Key 1: Switch to the previous tab
"map 1 :tabp<CR>
" Key 2: Switch to the next tab
"map 2 :tabn<CR>

let mapleader = " "




call plug#begin('~/.vim/plugged')
Plug 'scrooloose/nerdtree'
Plug 'neoclide/coc.nvim' ", {'for':[ 'c', 'cpp', 'json', 'cmake', 'vim',''], 'branch': 'release'}
Plug 'rhysd/vim-clang-format' ", {'for' : ['c', 'cpp']}
Plug 'chxuan/cpp-mode' ", {'for' : ['cpp']}
call plug#end()

" plugin-config vim-clang-format
let g:clang_format#auto_format=1

" plugin-config cpp-mode
nnoremap <leader>y :CopyCode<cr>
nnoremap <leader>p :PasteCode<cr>
nnoremap <leader>u :GoToFunImpl<cr>
nnoremap <silent> <leader>a :Switch<cr>

function! CheckBackspace() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction
  " Insert <tab> when previous text is space, refresh completion if not.
inoremap <silent><expr> <TAB>
    \ coc#pum#visible() ? coc#pum#next(1):
    \ CheckBackspace() ? "\<Tab>" :
    \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"


"" plugin-config coc-snippets {{{
"inoremap <silent><expr> <TAB>
"      \ coc#pum#visible() ? coc#_select_confirm() :
"      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
"      \ <SID>check_back_space() ? "\<TAB>" :
"      \ coc#refresh()


"function! s:check_back_space() abort
"  let col = col('.') - 1
"  return !col || getline('.')[col - 1]  =~# '\s'
"endfunction


"tab used as comfirm

"inoremap <silent><expr> <TAB>                                                      
"      \ coc#pum#visible() ? coc#_select_confirm() :                                    
"      \ coc#expandableOrJumpable() ?                                                   
"      \ "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :       
"      \ CheckBackspace() ? "\<TAB>" :                                                  
"      \ coc#refresh()                                                                  
"                                                                                       
"    function! CheckBackspace() abort                                                   
"      let col = col('.') - 1                                                           
"      return !col || getline('.')[col - 1]  =~# '\s'                                   
"    endfunction                                                                        
"                                                                                       
let g:coc_snippet_next = '<tab>'           

" plugin-config coc-snippets }}}

" plugin-config coc-definition
nmap <silent> <leader>d :call CocAction('jumpDeclaration')<CR>
nmap <silent> <leader>i :call CocAction('jumpDefinition')<CR>

" options {{{
set smarttab
set expandtab

set nohlsearch
set incsearch
set hidden
set nobackup
set nowritebackup
set updatetime=300
set shortmess+=c
set signcolumn=yes
set nonumber
set ttyfast
set showcmd
set cmdheight=1
set noswapfile
set nobackup
set noerrorbells
set autowrite
set ignorecase
set ruler
set cursorline
set colorcolumn=110
set title
set showmatch
set noshowmode
set mouse=v
set modifiable
set splitright
set splitbelow
set shortmess=atI
set backspace=indent,eol,start
set wildmenu
set encoding=utf-8 nobomb
set binary
set autoread
set mousehide
set spelllang=en_US
set fileformat=unix
set autoread
set autowrite
set laststatus=2
set termwinsize=10*0
set number
set background=dark
set formatoptions=c,l,1,p
set expandtab
set nowrap
" options }}}

" Uncomment the following to have Vim jump to the last position when reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g'\"" | endif
endif

if has('persistent_undo')      "check if your vim version supports it
  set undofile                 "turn on the feature
  set undodir=$HOME/.vim/undo  "directory where the undo files will be stored
endif

