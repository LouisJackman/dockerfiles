function! additional_plugins#Setup()
    augroup lua
        autocmd!
        autocmd filetype lua set tabstop=2
        autocmd filetype lua set shiftwidth=2
        autocmd filetype lua set softtabstop=2
    augroup END
endfunction

