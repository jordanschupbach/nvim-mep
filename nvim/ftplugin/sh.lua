

-- vim.lsp.enable('bashls')

vim.lsp.start {
  name = 'bashls',
  root_dir = vim.fs.dirname(vim.fs.find(root_files, { upward = true })[1]),
  cmd = { 'bash-language-server', 'start' },
  root_markers = { '.git' },
  filetypes = { 'bash', 'sh', 'zsh' },
  capabilities = require('user.lsp').make_client_capabilities(),
}
