local additional_setup = {}

function additional_setup.post_init()
  local lspconfig = require 'lspconfig'

  vim.api.nvim_create_autocmd('filetype', {
    pattern = 'javascript.jsx,typescript.tsx,javascript',

    callback = function()
      vim.opt.tabstop = 2
      vim.opt.shiftwidth = 2
      vim.opt.softtabstop = 2
    end,
  })

  lspconfig.tsserver.setup {}
  lspconfig.stylelint_lsp.setup {}
end

return additional_setup

