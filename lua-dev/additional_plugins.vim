function! additional_plugins#get_wanted_packages()
  return [
      \ ['https://github.com/wsdjeg/vim-lua.git', { 'commit': '9eecdb726a73e0582fafbb3cde340d61b77b26a9' }]
      \ ]
endfunction

function! additional_plugins#setup()
    augroup lua
        autocmd!
        autocmd filetype lua set tabstop=2
        autocmd filetype lua set shiftwidth=2
        autocmd filetype lua set softtabstop=2
    augroup END
endfunction

