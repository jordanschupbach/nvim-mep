



local function mymap(mode, key, value)
  vim.keymap.set(mode, key, value, { silent = true, remap = true })
end

local root_files = {
  '.git',
}


require'lspconfig'.pylsp.setup{
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = {
          ignore = {'W391'},
          maxLineLength = 100
        }
      }
    }
  }
}


vim.lsp.start {
  name = 'pylsp',
  root_dir = vim.fs.dirname(vim.fs.find(root_files, { upward = true })[1]),
  cmd = { 'pylsp' },
  root_markers = { '.git' },
  filetypes = { 'python' },
  capabilities = require('user.lsp').make_client_capabilities(),
}


