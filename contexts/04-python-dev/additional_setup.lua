local additional_setup = {}

function additional_setup.post_init()
  local null_ls = require 'null-ls'
  local lspconfig = require 'lspconfig'

  local diagnostics = null_ls.builtins.diagnostics
  local formatting = null_ls.builtins.formatting

  null_ls.setup {
    sources = {
      diagnostics.flake8,
      formatting.black,
      formatting.isort,
    }
  }

  lspconfig.pyright.setup {}
end

return additional_setup

