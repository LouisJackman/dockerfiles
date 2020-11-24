filetype plugin on
syntax on

let g:init = {}

function! init.SetOptions() abort
  set cursorline
  set expandtab
  set hidden
  set hlsearch
  set incsearch
  set nobackup
  set noswapfile
  set nowritebackup
  set number
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

function! init.LockDownModeline() abort
  set nomodeline
  set modelines=0
endfunction

function! init.BindKeys() abort
  " Keybindings here are solely for ergonomics and should not otherwise work
  " against Vim conventions.

  let g:mapleader = ' '

  noremap <silent> <leader>ev :edit $MYVIMRC<cr>
  noremap <silent> <leader>sv :source $MYVIMRC<cr>

  inoremap fd <esc>
  vnoremap fd <esc>

  noremap <silent> <leader>w :write<cr>
  noremap <silent> <leader>q :quit<cr>

  noremap <silent> <leader>d :bdelete<cr>
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

  noremap <silent> <leader>sp :set paste<cr>
  noremap <silent> <leader>np :set nopaste<cr>

  noremap <silent> <leader>hl :set hlsearch<cr>
  noremap <silent> <leader>nh :set nohlsearch<cr>

  noremap <silent> <leader>lo :lopen<cr>
  noremap <silent> <leader>lc :lclose<cr>
  noremap <silent> <leader>ln :lnext<cr>
  noremap <silent> <leader>lp :lprevious<cr>
  noremap <silent> <leader>lf :lfirst<cr>
  noremap <silent> <leader>lla :llast<cr>
  noremap <silent> <leader>lli :llist<cr>

  noremap <silent> <leader>co :copen<cr>
  noremap <silent> <leader>cc :cclose<cr>
  noremap <silent> <leader>cn :cnext<cr>
  noremap <silent> <leader>cp :cprevious<cr>
  noremap <silent> <leader>cf :cfirst<cr>
  noremap <silent> <leader>cla :clast<cr>
  noremap <silent> <leader>cli :clist<cr>

  noremap <silent> <leader>tn :tabnew<cr>

  nnoremap n nzz
  nnoremap N Nzz
  nnoremap * *zz
  nnoremap # #zz
  nnoremap g* g*zz
  nnoremap g# g#zz
endfunction

function! init.SetupStandardLanguages() abort
  augroup filetype yaml
    set tabstop=2
    set shiftwidth=2
    set softtabstop=2
  augroup END
endfunction

function! init.InstallPackages(packages) abort
  call plug#begin(stdpath('data') . '/plugged')

  try
    for pkg in a:packages
      let [name; args] = pkg

      let l = len(args)
      if l < 1
        let opts = {}
      elseif 1 < l
        throw 0
      else
        let opts = args[0]
      endif

      Plug name, opts
    endfor

  finally
    call plug#end()
  endtry
endfunction

function! init.HasAdditions() abort
  let l:vimpath = stdpath('config') . '/autoload/additional_plugins.vim'
  return filereadable(vimpath)
endfunction

function! init.SetupPackages() abort dict
  let packages = [
        \ ['https://github.com/airblade/vim-gitgutter',   { 'commit': 'f614693b2a743d1b28245b2d1534f1180e2be2bf' }],
        \ ['https://github.com/prabirshrestha/vim-lsp',   { 'commit': 'e1adf0f84ec232905d9cd155111fae33607ea2fb' }],
        \ ['https://github.com/tpope/vim-fugitive',       { 'commit': '660d2ba2b60026a9069ee005562ddad6a67f9fb0' }],
        \ ['https://github.com/tpope/vim-surround',       { 'commit': 'f51a26d3710629d031806305b6c8727189cd1935' }],
        \ ['https://github.com/vim-airline/vim-airline',  { 'commit': 'a48f67657ff261422845d367772de38618ccc049' }],
        \ ['https://github.com/preservim/tagbar',         { 'commit': '9b8619bab586ac2d4791541f42e1664d38e6335d' }],
        \ ['https://github.com/junegunn/fzf',             { 'dir': '~/.fzf','do': './install --all'              }],
        \ ['https://github.com/junegunn/fzf.vim',         { 'commit': '53b3aea0da5e3581e224c958dbc13558cbe5daee' }],
        \ ['https://github.com/arcticicestudio/nord-vim', { 'commit': 'ea7ff9c343392ec6dfac4e9ec3fe0c45afb92a40' }],
        \ ['https://github.com/neoclide/coc.nvim',        { 'commit': '98c0fb13bf1f49dc3f717acd8d11614a2a1ab2d1' }],
        \ ]

  if self.HasAdditions()
    try
      let additional = additional_plugins#get_wanted_packages()
    catch /:E117:.\{-}additional_plugins#get_wanted_packages\(\)/
      let additional = []
    endtry
    let packages += additional
  endif

  call self.InstallPackages(packages)
endfunction

function! init.SetupBasePlugins() abort
  colorscheme nord

  noremap <silent><leader>e :CocCommand explorer<cr>

  let g:airline_theme='nord'

  function! s:ExploreWithCoc() abort
    if (argc() == 0) && !exists("s:std_in")
      CocCommand explorer
    endif
  endfunction

  autocmd StdinReadPre * let s:std_in=1
  autocmd VimEnter * call s:ExploreWithCoc()

  noremap <silent><leader>f :Rg<cr>

  call self.SetupFzf()
  call self.SetupCoc()
