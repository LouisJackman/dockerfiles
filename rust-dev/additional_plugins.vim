function! additional_plugins#Setup()
    let g:rustfmt_autosave = 1

    let g:LanguageClient_serverCommands = {
                \   'rust': ['rust-analyzer'],
                \}
endfunction

