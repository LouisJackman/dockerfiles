local additional_setup = {}

function additional_setup.post_init()
  local lspconfig = require 'lspconfig'
  lspconfig.clangd.setup {}
end

return additional_setup

