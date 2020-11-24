function! additional_plugins#get_wanted_packages()
  return [
      \ ['https://github.com/pangloss/vim-javascript',    { 'commit': '2e4a8c485cdf601bb2f2761ea68c09750a0b82e0' }],
      \ ['https://github.com/MaxMEllon/vim-jsx-pretty',   { 'tag': 'v3.0.0'                                      }],
      \ ['https://github.com/leafgarland/typescript-vim', { 'commit': '616186fd8a04afa32bae8dc0b70ab7f9cdb427fd' }],
      \ ['https://github.com/ianks/vim-tsx',              { 'commit': '77c89c42e189fefd3c9a632b37b7e3b3b9edf918' }],
      \]
endfunction

function! additional_plugins#setup()
  augroup filetype typescript,typescript.tsx,javascript
    set tabstop=2
    set shiftwidth=2
    set softtabstop=2
  augroup END
endfunction

