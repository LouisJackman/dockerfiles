function! additional_plugins#get_wanted_packages()
  return [
  \ ['https://github.com/hashivim/vim-terraform.git', { 'commit': '89c47c6c68f6260ba34ee0733437d863046fbe95' }]
  \ ]
endfunction

function! additional_plugins#setup()
    let g:terraform_fmt_on_save=1
endfunction

