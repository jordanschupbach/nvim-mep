



local function mymap(mode, key, value)
  vim.keymap.set(mode, key, value, { silent = true, remap = true })
end

local root_files = {
  '.git',
}


vim.lsp.start {
  name = 'jedi',
  root_dir = vim.fs.dirname(vim.fs.find(root_files, { upward = true })[1]),
  cmd = { 'jedi-language-server' },
  root_markers = { '.git' },
  filetypes = { 'python' },
  capabilities = require('user.lsp').make_client_capabilities(),
}





