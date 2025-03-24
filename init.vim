" ~/.config/nvim/init.vim

" 基本设置
syntax on               " 启用语法高亮
set number              " 显示行号
set relativenumber      " 显示相对行号
set tabstop=4           " Tab 键宽度为 4 个空格
set softtabstop=4       " 插入模式下 Tab 键宽度为 4 个空格
set shiftwidth=4        " 自动缩进宽度为 4 个空格
set expandtab           " 将 Tab 转换为空格
set autoindent          " 启用自动缩进
set mouse=a             " 启用鼠标支持
set cursorline          " 高亮当前行
set ruler               " 显示光标位置
set showmode            " 显示当前模式
set bg=dark             " 使用深色背景
set laststatus=2        " 总是显示状态栏
set list lcs=tab:\|\    " 用竖线显示 Tab 字符
set wildmenu            " 启用命令行补全菜单
set wildmode=full       " 命令行补全模式
set completeopt=menuone,noinsert,noselect,preview " 补全选项
set updatetime=500      " 更新时间间隔
set shortmess+=atI      " 缩短消息提示
set signcolumn=yes      " 显示标记列
set nobackup            " 不创建备份文件
set nowritebackup       " 不写入备份文件
set noswapfile          " 不创建交换文件
set noerrorbells        " 关闭错误提示音
set ignorecase          " 搜索时忽略大小写
set smartcase           " 智能大小写匹配
set title               " 显示窗口标题
set showmatch           " 显示匹配括号
set noshowmode          " 不显示模式提示
set modifiable          " 允许修改缓冲区
set splitright          " 垂直分割时向右打开
set splitbelow          " 水平分割时向下打开
set backspace=indent,eol,start " 退格键行为
set encoding=utf-8      " 使用 UTF-8 编码
set binary              " 启用二进制模式
set autoread            " 自动重新加载文件
set mousehide           " 输入时隐藏鼠标
set spelllang=en_US     " 拼写检查语言
set fileformat=unix     " 使用 Unix 文件格式
set formatoptions=c,l,1,p " 格式化选项
set nowrap              " 不自动换行
set complete=.,w,b,u,t,i " 补全选项
highlight Normal ctermbg=NONE guibg=NONE
set runtimepath+=~/.config/nvim/plugin
let mapleader =" "
"let g:codeium_no_map_tab = 1 " 让coc-vim插件不冲突
"绑定codeium插件的补全建议
" 绑定 Alt+Enter 触发 Codeium
"imap <script><silent><nowait><expr> <C-p> codeium#Accept()

" 插件管理（使用 vim-plug）
set runtimepath+=~/.local/share/nvim/plugged
set runtimepath+=~/.local/share/nvim/plugged
lua require('init')
lua require("lazy").setup("plugins")

call plug#begin('~/.local/share/nvim/plugged')
Plug 'scrooloose/nerdtree'
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'rhysd/vim-clang-format', { 'for': ['c', 'cpp'] }
Plug 'chxuan/cpp-mode', { 'for': ['cpp'] }
Plug 'nvim-lua/popup.nvim'
Plug 'derekwyatt/vim-scala'
Plug 'vim-airline/vim-airline'
" 安装 vim-airline 主题插件（可选）
Plug 'vim-airline/vim-airline-themes'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
"Plug 'Exafunction/codeium.vim'
"主题颜色
Plug 'morhetz/gruvbox'
Plug 'Mofiqul/vscode.nvim'
call plug#end()

"fzf配置
"使用 <leader>f 代替 Ctrl-p 来搜索文件
nnoremap <leader>f :Files<CR>
"使用 <leader>b 代替 Ctrl-b 来切换缓冲区
nnoremap <leader>b :Buffers<CR>
"使用 <leader>g 进行 Git 文件搜索
nnoremap <leader>g :GFiles<CR>
"使用 <leader>r 进行 Ripgrep 搜索
nnoremap <leader>r :Rg<Space>

" 自动命令
"autocmd BufWritePost $MYVIMRC source $MYVIMRC
autocmd FileType * setlocal formatoptions-=cro
 "让 Neovim 在启动时自动加载 plugin/ 目录下的所有 .vim 文件
autocmd VimEnter * runtime! plugin/**/*.vim


" NERDTree 配置
map <F2> :NERDTreeMirror<CR>
map <F3> :NERDTreeToggle<CR>
nnoremap f :NERDTreeFind<CR>
" 把 f 映射为这个函数


" Coc.nvim 配置
nmap <silent> <leader>d :call CocAction('jumpDeclaration')<CR>
nmap <silent> <leader>i :call CocAction('jumpDefinition')<CR>
nmap <silent> gd <Plug>(coc-definition)

" 补全菜单样式
highlight Pmenu ctermbg=black ctermfg=grey
highlight PmenuSel ctermbg=red ctermfg=white
highlight PmenuSbar ctermbg=lightgray
highlight PmenuThumb ctermbg=darkgray
highlight Normal ctermbg=NONE guibg=NONE " 让 Neovim 继承终端背景
set background=dark

" 其他配置
if has('persistent_undo')
  set undofile
  set undodir=$HOME/.vim/undo
