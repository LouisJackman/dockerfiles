filetype plugin on
syntax on

let s:setup = {}

function! s:setup.SetOptions()
    set cursorline
    set expandtab
    set guicursor
    set hidden
    set hlsearch
    set incsearch
    set nobackup
    set noswapfile
    set nowritebackup
    set path+=**
    set scrolloff=5
    set shiftwidth=4
    set smartcase
    set smartindent
    set softtabstop=4
    set tabstop=4
    set textwidth=80
    set ttyfast
    set wildmenu
    set wildmode=longest:full,full
    set wrap
endfunction

function! s:setup.LockDownModeline()
    set nomodeline
    set modelines=0
endfunction

function! s:setup.BindKeys()
    " Keybindings here are solely for ergonomics and should not otherwise work
    " against Vim conventions.

    let g:mapleader = ' '

    noremap <leader>ev :edit $MYVIMRC<cr>
    noremap <leader>sv :source $MYVIMRC<cr>

    inoremap fd <esc>
    vnoremap fd <esc>
    inoremap <esc> <nop>
    vnoremap <esc> <nop>

    noremap <leader>d :bdelete<cr>
    noremap <leader>c <c-w>c

    noremap <leader>h <c-w>h
    noremap <leader>j <c-w>j
    noremap <leader>k <c-w>k
    noremap <leader>l <c-w>l
    noremap <leader>v <c-w>v
    noremap <leader>s <c-w>s
    noremap <leader>c <c-w>c
    noremap <leader>o <c-w>o

    noremap <leader>< <c-w><
    noremap <leader>> <c-w>>
    noremap <leader>+ <c-w>+
    noremap <leader>- <c-w>-
    noremap <leader>= <c-w>=

    noremap <leader>sp :set paste<cr>
    noremap <leader>np :set nopaste<cr>

    noremap <leader>hl :set hlsearch<cr>
    noremap <leader>nh :set nohlsearch<cr>

    noremap <leader>lo :lopen<cr>
    noremap <leader>lc :lclose<cr>
    noremap <leader>ln :lnext<cr>
    noremap <leader>lp :lprevious<cr>
    noremap <leader>lf :lfirst<cr>
    noremap <leader>lla :llast<cr>
    noremap <leader>lli :llist<cr>

    noremap <leader>co :copen<cr>
    noremap <leader>cc :cclose<cr>
    noremap <leader>cn :cnext<cr>
    noremap <leader>cp :cprevious<cr>
    noremap <leader>cf :cfirst<cr>
    noremap <leader>cla :clast<cr>
    noremap <leader>cli :clist<cr>

    noremap <leader>tn :tabnew<cr>

    nnoremap n nzz
    nnoremap N Nzz
    nnoremap * *zz
    nnoremap # #zz
    nnoremap g* g*zz
    nnoremap g# g#zz
endfunction

function! s:setup.SetupBasePlugins()
    let g:ctrlp_map = '<c-p>'

    let g:ctrlp_custom_ignore = '\v[\/](node_modules|target|dist)|(\.(swp|ico|git|svn))$'

    colorscheme nord

    " Workaround some Vims not being compiled with support for the conceal
    " feature, which results in NERDTree showing junk characters.
    let g:NERDTreeNodeDelimiter = "\u00a0"

    noremap <c-n> :NERDTreeToggle<cr>

    let g:airline_theme='nord'

    autocmd StdinReadPre * let s:std_in=1
    autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

    let g:deoplete#enable_at_startup = 1
endfunction

function! s:setup.SetupAdditionalPlugins()
    let l:vimpath = expand("~/.local/share/nvim/autoload/additional_plugins.vim")
    if filereadable(vimpath)
        call additional_plugins#Setup()
    endif
endfunction

function! s:setup.Setup() dict
    call self.SetOptions()
    call self.LockDownModeline()
    call self.BindKeys()
    call self.SetupBasePlugins()
    call self.SetupAdditionalPlugins()
endfunction

call s:setup.Setup()

