function! additional_plugins#get_wanted_packages()
  return [
      \ ['https://github.com/fatih/vim-go.git', { 'tag': '1.14' }]
      \ ]
endfunction

function! additional_plugins#setup()
  augroup go
    autocmd!
    autocmd filetype go set noexpandtab
  augroup END
endfunction

