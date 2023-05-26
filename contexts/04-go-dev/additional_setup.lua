local additional_setup = {}

function additional_setup.post_init()
  local lspconfig = require 'lspconfig'

  vim.api.nvim_create_autocmd('filetype', {
    pattern = 'go',

    callback = function()
      vim.opt.expandtab = false
    end
  })

  lspconfig.gopls.setup {}
end

return additional_setup