endif
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g'\"" | endif
endif


"coc-vim相关配置
function! CheckBackspace() abort
    let col = col('.')- 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <TAB>
    \ coc#pum#visible()  ? coc#pum#next(1):
    \ CheckBackspace() ? "\<Tab>" :
    \ coc#refresh()

inoremap <expr> <S-TAB> 
    \coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

"inoremap <silent><expr> <CR> 
    "\coc#pum#visible() ? coc#_select_confirm()
    "\: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR><backspace>"

inoremap <silent><expr> <CR> 
    \ coc#pum#visible() ? coc#_select_confirm()
    \ : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR> "
nmap <silent> <leader>d :call CocAction('jumpDeclaration')<CR>
nmap <silent> <leader>i :call CocAction('jumpDefinition')<CR>

function! SetupCommandAbbrs(from, to)
  exec 'cnoreabbrev <expr> '.a:from
        \ .' ((getcmdtype() ==# ":" && getcmdline() ==# "'.a:from.'")'
        \ .'? ("'.a:to.'") : ("'.a:from.'"))'
endfunction
""""""""

"Use C to open coc config
call SetupCommandAbbrs('C', 'CocConfig')

" 快捷键映射
noremap - $
"智能按键操作
autocmd FileType * inoremap } <ESC>:call Quotation4()<cr><ESC>

autocmd FileType * inoremap ' '<ESC>:call Quotation3()<cr><ESC>

autocmd FileType * inoremap > <ESC>:call Quotation2()<cr><ESC>

autocmd FileType * inoremap " <ESC>:call Quotation1()<cr><ESC>
"自动补全括号
autocmd FileType * inoremap ) )<ESC>i
autocmd FileType * inoremap ] ]<ESC>i
"特殊按键映射
"保存功能
autocmd FileType * map <C-s> :cexpr[]<CR>:cclose<CR>:w<CR>
autocmd FileType * inoremap <C-s> <ESC>:cexpr[]<CR>:cclose<CR>:w<CR>l
"打开终端
autocmd FileType * map <C-t> :term<CR>
autocmd FileType * inoremap <C-t> :<ESC>term<CR>
"保存并退出
autocmd FileType * map <C-q> <ESC>:cclose<CR>:wq!<CR>
autocmd FileType * inoremap <C-q> <ESC>:wq<CR>:cexpr[]<CR>:q!<CR>
"打开/关闭quickfix端口
autocmd FileType * nnoremap <C-c> <ESC>:call Window2()<CR>
autocmd FileType * inoremap <C-c> <ESC>:call Window2()<CR>
" 可视模式下按 Ctrl-C 复制到剪贴板
autocmd FileType * vnoremap <C-c> "+y
autocmd FileType * nnoremap <C-v> "+p
autocmd FileType * inoremap <C-v> <ESC>"+pa
"快速切换括号功能
autocmd FileType * inoremap <C-l> <ESC>:call JumpToClosingParen(1)<CR>la
autocmd FileType * map <C-l> :call JumpToClosingParen(1)<CR>l
autocmd FileType * inoremap <C-h> <ESC>:call JumpToClosingParen(0)<CR>li
autocmd FileType * map <C-h> :call JumpToClosingParen(0)<CR>l
"使用alt键恢复部分普通模式功能
"上下左右
execute "set <M-h>=\eh"
inoremap <M-h> <Left> 

execute "set <M-j>=\ej"
inoremap <M-j> <Down> 

execute "set <M-k>=\ek"
inoremap <M-k> <Up> 

execute "set <M-l>=\el"
inoremap <M-l> <Right> 
"o键打开下一行
autocmd FileType * execute "set <M-o>=\eo"
autocmd FileType * inoremap <M-o> <ESC>o
autocmd FileType * noremap <M-o> <ESC>o
"黏贴
autocmd FileType * execute "set <M-p>=\ep"
autocmd FileType * inoremap <M-p> <ESC>pa

autocmd FileType * execute "set <M-w>=\ew"
autocmd FileType * inoremap <M-w> <ESC>ebdei[1;3A[<0;88;19m[1;3A[<0;88;19m[1;3A[<0;88;19m
autocmd FileType * nnoremap <M-w> <ESC>ebde

imap <A-h> <Left>
imap <A-j> <Down>
imap <A-k> <Up>
imap <A-l> <Right>
autocmd FileType * imap <A-w> <ESC>ebdei
autocmd FileType * nmap <A-w> <ESC>ebde
"注释
noremap <C-x> <ESC>^:call Annotate()<cr><ESC>
inoremap <C-x> <ESC>^:call Annotate()<cr><ESC>
"智能换行
inoremap <C-j> <ESC>^$:call Newline()<cr><ESC>
noremap <C-j> <ESC>^$:call Newline()<cr><ESC>

set termguicolors  " 启用 24 位颜色支持
"colorscheme gruvbox
colorscheme vscode
autocmd! User avante.nvim 
autocmd! User copilot

" 运行 init.lua 配置

autocmd VimEnter * source ~/gits/dotfiles/.vim/plugin/chisel_function/configuration.vim
