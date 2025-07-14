
vim.cmd("echo 'Entering fortran ftplugin'")




local root_files = {
  '.git',
}

-- vim.lsp.enable('fortls')

vim.lsp.start {
  name = 'fortran',
  root_dir = vim.fs.dirname(vim.fs.find(root_files, { upward = true })[1]),
  cmd = { 'fortls' },
  root_markers = { '.git' },
  filetypes = { 'f', 'f90' },
  capabilities = require('user.lsp').make_client_capabilities(),
}

