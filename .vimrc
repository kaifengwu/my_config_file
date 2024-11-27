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
set laststatus=2        " Always display the status bar
set list lcs=tab:\|\   		" Set to use a vertical bar "|" when displaying Tab characters
set relativenumber
let g:filename = expand('%')
filetype plugin indent on

autocmd BufWritePost $MYVIMRC source $MYVIMRC
"signle character can't trigger function



inoremap } <ESC>:call Quotation4()<cr><ESC>

inoremap ' '<ESC>:call Quotation3()<cr><ESC>
"inoremap <silent>' '<ESC>:call Quotation3()<cr><ESC> 

inoremap > <ESC>:call Quotation2()<cr><ESC>

inoremap " <ESC>:call Quotation1()<cr><ESC>
"Set Automatically Complete Parentheses
inoremap ) )<ESC>i
inoremap ] ]<ESC>i
map <C-s> :cexpr[]<CR>:cclose<CR>:w<CR>
map <C-q> <ESC>:cclose<CR>:wq<CR>
map <C-c> <ESC>:call Window()<CR>
inoremap <C-c> <ESC>:call Window()<CR>
inoremap <C-s> <ESC>:cexpr[]<CR>:cclose<CR>:w<CR>l
inoremap <C-q> <ESC>:wq<CR>:cexpr[]<CR>:q<CR>
inoremap <C-l> <ESC>:call JumpToClosingParen(1)<CR>la
map <C-l> :call JumpToClosingParen(1)<CR>l
inoremap <C-h> <ESC>:call JumpToClosingParen(0)<CR>li
map <C-h> :call JumpToClosingParen(0)<CR>l
noremap - $
set winaltkeys=no”
"Use alt to use some function when input
execute "set <M-h>=\eh"
inoremap <M-h> <Left> 

execute "set <M-j>=\ej"
inoremap <M-j> <Down> 

execute "set <M-k>=\ek"
inoremap <M-k> <Up> 

execute "set <M-l>=\el"
inoremap <M-l> <Right> 

execute "set <M-o>=\eo"
inoremap <M-o> <ESC>o

execute "set <M-p>=\ep"
inoremap <M-p> <ESC>pa

execute "set <M-w>=\ew"
inoremap <M-w> <ESC>ebdei
nnoremap <M-w> <ESC>ebde

imap <A-h> <Left>
imap <A-j> <Down>
imap <A-k> <Up>
imap <A-l> <Right>
imap <A-w> <ESC>ebdei
nmap <A-w> <ESC>ebde
noremap <C-x> <ESC>^:call Annotate()<cr><ESC>
inoremap <C-x> <ESC>^:call Annotate()<cr><ESC>
inoremap <C-j> <ESC>^$:call Newline()<cr><ESC>
noremap <C-j> <ESC>^$:call Newline()<cr><ESC>
set guicursor=n-v-c:block,i-ci-ve:ver5,r-cr-o:hor20
"Insert <tab> when previous text is space, refresh completion if not.
" Configure the NERDTree plugin mapping button
" Automatically open NERDTree after opening the file
"use <C-W> + ←→ change window

"autocmd VimEnter * NERDTree | wincmd p 
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

let mapleader =" "


call plug#begin('~/.vim/plugged')
Plug 'scrooloose/nerdtree'
Plug 'neoclide/coc.nvim', { 'branch': 'release'}
Plug 'rhysd/vim-clang-format' ", {'for' : ['c', 'cpp']}
Plug 'chxuan/cpp-mode' ", {'for' : ['cpp']}
Plug 'nvim-lua/popup.nvim'
call plug#end()

"----------------------Verilog 相关的配套设置-----------------------------
autocmd FileType verilog setlocal shiftwidth=4 softtabstop=4
"在保存 .v 文件时运行 verilator 并加载错误到 Quickfix 窗口
autocmd BufWritePost *.v silent call LoadQuickfixMessage()

let g:ERROR_MODULE = 1
autocmd FileType verilog map <C-e> :call ModuleChange()<CR>
autocmd FileType verilog inoremap <C-e> <ESC>:call ModuleChange()<CR>

autocmd FileType verilog map <C-b> :call Verilogformat()<CR>
autocmd FileType verilog inoremap <C-b> <ESC>:call Verilogformat()<CR>
autocmd VimEnter *.v : LoadCompletionFile /home/kaifeng/.vim/plugin/verilog.txt
autocmd VimEnter *.v : call LoadMoudlesFromFile(0)
set autowrite
autocmd CursorHold *.v silent call AutoLoadCompeletion()
            \| call ShowPopup() 

set wildmode=full
set wildmenu
set completeopt=menuone,noinsert,noselect,preview
set pumheight=10

" 设置补全菜单背景为灰色，前景为黑色
highlight Pmenu ctermbg=black ctermfg=grey

" 设置补全菜单中选中项的背景为红色，前景为白色
highlight PmenuSel ctermbg=red ctermfg=white

" 设置滚动条背景为浅灰色
highlight PmenuSbar ctermbg=lightgray

" 设置滚动条的滚动指示部分为深灰色
highlight PmenuThumb ctermbg=darkgray
"---------------------------------------------------------------------------


 "plugin-config vim-clang-format
let g:clang_format#auto_format=1

" plugin-config cpp-mode
nnoremap <leader>y :CopyCode<cr>
nnoremap <leader>p :PasteCode<cr>
nnoremap <leader>u :GoToFunImpl<cr>
nnoremap <silent> <leader>a :Switch<cr>

function! CheckBackspace() abort
    let col = col('.')- 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <TAB>
    \ TriggerAutoComplete(0) ? "\<C-n>" : 
    \ coc#pum#visible()  ? coc#pum#next(1):
    \ CheckBackspace() ? "\<Tab>" :
    \ coc#refresh()

inoremap <expr> <S-TAB> 
    \ TriggerAutoComplete(0) ? "\<C-p>" : 
    \coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

inoremap <silent><expr> <CR> 
    \ TriggerAutoComplete(0) ?  "\<C-y>\<space>" : 
    \coc#pum#visible() ? coc#_select_confirm()
    \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"


nmap <silent> <leader>d :call CocAction('jumpDeclaration')<CR>
nmap <silent> <leader>i :call CocAction('jumpDefinition')<CR>

function! SetupCommandAbbrs(from, to)
  exec 'cnoreabbrev <expr> '.a:from
        \ .' ((getcmdtype() ==# ":" && getcmdline() ==# "'.a:from.'")'
        \ .'? ("'.a:to.'") : ("'.a:from.'"))'
endfunction

"Use C to open coc config
call SetupCommandAbbrs('C', 'CocConfig')

" options {{{
set smarttab
set expandtab
set nohlsearch
set incsearch
set hidden
set nobackup
set nowritebackup
set updatetime=300
set shortmess+=atI
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
set colorcolumn=110
set title
set showmatch
set noshowmode
set mouse=a
set modifiable
set splitright
set splitbelow
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
set wildmode=list:longest
set complete=.,w,b,u,t,i