endfunction

function! init.SetupFzf() abort
  noremap <silent> <leader>p :FZF<cr>

  let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }

  let g:fzf_action = {
        \ 'ctrl-t': 'tab split',
        \ 'ctrl-s': 'split',
        \ 'ctrl-v': 'vsplit'
        \}
endfunction

function! init.SetupCoc() abort

  " Don't pass messages to |ins-completion-menu|.
  set shortmess+=c

  " Always show the signcolumn, otherwise it would shift the text each time
  " diagnostics appear/become resolved.
  set signcolumn=number

  " Use tab for trigger completion with characters ahead and navigate.
  " NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
  " other plugin before putting this into your config.
  inoremap <silent><expr> <TAB>
        \ pumvisible() ? "\<C-n>" :
        \ <SID>check_back_space() ? "\<TAB>" :
        \ coc#refresh()
  inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

  function! ShowDocIfNoDiagnostic(timer_id)
    if (coc#float#has_float() == 0)
      silent call CocActionAsync('doHover')
    endif
  endfunction

  function! s:show_hover_doc()
    call timer_start(500, 'ShowDocIfNoDiagnostic')
  endfunction

  autocmd CursorHoldI * :call <SID>show_hover_doc()
  autocmd CursorHold * :call <SID>show_hover_doc()

  function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
  endfunction

  " Use <c-space> to trigger completion.
  inoremap <silent><expr> <c-space> coc#refresh()

  " Make <CR> auto-select the first completion item and notify coc.nvim to
  " format on enter, <cr> could be remapped by other vim plugin
  inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
        \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

  " Use `[g` and `]g` to navigate diagnostics
  " Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
  nmap <silent> [g <Plug>(coc-diagnostic-prev)
  nmap <silent> ]g <Plug>(coc-diagnostic-next)

  " GoTo code navigation.
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation)
  nmap <silent> gr <Plug>(coc-references)

  " Use K to show documentation in preview window.
  nnoremap <silent> K :call <SID>show_documentation()<CR>

  function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
      execute 'h '.expand('<cword>')
    elseif (coc#rpc#ready())
      call CocActionAsync('doHover')
    else
      execute '!' . &keywordprg . " " . expand('<cword>')
    endif
  endfunction

  " Highlight the symbol and its references when holding the cursor.
  autocmd CursorHold * silent call CocActionAsync('highlight')

  " Symbol renaming.
  nmap <leader>rn <Plug>(coc-rename)

  augroup mygroup
    autocmd!
    " Setup formatexpr specified filetype(s).
    autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
    " Update signature help on jump placeholder.
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
  augroup end

  " Applying codeAction to the selected region.
  " Example: `<leader>aap` for current paragraph
  xmap <leader>a  <Plug>(coc-codeaction-selected)
  nmap <leader>a  <Plug>(coc-codeaction-selected)

  " Remap keys for applying codeAction to the current buffer.
  nmap <leader>ac  <Plug>(coc-codeaction)
  " Apply AutoFix to problem on the current line.
  nmap <leader>qf  <Plug>(coc-fix-current)

  " Map function and class text objects
  " NOTE: Requires 'textDocument.documentSymbol' support from the language server.
  xmap if <Plug>(coc-funcobj-i)
  omap if <Plug>(coc-funcobj-i)
  xmap af <Plug>(coc-funcobj-a)
  omap af <Plug>(coc-funcobj-a)
  xmap ic <Plug>(coc-classobj-i)
  omap ic <Plug>(coc-classobj-i)
  xmap ac <Plug>(coc-classobj-a)
  omap ac <Plug>(coc-classobj-a)

  " Use CTRL-S for selections ranges.
  " Requires 'textDocument/selectionRange' support of language server.
  nmap <silent> <C-s> <Plug>(coc-range-select)
  xmap <silent> <C-s> <Plug>(coc-range-select)

  " Add `:Format` command to format current buffer.
  command! -nargs=0 Format :call CocAction('format')

  " Add `:Fold` command to fold current buffer.
  command! -nargs=? Fold :call     CocAction('fold', <f-args>)

  " Add `:OR` command for organize imports of the current buffer.
  command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

  " Add (Neo)Vim's native statusline support.
  " NOTE: Please see `:h coc-status` for integrations with external plugins that
  " provide custom statusline: lightline.vim, vim-airline.
  set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

endfunction

function! init.SetupAdditionalPlugins() abort dict
  if self.HasAdditions()
    try
      call additional_plugins#setup()
    catch /:E117:.\{-}additional_plugins#setup\(\)/
    endtry
  endif
endfunction

function! init.Setup() abort dict
  if $IS_INITIAL_NVIM_HEADLESS_INSTALL
    call self.SetupPackages()
    PlugInstall
  else
    call self.SetOptions()
    call self.LockDownModeline()
    call self.BindKeys()
    call self.SetupStandardLanguages()
    call self.SetupPackages()
    call self.SetupBasePlugins()
    call self.SetupAdditionalPlugins()
  endif
endfunction

call init.Setup()

