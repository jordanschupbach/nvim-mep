
local root_files = {
  '.git',
  -- TODO: Add more root files specific to R projects
}

vim.lsp.start {
  name = 'r',
  root_dir = vim.fs.dirname(vim.fs.find(root_files, { upward = true })[1]),
  cmd = { 'R', '--slave', '-e', "options(lintr = list(trailing_blank_lines_linter = NULL, snake_case_linter = NULL)); languageserver::run()" },
  root_markers = { '.clangd', 'compile_commands.json' },
  filetypes = { 'r', 'R', },
  capabilities = require('user.lsp').make_client_capabilities(),
}

