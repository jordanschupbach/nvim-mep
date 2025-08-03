vim.print("Loading R configuration...")

local function get_r_info()
  -- Function to retrieve R version, location, and installed packages
  local r_version_cmd = "R --version"
  local r_location_cmd = "which R"
  local r_packages_cmd = "Rscript -e 'installed.packages()[, c(\"Package\", \"Version\")]'"

  -- Execute the commands and capture the output
  local r_version = vim.fn.system(r_version_cmd)
  local r_location = vim.fn.system(r_location_cmd)
  local r_packages = vim.fn.system(r_packages_cmd)

  -- Create a message to display
  local message = "R Version:\n" .. r_version .. "\n" ..
      "R Location:\n" .. r_location .. "\n" ..
      "Installed Packages:\n" .. r_packages

  -- Display the message in Vim
  -- vim.cmd("echo '" .. message:gsub("'", "''") .. "'")
  vim.print(message)
  -- vim.cmd("echo '" .. message .. "'")
end

-- Optionally, call this function on specific events
-- get_r_info() -- Uncomment to automatically get R info on certain triggers


local function mymap(mode, key, value)
  vim.keymap.set(mode, key, value, { silent = true, remap = true })
end


local run_r = function()
  vim.cmd('AsyncRun Rscript %')
  -- Check if copen is already open
  if vim.fn.getqflist({ winid = 0 }).winid == 0 then
    -- Store the current window id
    local current_window = vim.fn.win_getid()
    vim.cmd('copen') -- Open quickfix window
    -- Function to go back to original window after entering quickfix
    vim.cmd('autocmd! BufLeave quickfix lua vim.fn.win_gotoid(' .. current_window .. ')')
  end
end

vim.api.nvim_create_user_command('RunR', run_r, {
  desc = 'Run the current R script',
  nargs = 0,
})


mymap('n', '<A-S-return>', '<CMD>RunR<CR>')




local root_files = {
  '.git',
  -- TODO: Add more root files specific to R projects
}



-- TODO: refactor into R

-- from python
-- require'lspconfig'.pylsp.setup{
--   settings = {
--     pylsp = {
--       plugins = {
--         pycodestyle = {
--           ignore = {'W391'},
--           maxLineLength = 100
--         }
--       }
--     }
--   }
-- }



vim.lsp.start {
  name = 'r',
  root_dir = vim.fs.dirname(vim.fs.find(root_files, { upward = true })[1]),
  cmd = { 'R', '--slave', '-e', "options(lintr = list(trailing_blank_lines_linter = NULL, snake_case_linter = NULL)); languageserver::run()" },
  root_markers = { '.clangd', 'compile_commands.json' },
  filetypes = { 'r', 'R', },
  capabilities = require('user.lsp').make_client_capabilities(),
}
