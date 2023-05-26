local additional_setup = {}

function additional_setup.post_init()
  local lspconfig = require 'lspconfig'
  lspconfig.rust_analyzer.setup {}
end

return additional_setup
