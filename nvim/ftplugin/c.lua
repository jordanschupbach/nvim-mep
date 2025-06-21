

vim.cmd("echo 'Hello, world (cpp)'")

local root_files = {
  '.git',
}


print('About to start clangd?')
vim.lsp.start {
  name = 'cpp',
  root_dir = vim.fs.dirname(vim.fs.find(root_files, { upward = true })[1]),
  cmd = { 'clangd' },
  root_markers = { '.clangd', 'compile_commands.json' },
  filetypes = { 'c', 'cpp' },
  capabilities = require('user.lsp').make_client_capabilities(),
}

