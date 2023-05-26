local additional_setup = {}

function additional_setup.post_init()
  local lspconfig = require 'lspconfig'

  vim.g.terraform_fmt_on_save = 1

  lspconfig.terraformls.setup {}
end

return additional_setup

