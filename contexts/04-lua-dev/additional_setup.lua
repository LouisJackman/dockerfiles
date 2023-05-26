local additional_setup = {}

function additional_setup.post_init()
  local lsp_root = '/home/user/.local/lua-language-server'

  vim.api.nvim_create_autocmd('filetype', {
    pattern = 'lua',

    callback = function()
      vim.opt.tabstop = 2
      vim.opt.shiftwidth = 2
      vim.opt.softtabstop = 2

      vim.lsp.start {
        name = 'sumneko_lua',
        cmd = {
          lsp_root .. '/bin/lua-language-server',
          '-E',
          lsp_root .. '/bin/main.lua',
        },
      }
    end,
  })
end

return additional_setup

