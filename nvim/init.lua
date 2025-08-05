vim.loader.enable()

-- {{{ aliases

local cmd = vim.cmd
local opt = vim.o

-- }}} aliases

-- {{{ Prior config

-- <leader> key. Defaults to `\`. Some people prefer space.
-- The default leader is '\'. Some people prefer <space>. Uncomment this if you do, too.
-- vim.g.mapleader = ' '
-- vim.g.maplocalleader = ' '

-- See :h <option> to see what the options do

-- Search down into subfolders

opt.cmdheight = 0
opt.cursorline = true
opt.expandtab = true
opt.foldenable = true
opt.history = 2000
opt.hlsearch = true
opt.incsearch = true
opt.lazyredraw = true
opt.nrformats = 'bin,hex' -- 'octal'
opt.number = true
opt.path = vim.o.path .. '**'
opt.relativenumber = true
opt.shiftwidth = 2
opt.showmatch = true -- Highlight matching parentheses, etc
opt.softtabstop = 2
opt.spell = true
opt.spelllang = 'en'
opt.splitbelow = true
opt.splitright = true
opt.tabstop = 2
opt.undofile = true

-- opt.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
opt.colorcolumn = '100'

-- Configure Neovim diagnostic messages

local function prefix_diagnostic(prefix, diagnostic)
  return string.format(prefix .. ' %s', diagnostic.message)
end

vim.diagnostic.config {
  virtual_text = {
    prefix = '',
    format = function(diagnostic)
      local severity = diagnostic.severity
      if severity == vim.diagnostic.severity.ERROR then
        return prefix_diagnostic('󰅚', diagnostic)
      end
      if severity == vim.diagnostic.severity.WARN then
        return prefix_diagnostic('⚠', diagnostic)
      end
      if severity == vim.diagnostic.severity.INFO then
        return prefix_diagnostic('ⓘ', diagnostic)
      end
      if severity == vim.diagnostic.severity.HINT then
        return prefix_diagnostic('󰌶', diagnostic)
      end
      return prefix_diagnostic('■', diagnostic)
    end,
  },
  signs = {
    text = {
      -- Requires Nerd fonts
      [vim.diagnostic.severity.ERROR] = '󰅚',
      [vim.diagnostic.severity.WARN] = '⚠',
      [vim.diagnostic.severity.INFO] = 'ⓘ',
      [vim.diagnostic.severity.HINT] = '󰌶',
    },
  },
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = {
    focusable = false,
    style = 'minimal',
    border = 'rounded',
    source = 'if_many',
    header = '',
    prefix = '',
  },
}

-- Native plugins
cmd.filetype('plugin', 'indent', 'on')
cmd.packadd('cfilter') -- Allows filtering the quickfix list with :cfdo

-- let sqlite.lua (which some plugins depend on) know where to find sqlite
-- vim.g.sqlite_clib_path = require('luv').os_getenv('LIBSQLITE')

-- }}} Prior config

-- {{{ Plugin Free Key mappings

local function mymap(mode, key, value)
  vim.keymap.set(mode, key, value, { silent = true, remap = true })
end

---@diagnostic disable-next-line: unused-function, unused-local
local function toggle_quickfix()
  if vim.fn.empty(vim.fn.getqflist()) == 1 then
    print('Quickfix list is empty!')
    return
  end
  local quickfix_open = false
  local windows = vim.api.nvim_list_wins()
  for _, win in ipairs(windows) do
    local wininfo = vim.fn.getwininfo(win)[1]
    if wininfo.loclist == 0 and wininfo.quickfix == 1 then
      quickfix_open = true
      break
    end
  end
  if quickfix_open then
    vim.cmd('cclose')
  else
    vim.cmd('copen')
  end
end

---@diagnostic disable-next-line: lowercase-global
show_line_diagnostics = function()
  local line_diagnostics = vim.diagnostic.get(0, { lnum = vim.api.nvim_win_get_cursor(0)[1] })
  if line_diagnostics then
    vim.diagnostic.open_float(0, { severity_limit = 'Error' })
  end
end

mymap('n', 'g:', '<CMD>term<CR>')

mymap('n', '<Space>tn', '<CMD>lua toggle_number()<CR>')

mymap('n', '<Space>tt', '<CMD>lua toggle_todo()<CR>')

mymap('n', '<Space>cc', '<CMD>CodeCompanionChat<CR>')
-- mymap('n', '<Space>cc', '<CMD>CToggle<CR>')
mymap('n', '<Space>co', '<CMD>CToggle<CR>')
-- mymap('n', '<A-S-return>', '<CMD>silent make<CR>')
mymap('n', '<Space>mm', '<CMD>silent make<CR>')
mymap('n', ']e', '<CMD>lua vim.diagnostic.goto_next()<CR>')
mymap('n', '<Space>ht', '<CMD>Tutor<CR>')
mymap('n', '<A-Tab>', '<CMD>bn<CR>')
mymap('n', '<A-S-Tab>', '<CMD>bp<CR>')
mymap('n', '<Space>oc', '<CMD>OpenConfig<CR>')
mymap('n', '<Space>bn', '<CMD>bn<CR>')
mymap('n', '<Space>bp', '<CMD>bp<CR>')
mymap('n', 'gD', '<CMD>lua vim.lsp.buf.declaration()<CR>')
mymap('n', 'gd', '<CMD>lua vim.lsp.buf.definition()<CR>')
mymap('n', 'K', '<CMD>lua vim.lsp.buf.hover()<CR>')
mymap('n', 'I', '<CMD>lua show_line_diagnostics()<CR>')
-- mymap('n', 'I', '<CMD>lua vim.diagnostic.show_line_diagnostics()<CR>')
mymap('n', 'gi', '<CMD>lua vim.lsp.buf.implementation()<CR>')

-- Window right
mymap('n', '<A-l>', '<CMD>wincmd l<CR>')
mymap('t', '<A-l>', '<CMD>wincmd l<CR>')
mymap('n', '<Space>wl', '<CMD>wincmd l<CR>')
mymap('t', '<Space>wl', '<CMD>wincmd l<CR>')
mymap('n', '<A-S-l>', "<CMD>lua require('smart-splits').resize_right()<CR>")
mymap('t', '<A-S-l>', "<CMD>lua require('smart-splits').resize_right()<CR>")

-- Window left
mymap('n', '<A-h>', '<CMD>wincmd h<CR>')
mymap('t', '<A-h>', '<CMD>wincmd h<CR>')
mymap('n', '<Space>wh', '<CMD>wincmd h<CR>')
mymap('t', '<Space>wh', '<CMD>wincmd h<CR>')
mymap('n', '<A-S-h>', "<CMD>lua require('smart-splits').resize_left()<CR>")
mymap('t', '<A-S-h>', "<CMD>lua require('smart-splits').resize_left()<CR>")

-- Window down
mymap('n', '<A-j>', '<CMD>wincmd j<CR>')
mymap('t', '<A-j>', '<CMD>wincmd j<CR>')
mymap('n', '<Space>wj', '<CMD>wincmd j<CR>')
mymap('t', '<Space>wj', '<CMD>wincmd j<CR>')
mymap('n', '<A-S-j>', "<CMD>lua require('smart-splits').resize_down()<CR>")
mymap('t', '<A-S-j>', "<CMD>lua require('smart-splits').resize_down()<CR>")

-- Window up
mymap('n', '<A-k>', '<CMD>wincmd k<CR>')
mymap('t', '<A-k>', '<CMD>wincmd k<CR>')
mymap('n', '<Space>wk', '<CMD>wincmd k<CR>')
mymap('t', '<Space>wk', '<CMD>wincmd k<CR>')
mymap('n', '<A-S-k>', "<CMD>lua require('smart-splits').resize_up()<CR>")
mymap('t', '<A-S-k>', "<CMD>lua require('smart-splits').resize_up()<CR>")
mymap(
  'n',
  '<A-S-->',
  "<CMD>lua require('smart-splits').resize_up()<CR><CMD>lua require('smart-splits').resize_left()<CR>"
)
mymap(
  'n',
  '<A-S-=>',
  "<CMD>lua require('smart-splits').resize_down()<CR><CMD>lua require('smart-splits').resize_right()<CR>"
)

-- Split pane horizontal
mymap('n', '<A-s>', '<CMD>split<CR>')
mymap('n', '<Space>ws', '<CMD>split<CR>')
mymap('t', '<A-s>', '<CMD>split<CR>')

-- Split pane vertical
mymap('n', '<A-v>', '<CMD>vsplit<CR>')
mymap('n', '<Space>wv', '<CMD>vsplit<CR>')
mymap('t', '<A-v>', '<CMD>vsplit<CR>')

-- Delete pane
mymap('n', '<A-d>', '<CMD>close<CR>')
mymap('n', '<Space>wd', '<CMD>close<CR>')
mymap('t', '<A-d>', '<CMD>close<CR>')

-- Project Shell
mymap('n', '<Space>ps', '<CMD>sp<CR> <CMD>wincmd j<CR> <CMD>terminal<CR> a')
mymap('t', '<Space>ps', '<CMD>sp<CR> <CMD>wincmd j<CR> <CMD>terminal<CR> a')
mymap('n', '<C-t>', '<CMD>tabnew<CR>')
mymap('n', '<A-1>', ':tabn1<CR>')
mymap('n', '<A-2>', ':tabn2<CR>')
mymap('n', '<A-3>', ':tabn3<CR>')
mymap('n', '<A-4>', ':tabn4<CR>')
mymap('n', '<A-5>', ':tabn5<CR>')
mymap('n', '<A-6>', ':tabn6<CR>')
mymap('n', '<A-7>', ':tabn7<CR>')
mymap('n', '<A-8>', ':tabn8<CR>')
mymap('n', '<A-9>', ':tabn9<CR>')
mymap('n', '<Space>qq', '<CMD>wa<CR><CMD>qa!<CR>')
mymap('n', '<Space>rr', '<CMD>luafile $MYVIMRC<CR><CMD>ReloadFTPlugins<CR><CMD>echo "Reloaded config"<CR>')
mymap('n', '<Space>tgc', '<CMD>Telescope git_commits<CR>')
-- These only work in gvim.... :(
mymap('n', '<C-tab>', '<CMD>tabnext<CR>')
mymap('n', '<C-S-tab>', '<CMD>tabprevious<CR>')

-- }}} Base Key mappings

-- {{{ General Options
vim.g.slime_target = 'neovim'

vim.g.mapleader = ' '
vim.g.maplocalleader = ';'

-- -- Leader keys
--
-- -- Globals
vim.g['gtest#gtest_command'] = './build/tests/tests'
vim.g['test#cpp#runner'] = 'ctest'
vim.g['test#cpp#catch2#bin_dir'] = '../build/tests/'
vim.g.gui_font_face = 'UbuntuMono Nerd Font Mono - Bold'
vim.g.gui_font_size = 12
vim.g.mapleader = ' '
vim.g.maplocalleader = ','
vim.g.minimap_auto_start = 0
vim.g.minimap_auto_start_win_enter = 1
vim.g.minimap_width = 2
-- TODO: check this exists in nix
vim.g.python_host_program = '/usr/bin/python'
-- vim.g.python_host_program = '/usr/bin/python'

-- Opts
-- vim.opt.splitright = true

vim.opt.backspace = { 'eol', 'start', 'indent' }
vim.opt.backup = false
vim.opt.belloff = 'all'
vim.opt.breakindent = true
vim.opt.clipboard = 'unnamedplus'
vim.opt.cmdheight = 2
vim.opt.colorcolumn = '120'
vim.opt.completeopt = { 'menuone', 'noselect' }
vim.opt.conceallevel = 0
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.fileencoding = 'utf-8'
vim.opt.fillchars = {
  stl = '━',
  stlnc = '━',
  horiz = '━',
  horizup = '┻',
  horizdown = '┳',
  vert = '┃',
  vertleft = '┫',
  vertright = '┣',
  verthoriz = '╋',
}
vim.opt.statusline = ''
vim.opt.foldmethod = 'marker'
vim.opt.formatoptions:append('rn1')
vim.opt.formatoptions:remove('oa2')
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.incsearch = false
vim.opt.joinspaces = false
vim.opt.laststatus = 2
vim.opt.laststatus = 2                                  -- Always show the status line
vim.opt.statusline = '%f %y %m %r %=%-14.(%l,%c%V%) %P' -- Example status line
vim.opt.statusline = ''
vim.opt.list = true
vim.opt.listchars = { tab = '»·', trail = '·', extends = '↪', precedes = '↩' }
vim.opt.mouse = 'a'
vim.opt.number = false
vim.opt.pumblend = 0
vim.opt.pumheight = 15
vim.opt.relativenumber = false
vim.opt.scrolloff = 5
vim.opt.shiftwidth = 2
vim.opt.showtabline = 2
vim.opt.sidescrolloff = 8
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.spell = false
vim.opt.spelllang = 'en_us'
vim.opt.splitbelow = true
vim.opt.swapfile = false
vim.opt.tabstop = 2
vim.opt.termguicolors = true
vim.opt.timeout = true
vim.opt.timeoutlen = 300
vim.opt.undofile = true
vim.opt.updatetime = 300
vim.opt.wildignore = { '*.o', '*~', '*.pyc', '*pycache*' }
vim.opt.wrap = false

-- Misc options
vim.wildmode = { 'full', 'longest', 'lastused' }
vim.wildoptions = 'pum'
vim.wo.number = false
vim.wo.signcolumn = 'yes'

-- }}} General Options

-- {{{ Utility functions

---@diagnostic disable-next-line: lowercase-global
function toggle_number()
  if vim.wo.number then
    vim.wo.number = false
    vim.wo.relativenumber = false
  else
    vim.wo.number = true
    vim.wo.relativenumber = false -- Optional: set to true if you want relative numbers
  end
end

-- Optionally, create a command to call the toggle function
vim.api.nvim_create_user_command('ToggleNumber', toggle_number, {})

vim.api.nvim_create_user_command('RunJust', function()
  local file = vim.fn.expand('%:p')
  local filename = vim.fn.fnamemodify(file, ':t')
  local example_name = filename:gsub('^prefix_cpp_', ''):gsub('%.cpp$', '')
  local args = string.format('run example %s_cpp', example_name)

  -- Run the command asynchronously
  vim.cmd('AsyncRun just ' .. args)

  -- Check if copen is already open
  if vim.fn.getqflist({ winid = 0 }).winid == 0 then
    -- Store the current window id
    local current_window = vim.fn.win_getid()
    vim.cmd('copen') -- Open quickfix window

    -- Function to go back to original window after entering quickfix
    vim.cmd('autocmd! BufLeave quickfix lua vim.fn.win_gotoid(' .. current_window .. ')')
  end
end, {})

---@diagnostic disable-next-line: lowercase-global
function toggle_todo()
  local todo_buffer_name = 'TODO.org'
  local windows = vim.api.nvim_tabpage_list_wins(0)
  local current_win = vim.api.nvim_get_current_win()
  local found = false

  -- Check existing buffers in current windows
  for _, win in ipairs(windows) do
    local buffer = vim.api.nvim_win_get_buf(win)
    if vim.fn.fnamemodify(vim.fn.bufname(buffer), ':t') == todo_buffer_name then
      -- If found, close the buffer
      vim.api.nvim_win_close(win, true) -- Close the window with TODO.org
      found = true
      break
    end
  end

  -- If not found, open TODO.org in a horizontal split
  if not found then
    vim.cmd('split TODO.org')
    vim.cmd('wincmd w') -- Switch to the newly opened split
  else
    -- Restore the original window position
    vim.api.nvim_set_current_win(current_win)
  end
end

-- Command to call the function
vim.api.nvim_create_user_command('ToggleTODO', toggle_todo, {})

--- Open neorepl
-- opens the neorepl in a new split
---@diagnostic disable-next-line: lowercase-global
open_neorepl = function()
  vim.cmd('split')
  local buf = vim.api.nvim_get_current_buf()
  require('neorepl').new { lang = 'lua', buffer = buf }
  vim.cmd('resize 10 | setl winfixheight')
  buf = vim.api.nvim_get_current_buf()
  SendTo_Bufnr = buf
  -- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-w>k', true, false, true), 'm', true)
end

---@diagnostic disable-next-line: lowercase-global
register_sendto_buffer = function()
  local current_bufnr = tostring(vim.fn.bufnr('%'))
  current_bufnr = vim.fn.input('SendTo bufnr: ', current_bufnr)
  SendTo_Bufnr = tonumber(current_bufnr)
end

-- --- Sends current line to SendTo buffer
-- -- @see register_sendto_buffer, send_lines_to_buffer
-- ---@diagnostic disable-next-line: lowercase-global
-- send_line_to_buffer = function()
--   local current_line = vim.api.nvim_get_current_line()
--   local original_bufnr = vim.fn.bufnr('%')
--   local original_cursor_pos = vim.api.nvim_win_get_cursor(0) -- Save cursor position
--
--   if SendTo_Bufnr == nil then
--     register_sendto_buffer()
--   end
--
--   local target_bufnr = SendTo_Bufnr
--   local win_id = vim.fn.bufwinid(target_bufnr)
--
--   if win_id ~= -1 then
--     vim.api.nvim_set_current_win(win_id)
--     vim.cmd('startinsert') -- Enter insert mode
--   else
--     return
--   end
--
--   -- Move to the bottom and insert the line.
--   vim.api.nvim_feedkeys(current_line, 'm', true)                                              -- Input the current line
--   vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<CR>', true, false, true), 'm', true) -- Press Enter
--
--   -- Use vim.schedule to ensure the following code runs after feedkeys
--   vim.schedule(function()
--     -- Return to the original window and restore the cursor position
--     vim.api.nvim_set_current_win(vim.fn.bufwinid(original_bufnr))
--     vim.api.nvim_win_set_cursor(0, original_cursor_pos) -- Restore cursor position
--   end)
-- end

--- Gets the text in the visual selection
-- @return a text string of the current visual selection
---@diagnostic disable: lowercase-global
get_visual_selection = function()
  local s_start = vim.fn.getpos("'<")
  local s_end = vim.fn.getpos("'>")
  local n_lines = math.abs(s_end[2] - s_start[2]) + 1
  local lines = vim.api.nvim_buf_get_lines(0, s_start[2] - 1, s_end[2], false)
  lines[1] = string.sub(lines[1], s_start[3], -1)
  if n_lines == 1 then
    lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3] - s_start[3] + 1)
  else
    lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3])
  end
  return table.concat(lines, '\n')
end

-- --- Gets the text in the visual selection
-- -- @return a table of lines of current visual selection
-- ---@diagnostic disable: lowercase-global
-- get_visual_selection_lines = function()
--   local s_start = vim.fn.getpos("'<")
--   local s_end = vim.fn.getpos("'>")
--   -- Adjust for zero-based indexing
--   local start_line = s_start[2] - 1
--   local end_line = s_end[2] - 1
--   local lines = vim.api.nvim_buf_get_lines(0, start_line, end_line + 1, false)
--   -- Trim the start of the first line if necessary
--   if #lines > 0 then
--     lines[1] = string.sub(lines[1], s_start[3], -1)
--   end
--
--   -- Trim the end of the last line if the selection spans multiple lines
--   if #lines > 1 then
--     lines[#lines] = string.sub(lines[#lines], 1, s_end[3])
--   elseif #lines == 1 then
--     lines[1] = string.sub(lines[1], s_start[3], s_end[3])
--   end
--
--   return lines
-- end

-- --- Sends visual selection to SendTo buffer
-- -- @see register_sendto_buffer, send_line_to_buffer
-- send_lines_to_buffer = function()
--   local current_lines = get_visual_selection_lines()
--   local original_bufnr = vim.fn.bufnr('%')
--   local original_cursor_pos = vim.api.nvim_win_get_cursor(0)
--   local target_bufnr = SendTo_Bufnr
--   local win_id = vim.fn.bufwinid(target_bufnr)
--   -- dump(current_lines)
--   vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<esc>', true, false, true), 'm', true)
--   vim.api.nvim_set_current_win(win_id)
--   vim.cmd('startinsert') -- Enter insert mode
--   -- vim.api.nvim_feedkeys('i', 'm', true) -- Input the current line
--   for _, line in ipairs(current_lines) do
--     vim.api.nvim_feedkeys(line, 'm', true) -- Input the current line
--     vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<CR>', true, false, true), 'm', true)
--   end
--   -- Use vim.schedule to ensure the following code runs after feedkeys
--   vim.schedule(function()
--     -- Return to the original window and restore the cursor position
--     vim.api.nvim_set_current_win(vim.fn.bufwinid(original_bufnr))
--     vim.api.nvim_win_set_cursor(0, original_cursor_pos) -- Restore cursor position
--   end)
-- end

-- function that extracts selected text
extract_selected_text = function()
  -- Get the start and end positions of the selected text
  local start_line, start_col, end_line, end_col = unpack(vim.fn.getpos("'<") + vim.fn.getpos("'>"))
  -- Extract the selected text using the range
  local selected_text = vim.fn.getline(start_line, end_line)
  -- If the selection spans multiple lines, adjust the text
  if start_line ~= end_line then
    selected_text[#selected_text] = selected_text[#selected_text]:sub(1, end_col)
    selected_text[1] = selected_text[1]:sub(start_col)
  else
    selected_text[1] = selected_text[1]:sub(start_col, end_col)
  end
  ---@diagnostic disable-next-line: discard-returns, param-type-mismatch
  table.concat(selected_text, '\n')
end

-- Make sure to require plenary.nvim at the beginning of your Lua configuration
-- local popup = require('plenary.popup')

function extract_selected_text_and_show_popup()
  local popup = require('plenary.popup')
  -- Get the start and end positions of the selected text
  local start_line, start_col, end_line, end_col = unpack(vim.fn.getpos("'<") + vim.fn.getpos("'>"))

  -- Extract the selected text using the range
  local selected_text = vim.fn.getline(start_line, end_line)

  -- If the selection spans multiple lines, adjust the text
  if start_line ~= end_line then
    selected_text[#selected_text] = selected_text[#selected_text]:sub(1, end_col)
    selected_text[1] = selected_text[1]:sub(start_col)
  else
    selected_text[1] = selected_text[1]:sub(start_col, end_col)
  end

  -- Join the lines to create a single string
  ---@diagnostic disable-next-line: discard-returns, param-type-mismatch
  local textstring = table.concat(selected_text, '\n')

  -- Create a popup with the extracted text
  local popup_opts = {
    line = 10,
    col = 10,
    width = #textstring + 4,
    height = #textstring + 2,
    border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
    padding = { 0, 1, 0, 1 },
  }

  local popup_bufnr = vim.api.nvim_create_buf(false, true)
  ---@diagnostic disable-next-line: discard-returns, param-type-mismatch
  vim.api.nvim_buf_set_lines(popup_bufnr, 0, -1, false, vim.fn.split(selected_text, '\n'))
  local popup_winid = popup.create(popup_bufnr, popup_opts)

  -- You can close the popup after a delay (e.g., 5 seconds) if needed
  vim.defer_fn(function()
    vim.api.nvim_win_close(popup_winid, true)
  end, 5000)
end

extract_paragraph_at_cursor = function()
  -- Get the current line number
  local current_line = vim.fn.line('.')

  -- Find the start and end lines of the paragraph
  local start_line = current_line
  local end_line = current_line

  -- Find the start line of the paragraph
  while start_line > 1 and vim.fn.trim(vim.fn.getline(start_line - 1)) ~= '' do
    start_line = start_line - 1
  end

  -- Find the end line of the paragraph
  while end_line < vim.fn.line('$') and vim.fn.trim(vim.fn.getline(end_line + 1)) ~= '' do
    end_line = end_line + 1
  end

  -- Extract the paragraph text
  local paragraph_lines = {}
  for line = start_line, end_line do
    table.insert(paragraph_lines, vim.fn.getline(line))
  end

  -- Join the lines to create a single string
  local paragraph_text = table.concat(paragraph_lines, '\n')

  -- Print or use the extracted paragraph text as needed
  -- print(paragraph_text)
  -- You can also return the extracted paragraph text for further use
  return paragraph_text
end

-- utilities.readFromFile = function(file_path)
--   local file = io.open(file_path, "r");
--   if file then
--     local content = file:read("*a");
--     file:close();
--     return content;
--   else
--     return nil;
--   end
-- end

readFromFile = function(file_path)
  local bufnr = vim.fn.bufadd(file_path)
  if bufnr ~= 0 then
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    vim.api.nvim_buf_delete(bufnr, { force = true })
    if #lines > 0 then
      return table.concat(lines, '\n')
    else
      return 'Error: File is empty.'
    end
  else
    return 'Error: Unable to open the file.'
  end
end

run_shell_command_to_buffer = function(command)
  local output = vim.fn.systemlist(command)
  local bufnr = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, output)
  vim.cmd('enew | setlocal buftype=nofile bufhidden=hide noswapfile')
  vim.cmd('setlocal filetype=text')
  vim.api.nvim_set_current_buf(bufnr)
end

run_shell_to_string = function(command)
  local output = vim.fn.systemlist(command)
  return output
end

readFromFile2 = function(file_path)
  local file = io.open(file_path, 'r') -- Open the file in read mode
  if file then
    local content = file:read('*a')
    file:close()
    if content == '' then
      return 'File was empty'
    else
      return content
    end
    return content
  else
    return 'Error: Unable to open the file.'
  end
end

show_simple_popup = function(text)
  local popup = require('plenary.popup')
  local popup_opts = {
    line = vim.fn.line('.') + 1,
    col = vim.fn.col('.'),
    width = 30,
    height = 3,
    padding = { 0, 1, 0, 1 },
    move_on_insert = true,
    close_on_buf_leave = true,
  }
  ---@diagnostic disable-next-line: discard-returns, param-type-mismatch, unused-local
  local popup_winid, popup_bufnr = popup.create(split_string_at_newlines(text), popup_opts)
end

show_paragraph_in_popup = function()
  local paragraph = extract_paragraph_at_cursor()
  show_simple_popup(paragraph)
end

runRScript = function(text)
  local temp_file1 = vim.fn.tempname()
  local temp_file2 = vim.fn.tempname()
  local file = io.open(temp_file1, 'w')
  if file then
    file:write(text)
    file:close()
  else
    print('Error: Could not open file temp_file1 (' .. temp_file1 .. ') for writing.')
    return
  end
  local command = 'Rscript ' .. temp_file1 .. ' > ' .. temp_file2
  ---@diagnostic disable-next-line: unused-local
  local output = vim.fn.system(command)
  file = io.open(temp_file1, 'w')
  if file then
    file:write(text)
    file:close()
  else
    print('Error: Could not open file for writing.')
    return
  end
  ---@diagnostic disable-next-line: redefined-local
  local file = io.open(temp_file2, 'r')
  if file then
    local content = file:read('*a')
    return content
  else
    print('Unable to read' .. temp_file2)
  end
end

getCurrentBufferFilePath = function()
  local bufnr = vim.fn.bufnr('%')
  if bufnr ~= 0 then
    return vim.fn.bufname(bufnr)
  else
    return nil
  end
end

extractFilename = function(filepath)
  local filename = string.match(filepath, '[^/\\]+$')
  return filename or filepath
end

strip_newline_symbols = function(text)
  local result = text:gsub('\n', '')
  return result
end

run_lua_text = function(text)
  ---@diagnostic disable-next-line: undefined-global
  vim.cmd('lua ' .. replace_newlines_with_semicolons(text))
end

run_lua_paragraph = function()
  local text = extract_paragraph_at_cursor()
  vim.cmd('lua ' .. strip_newline_symbols(text))
end

split_string_at_newlines = function(text)
  local lines = {}
  for line in text:gmatch('[^\r\n]+') do
    table.insert(lines, line)
  end
  return lines
end

---@diagnostic disable-next-line: unused-local
parse_cpp_test_output = function(output)
  ---@diagnostic disable-next-line: unused-local
  local ret = {}
  local test_output = run_shell_to_string('make test')
  local ntest_line_idx = 0
  for key, value in pairs(test_output) do
    if value:find('%f[%a]' .. 'test cases' .. '%f[%A]') then
      ntest_line_idx = key
      -- npass_line_idx = key
    end
  end
  local ntests = 0
  local ntests_passed = 0
  if ntest_line_idx == 0 then
    ntests = 0
    ntests_passed = 0
  else
    ntests, ntests_passed = test_output[ntest_line_idx]:match(': (%d+) | (%d+)')
    -- ntests = tonumber(test_output[ntest_line_idx]:match '%d+')
    -- ntests_passing = tonumber(test_output[npass_line_idx]:match '%d+')
  end
  ret['ntests'] = ntests
  ret['passing'] = ntests_passed
  return ret
end

parse_cpp_coverage_ouput = function()
  local ret = {}
  local lout = ''
  local fout = ''
  local test_output = run_shell_to_string('make coverage')
  local ntest_line_idx = 0
  local npass_line_idx = 0
  for key, value in pairs(test_output) do
    if value:find('%f[%a]' .. 'Overall coverage' .. '%f[%A]') then
      ntest_line_idx = key + 1
      npass_line_idx = key + 2
    end
  end
  ---@diagnostic disable-next-line: unused-local
  local ntests = 0
  ---@diagnostic disable-next-line: unused-local
  local ntests_passing = 0
  if ntest_line_idx == 0 then
    ---@diagnostic disable-next-line: unused-local
    ntests = 0
    ---@diagnostic disable-next-line: unused-local
    ntests_passing = 0
    lout = '100% (0/0)'
    fout = '100% (0/0)'
  else
    ---@diagnostic disable-next-line: unused-local, cast-local-type
    ntests = tonumber(test_output[ntest_line_idx]:match('%d+'))
    ---@diagnostic disable-next-line: unused-local, cast-local-type
    ntests_passing = tonumber(test_output[npass_line_idx]:match('%d+'))
    local lpercentage, lnumerator, ldenominator =
        string.match(test_output[ntest_line_idx], '(%d+%.?%d*)%% %((%d+) of (%d+) lines%)')
    if lpercentage == nil then
      lout = '100% (0/0)'
    else
      lout = '' .. lpercentage .. '%' .. ' (' .. lnumerator .. '/' .. ldenominator .. ')'
    end

    local fpercentage, fnumerator, fdenominator =
        string.match(test_output[npass_line_idx], '(%d+%.?%d*)%% %((%d+) of (%d+) functions%)')
    if fpercentage == nil then
      fout = '100% (0/0)'
    else
      fout = '' .. fpercentage .. '%' .. ' (' .. fnumerator .. '/' .. fdenominator .. ')'
    end
  end
  ret['lines'] = lout
  ret['functions'] = fout
  return ret
end

-- see if the file exists
file_exists = function(file)
  local f = io.open(file, 'rb')
  if f then
    f:close()
  end
  return f ~= nil
end

init_ldmode = function()
  if not file_exists('/home/jordan/.cache/ldmode') then
    local file = io.open('/home/jordan/.cache/ldmode', 'w')
    ---@diagnostic disable-next-line: need-check-nil
    file:write('dark')
    ---@diagnostic disable-next-line: need-check-nil
    file:close()
  end
end

-- get all lines from a file, returns an empty
-- list/table if the file does not exist
lines_from = function(file)
  if not file_exists(file) then
    return {}
  end
  local lines = {}
  for line in io.lines(file) do
    lines[#lines + 1] = line
  end
  return lines
end

get_ldmode = function()
  return lines_from('/home/jordan/.cache/ldmode')
end

waldark_toggle = function()
  io.popen('waldark ')
end

waldark_dark = function()
  io.popen('waldark --dark')
end

waldark_light = function()
  io.popen('waldark --light')
end

swap_window_right = function()
  local current_win = vim.api.nvim_get_current_win()
  local current_buf = vim.api.nvim_win_get_buf(current_win)
  vim.api.nvim_command('wincmd l')
  local right_win = vim.api.nvim_get_current_win()
  local right_buf = vim.api.nvim_win_get_buf(right_win)
  if current_win ~= right_win then
    -- vim.api.nvim_command 'wincmd h'
    vim.api.nvim_win_set_buf(current_win, right_buf)
    vim.api.nvim_win_set_buf(right_win, current_buf)
  end
  -- return utilities.dump(current_buf)
end

swap_window_left = function()
  local current_win = vim.api.nvim_get_current_win()
  local current_buf = vim.api.nvim_win_get_buf(current_win)
  vim.api.nvim_command('wincmd h')
  local left_win = vim.api.nvim_get_current_win()
  local left_buf = vim.api.nvim_win_get_buf(left_win)
  if current_win ~= left_win then
    -- vim.api.nvim_command 'wincmd l'
    vim.api.nvim_win_set_buf(current_win, left_buf)
    vim.api.nvim_win_set_buf(left_win, current_buf)
  end
end

swap_window_up = function()
  local current_win = vim.api.nvim_get_current_win()
  local current_buf = vim.api.nvim_win_get_buf(current_win)
  vim.api.nvim_command('wincmd k')
  local up_win = vim.api.nvim_get_current_win()
  local up_buf = vim.api.nvim_win_get_buf(up_win)
  if current_win ~= up_win then
    -- vim.api.nvim_command 'wincmd j'
    vim.api.nvim_win_set_buf(current_win, up_buf)
    vim.api.nvim_win_set_buf(up_win, current_buf)
  end
end

swap_window_down = function()
  local current_win = vim.api.nvim_get_current_win()
  local current_buf = vim.api.nvim_win_get_buf(current_win)
  vim.api.nvim_command('wincmd j')
  local down_win = vim.api.nvim_get_current_win()
  local down_buf = vim.api.nvim_win_get_buf(down_win)
  if current_win ~= down_win then
    -- vim.api.nvim_command 'wincmd k'
    vim.api.nvim_win_set_buf(current_win, down_buf)
    vim.api.nvim_win_set_buf(down_win, current_buf)
  end
end

determine_project_type = function()
  local ret = 'unknown'
  local current_dir = vim.fn.getcwd()
  if file_exists(current_dir .. '/.luarc.json') then
    return 'lua'
  end
  if file_exists(current_dir .. '/CMakeLists.txt') then
    return 'cpp'
  end
  return ret
end

slime_send_make_run = function()
  vim.api.nvim_call_function('slime#send', { 'make run\n' })
end

slime_send = function(command)
  vim.api.nvim_call_function('slime#send', { command .. '\n' })
end

say_hello = function()
  print('hello world')
end

---@diagnostic disable-next-line: lowercase-global
function dump(o)
  if type(o) == 'table' then
    local s = '{ '
    for k, v in pairs(o) do
      if type(k) ~= 'number' then
        k = '"' .. k .. '"'
      end
      s = s .. '[' .. k .. '] = ' .. dump(v) .. ','
    end
    return s .. '} '
  else
    return tostring(o)
  end
end

---@diagnostic disable-next-line: lowercase-global
read_file = function(path)
  local file = io.open(path, 'r') -- Open the file in read mode
  if not file then
    return nil, 'Could not open file: ' .. path
  end
  local content = file:read('*a') -- Read the entire file content
  return content
end

---@diagnostic disable-next-line: lowercase-global
function extract_time_points(input)
  local start_time, end_time = input:match('CLOCK:%s*%[([^%]]+)%]%s*%-%-%s*%[([^%]]+)%]')
  if not end_time then
    start_time, end_time = input:match('CLOCK:%s*%[([^%]]+)%]')
  end
  return start_time, end_time
end

---@diagnostic disable-next-line: lowercase-global
function parse_timers(content)
  local content_tbl = {}
  for line in string.gmatch(content, '[^\n]+') do
    table.insert(content_tbl, line)
  end
  local found_open_timer = false
  local task_text = ''
  local time_diff_str = ''
  for linum, line in ipairs(content_tbl) do
    local tp1, tp2 = extract_time_points(line)
    if tp1 and not tp2 then
      found_open_timer = true
      task_text = content_tbl[linum - 2]
      local start_time_epoch = os.time {
        year = tp1:sub(1, 4),
        month = tp1:sub(6, 7),
        day = tp1:sub(9, 10),
        hour = tonumber(tp1:sub(16, 17)),
        min = tonumber(tp1:sub(19, 21)),
      }
      local current_time = os.time()
      local time_diff = current_time - start_time_epoch
      if time_diff < 60 then
        time_diff_str = time_diff .. 's'
      else
        time_diff_str = math.floor(time_diff / 60) .. 'min'
      end
      return found_open_timer, task_text, time_diff_str
    end
  end
  return found_open_timer, task_text, time_diff_str
end

---@diagnostic disable-next-line: lowercase-global
function locate_org_files(directories)
  local ret = {}
  local files = {}
  for _, dir in ipairs(directories) do
    files = vim.fn.globpath(dir, '*.org', false, true)
    if #files > 0 then
      for _, file in ipairs(files) do
        table.insert(ret, file)
      end
    end
  end
  return ret
end

---@diagnostic disable-next-line: lowercase-global
get_running_timer_text = function(folders)
  local org_files = locate_org_files(folders)
  for _, file in ipairs(org_files) do
    local content = read_file(file)
    if content then
      local found_timer, task_text, time_diff = parse_timers(content)
      if found_timer then
        return 'Current Task: ' .. task_text:sub(8, #task_text) .. ' (' .. time_diff .. ')'
      end
    end
  end
  return 'No current task'
end

-- }}} Utility functions

-- {{{ User Commands

-- Prototype (example) hello world command
vim.api.nvim_create_user_command('SayHello', function()
  require('playground').hello_world()
end, {})
-- Command to reload FTPlugins for dev purposes

vim.api.nvim_create_user_command('ReloadFTPlugins', 'execute "source" glob($MYVIMRC .. "ftplugin/*.vim")', {})

-- }}} User Commands

-- {{{ Plugin mappings

mymap('n', '<Space>ff', '<CMD>NvimTreeToggle<CR>')
mymap('n', '<Space>gg', '<CMD>Neogit kind=vsplit<CR>')

mymap('n', '<Space>oo', '<CMD>Other<CR>')
mymap('n', '<Space>ov', '<CMD>OtherVSplit<CR>')
mymap('n', '<Space>os', '<CMD>OtherSplit<CR>')
mymap('n', '<Space>aa', '<CMD>AerialToggle<CR>')

mymap('n', '<Space>du', '<CMD>lua require("dapui").toggle()<CR>')
mymap('n', '<Space>db', '<CMD>DapToggleBreakpoint<CR>')
mymap('n', '<Space>du', '<CMD>lua require("dapui").toggle()<CR>')
mymap('n', '<Space>dd', '<CMD>DapContinue<CR>')

mymap('n', '<Space>do', '<CMD>DapStepOut<CR>')
mymap('n', '<Space>di', '<CMD>DapStepInto<CR>')
mymap('n', '<Space>dl', '<CMD>DapStepOver<CR>')
mymap('n', '<Space>di', '<CMD>DapUIPlayPause<CR>')
mymap('n', '<Space>dc', '<CMD>DapContinue<CR>')
mymap('n', '<Space>dc', '<CMD>DapRestartFrame<CR>')

-- }}} Plugin mappings

-- {{{ misc inbox
vim.cmd('colorscheme tokyonight-night')
mymap('n', '<A-l>', '<CMD>wincmd l<CR>')
wrapped_slime = function()
  vim.cmd('sleep 10m')      -- Adjust the sleep as necessary
  vim.cmd("'<,'>SlimeSend") -- Send to Slime
end
-- mymap('n', '<A-return>', '<CMD>SlimeSend<CR>')
-- mymap('n', '<A-return>', ':lua wrapped_slime()<CR>')
-- mymap('v', '<A-return>', ':lua wrapped_slime()<CR>')

mymap('n', '<A-x>', ':Telescope commands<CR>')
mymap('v', '<A-x>', ':Telescope commands<CR>')

mymap('n', '<Space>yy', ':Telescope luasnip<CR>')
mymap('n', '<Space><Space>', ':JustSelect<CR>')

mymap('n', '<C-1>', ':tabn 1<CR>')
mymap('n', '<C-2>', ':tabn 2<CR>')
mymap('n', '<C-3>', ':tabn 3<CR>')
mymap('n', '<C-4>', ':tabn 4<CR>')
mymap('n', '<C-5>', ':tabn 5<CR>')
mymap('n', '<C-6>', ':tabn 6<CR>')
mymap('n', '<C-7>', ':tabn 7<CR>')
mymap('n', '<C-8>', ':tabn 8<CR>')
mymap('n', '<C-9>', ':tabn 9<CR>')

mymap('v', '<C-1>', ':tabn 1<CR>')
mymap('v', '<C-2>', ':tabn 2<CR>')
mymap('v', '<C-3>', ':tabn 3<CR>')
mymap('v', '<C-4>', ':tabn 4<CR>')
mymap('v', '<C-5>', ':tabn 5<CR>')
mymap('v', '<C-6>', ':tabn 6<CR>')
mymap('v', '<C-7>', ':tabn 7<CR>')
mymap('v', '<C-8>', ':tabn 8<CR>')
mymap('v', '<C-9>', ':tabn 9<CR>')

mymap('t', '<C-1>', ':tabn 1<CR>')
mymap('t', '<C-2>', ':tabn 2<CR>')
mymap('t', '<C-3>', ':tabn 3<CR>')
mymap('t', '<C-4>', ':tabn 4<CR>')
mymap('t', '<C-5>', ':tabn 5<CR>')
mymap('t', '<C-6>', ':tabn 6<CR>')
mymap('t', '<C-7>', ':tabn 7<CR>')
mymap('t', '<C-8>', ':tabn 8<CR>')
mymap('t', '<C-9>', ':tabn 9<CR>')

-- }}} misc inbox

-- {{{ Statusline active/not_active behavior
-- vim.cmd('highlight StatusLineNC guifg=#888888 guibg=#DFDFF1')     --  guibg=#000000'Inactive buffer colors
vim.cmd('highlight StatusLine guifg=#FF33FF guibg=#00FFFFBB')     -- Active buffer colors
vim.cmd('highlight StatusLineNC guifg=#888888 guibg=#88888888')   --  guibg=#000000'Inactive buffer colors
vim.cmd('highlight StatusLineActive guifg=#FF33FF guibg=#003366') -- Different color for active buffer
vim.cmd('highlight WinSeparatorActive guifg=#FF33FF')             -- Color for active window separator
vim.cmd('highlight WinSeparatorNC guifg=#444444')                 -- Color for inactive window separators

-- Function to update all status lines and separators
function UpdateAll()
  local current_win = vim.api.nvim_get_current_win()

  vim.cmd('highlight StatusLine guifg=#FF33FF guibg=#00FFFFBB')     -- Active buffer colors
  vim.cmd('highlight StatusLineNC guifg=#888888 guibg=#88888888')   --  guibg=#000000'Inactive buffer colors
  vim.cmd('highlight StatusLineActive guifg=#FF33FF guibg=#003366') -- Different color for active buffer
  vim.cmd('highlight WinSeparatorActive guifg=#FF33FF')             -- Color for active window separator
  vim.cmd('highlight WinSeparatorNC guifg=#444444')                 -- Color for inactive window separators

  -- Update status line colors
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    -- local width = vim.fn.winwidth(win)
    -- local status_line = string.rep("─", width)
    -- Update the status line based on window focus
    if win == current_win then
      -- vim.api.nvim_set_option_value('statusline', '%#StatusLineActive#' .. status_line, { win = win })
      vim.api.nvim_set_option_value('winhighlight', 'WinSeparator:WinSeparatorActive', { win = win })
    else
      -- vim.api.nvim_set_option_value('statusline', '%#StatusLineNC#' .. status_line, { win = win })
      vim.api.nvim_set_option_value('winhighlight', 'WinSeparator:WinSeparatorNC', { win = win })
    end
  end
end

-- Autocommand to refresh status lines and separators on resize
vim.api.nvim_create_autocmd('VimResized', { callback = UpdateAll })
-- Autocommand to update status lines and separators on window focus changes
vim.api.nvim_create_autocmd({ 'WinEnter', 'BufEnter' }, { callback = UpdateAll })
vim.api.nvim_create_autocmd({ 'WinLeave', 'BufLeave' }, { callback = UpdateAll })

-- Initial setup to set status lines and separators for all windows
UpdateAll()

vim.cmd('highlight EndOfBuffer guifg=#881188') -- Customize color as needed

-- }}} Statusline active/not_active behavior

-- vim.opt.statusline = "%l/%3L:%2c %= %P"  -- Example status line
-- vim.opt.statusline = " %= %P"  -- Example status line
vim.opt.statusline = ' %= %l/%3L' -- Example status line
vim.opt.statusline = '%='         -- Example status line

mymap('n', '<A-C-h>', "<CMD>lua require('smart-splits').swap_buf_left()<CR>")
mymap('t', '<A-C-h>', "<CMD>lua require('smart-splits').swap_buf_left()<CR>")
mymap('n', '<A-C-l>', "<CMD>lua require('smart-splits').swap_buf_right()<CR>")
mymap('t', '<A-C-l>', "<CMD>lua require('smart-splits').swap_buf_right()<CR>")
mymap('n', '<A-C-j>', "<CMD>lua require('smart-splits').swap_buf_down()<CR>")
mymap('t', '<A-C-j>', "<CMD>lua require('smart-splits').swap_buf_down()<CR>")
mymap('n', '<A-C-k>', "<CMD>lua require('smart-splits').swap_buf_up()<CR>")
mymap('t', '<A-C-k>', "<CMD>lua require('smart-splits').swap_buf_up()<CR>")

mymap('n', '<Space>rr', '<CMD>RunJust<CR>')

-- {{{ tab bindings

mymap('n', '1', '<CMD>tabn 1<CR>')
mymap('n', '2', '<CMD>tabn 2<CR>')
mymap('n', '3', '<CMD>tabn 3<CR>')
mymap('n', '4', '<CMD>tabn 4<CR>')
mymap('n', '5', '<CMD>tabn 5<CR>')
mymap('n', '6', '<CMD>tabn 6<CR>')
mymap('n', '7', '<CMD>tabn 7<CR>')
mymap('n', '8', '<CMD>tabn 8<CR>')
mymap('n', '9', '<CMD>tabn 9<CR>')

-- }}} tab bindings

-- -- {{{ Fortran filetype detection
-- vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
--     pattern = "*.f90",
--     callback = function()
--         vim.bo.filetype = "fortran"
--     end,
-- })
-- -- }}} Fortran filetype detection

-- {{{ Inbox

mymap({ 'n', 'x', 'o' }, 's', function()
  require('flash').jump()
end)
-- mymap({ "n", "x", "o" }, "S", function() require("flash").treesitter() end)
-- mymap("o", "r", function() require("flash").remote() end)
-- mymap({ "o", "x" }, "R", function() require("flash").treesitter_search() end)
-- mymap("c", "<c-s>", function() require("flash").toggle() end)

---@diagnostic disable-next-line: lowercase-global
function dump(o)
  if type(o) == 'table' then
    local s = '{ '
    for k, v in pairs(o) do
      if type(k) ~= 'number' then
        k = '"' .. k .. '"'
      end
      s = s .. '[' .. k .. '] = ' .. dump(v) .. ','
    end
    return s .. '} '
  else
    return tostring(o)
  end
end

---@diagnostic disable-next-line: lowercase-global
register_sendto_buffer = function()
  local function get_terminal_bufnr()
    local term_bufnr = nil
    local tabpage_buffs = vim.fn.tabpagebuflist()

    for _, bufnr in ipairs(tabpage_buffs) do
      if vim.bo[bufnr].buftype == 'terminal' then
        term_bufnr = bufnr
        break
      end
    end

    return term_bufnr
  end

  local term_bufnr = get_terminal_bufnr()
  local other_bufnr = nil
  local current_bufnr = vim.fn.bufnr('%')

  if term_bufnr then
    current_bufnr = term_bufnr
  else
    local buf_list = vim.fn.getbufinfo { buflisted = 1 }
    if #buf_list > 1 then
      -- Take the first non-terminal buffer
      for _, buf in ipairs(buf_list) do
        if buf.bufnr ~= current_bufnr and vim.bo[buf.bufnr].buftype ~= 'terminal' then
          other_bufnr = buf.bufnr
          break
        end
      end
    end
    -- Use the first other buffer if found, otherwise fallback to current
    current_bufnr = other_bufnr or current_bufnr
  end

  current_bufnr = tostring(current_bufnr)
  current_bufnr = vim.fn.input('SendTo bufnr: ', current_bufnr)
  SendTo_Bufnr = tonumber(current_bufnr)
end

send_line_to_buffer = function()
  local current_line = vim.api.nvim_get_current_line()
  local original_bufnr = vim.fn.bufnr('%')
  local original_cursor_pos = vim.api.nvim_win_get_cursor(0) -- Save cursor position

  if SendTo_Bufnr == nil then
    register_sendto_buffer()
  end

  local target_bufnr = SendTo_Bufnr
  local win_id = vim.fn.bufwinid(target_bufnr)

  if win_id ~= -1 then
    -- Get the terminal channel id
    local channel_id = vim.api.nvim_buf_get_var(target_bufnr, 'terminal_job_id')
    if channel_id then
      -- Send the current line to the terminal channel
      vim.fn.chansend(channel_id, current_line .. '\n') -- Ensure to end with a newline
    else
      vim.api.nvim_err_writeln('No job ID found for the terminal buffer.')
    end
  else
    return
  end

  -- Return to the original window and restore the cursor position
  vim.api.nvim_set_current_win(vim.fn.bufwinid(original_bufnr))
  vim.api.nvim_win_set_cursor(0, original_cursor_pos) -- Restore cursor position
  vim.cmd("normal j")
end

--- Gets the text in the visual selection
-- @return a text string of the current visual selection
---@diagnostic disable: lowercase-global
get_visual_selection = function()
  local s_start = vim.fn.getpos("'<")
  local s_end = vim.fn.getpos("'>")
  local n_lines = math.abs(s_end[2] - s_start[2]) + 1
  local lines = vim.api.nvim_buf_get_lines(0, s_start[2] - 1, s_end[2], false)
  lines[1] = string.sub(lines[1], s_start[3], -1)
  if n_lines == 1 then
    lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3] - s_start[3] + 1)
  else
    lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3])
  end
  return table.concat(lines, '\n')
end

visual_selection_text = ''

-- --- Gets the text in the visual selection
-- -- @return a table of lines of current visual selection
-- ---@diagnostic disable: lowercase-global
-- get_visual_selection_lines = function()
--   vim.cmd('sleep 10m') -- Adjust the sleep as necessary
--   local s_start = vim.fn.getpos("'<")
--   local s_end = vim.fn.getpos("'>")
--   vim.cmd('sleep 10m') -- Adjust the sleep as necessary
--   local s_start = vim.fn.getpos("'<")
--   local s_end = vim.fn.getpos("'>")
--   vim.cmd('sleep 10m') -- Adjust the sleep as necessary
--   -- Adjust for zero-based indexing
--   local start_line = s_start[2] - 1
--   local end_line = s_end[2] - 1
--   local lines = vim.api.nvim_buf_get_lines(0, start_line, end_line + 1, false)
--   -- Trim the start of the first line if necessary
--   if #lines > 0 then
--     lines[1] = string.sub(lines[1], s_start[3], -1)
--   end
--   -- Trim the end of the last line if the selection spans multiple lines
--   if #lines > 1 then
--     lines[#lines] = string.sub(lines[#lines], 1, s_end[3])
--   elseif #lines == 1 then
--     lines[1] = string.sub(lines[1], s_start[3], s_end[3])
--   end
--   return lines
-- end

get_visual_selection_lines = function()
  local s_start = vim.fn.getpos("'<")
  local s_end = vim.fn.getpos("'>")
  -- Adjust for zero-based indexing
  local start_line = s_start[2] - 1
  local end_line = s_end[2] - 1
  local lines = vim.api.nvim_buf_get_lines(0, start_line, end_line + 1, false)
  -- Trim the start of the first line if necessary
  if #lines > 0 then
    lines[1] = string.sub(lines[1], s_start[3], -1)
  end
  -- Trim the end of the last line if the selection spans multiple lines
  if #lines > 1 then
    lines[#lines] = string.sub(lines[#lines], 1, s_end[3])
  elseif #lines == 1 then
    lines[1] = string.sub(lines[1], s_start[3], s_end[3])
  end
  -- Save the selected lines to the global variable as a single string
  visual_selection_text = table.concat(lines, '\n')
end

-- local augroup_id = vim.api.nvim_create_augroup("GetVisualSelection", { clear = true })
-- vim.api.nvim_create_autocmd("VisualLeave", {
--   group = augroup_id,
--   callback = get_visual_selection_lines,
-- })

-- --- Sends visual selection to SendTo buffer
-- -- @see register_sendto_buffer, send_line_to_buffer
-- send_lines_to_buffer = function()
--   -- local current_lines = get_visual_selection_lines()
--   local current_lines = extract_selected_text()
--   print(dump(current_lines))
--   local original_bufnr = vim.fn.bufnr('%')
--   local original_cursor_pos = vim.api.nvim_win_get_cursor(0)
--
--   if SendTo_Bufnr == nil then
--     register_sendto_buffer()
--   end
--
--   local target_bufnr = SendTo_Bufnr
--   local win_id = vim.fn.bufwinid(target_bufnr)
--
--   -- vim.print(dump(current_lines))
--
--   if win_id ~= -1 then
--     -- Get the terminal channel id
--     local channel_id = vim.api.nvim_buf_get_var(target_bufnr, 'terminal_job_id')
--     if channel_id then
--       for _, line in ipairs(current_lines) do
--         -- Send each line to the terminal channel
--         vim.fn.chansend(channel_id, line .. '\n') -- Ensure each line ends with a newline
--       end
--     else
--       vim.api.nvim_err_writeln('No job ID found for the terminal buffer.')
--     end
--
--     -- Return to the original window and restore the cursor position
--     vim.api.nvim_set_current_win(vim.fn.bufwinid(original_bufnr))
--     vim.api.nvim_win_set_cursor(0, original_cursor_pos) -- Restore cursor position
--   else
--     vim.api.nvim_err_writeln('Target buffer not open.')
--   end
-- end

function send_lines_to_buffer()
  local sel_save = vim.o.selection
  vim.o.selection = 'inclusive'

  -- Store the contents of the unnamed register
  local rv = vim.fn.getreg('"')
  local rt = vim.fn.getregtype('"')

  local selected_lines = {}

  -- Check if in Visual mode (using v:register to determine this)
  if vim.v.register == 'v' then -- Invoked from Visual mode
    selected_lines = vim.fn.getline("'<", "'>")
  else
    -- If not in visual mode, assume we want the current line(s)
    selected_lines = vim.fn.getline('.')
  end

  -- Ensure selected_lines is always a table
  if type(selected_lines) == 'string' then
    selected_lines = { selected_lines }
  end

  local current_lines = selected_lines

  print(dump(current_lines)) -- Debugging: print the current lines
  local original_bufnr = vim.fn.bufnr('%')
  local original_cursor_pos = vim.api.nvim_win_get_cursor(0)

  if SendTo_Bufnr == nil then
    register_sendto_buffer()
  end

  local target_bufnr = SendTo_Bufnr
  local win_id = vim.fn.bufwinid(target_bufnr)

  if win_id ~= -1 then
    -- Get the terminal channel id
    local channel_id = vim.api.nvim_buf_get_var(target_bufnr, 'terminal_job_id')
    if channel_id then
      for _, line in ipairs(current_lines) do
        -- Send each line to the terminal channel
        vim.fn.chansend(channel_id, line .. '\n') -- Ensure each line ends with a newline
      end
    else
      vim.api.nvim_err_writeln('No job ID found for the terminal buffer.')
    end

    -- Return to the original window and restore the cursor position
    vim.api.nvim_set_current_win(vim.fn.bufwinid(original_bufnr))
    vim.api.nvim_win_set_cursor(0, original_cursor_pos) -- Restore cursor position
  else
    vim.api.nvim_err_writeln('Target buffer not open.')
  end

  vim.o.selection = sel_save
  vim.fn.setreg('"', rv, rt)

  -- Call your function to restore cursor position if necessary
  -- restore_cursor_position()
end

-- function that extracts selected text
extract_selected_text = function()
  -- Get the start and end positions of the selected text
  local start_line, start_col, end_line, end_col = unpack(vim.fn.getpos("'<") + vim.fn.getpos("'>"))
  -- Extract the selected text using the range
  local selected_text = vim.fn.getline(start_line, end_line)
  -- If the selection spans multiple lines, adjust the text
  if start_line ~= end_line then
    selected_text[#selected_text] = selected_text[#selected_text]:sub(1, end_col)
    selected_text[1] = selected_text[1]:sub(start_col)
  else
    selected_text[1] = selected_text[1]:sub(start_col, end_col)
  end
  ---@diagnostic disable-next-line: discard-returns, param-type-mismatch
  table.concat(selected_text, '\n')
end

-- Make sure to require plenary.nvim at the beginning of your Lua configuration
-- local popup = require('plenary.popup')

function extract_selected_text_and_show_popup()
  local popup = require('plenary.popup')
  -- Get the start and end positions of the selected text
  local start_line, start_col, end_line, end_col = unpack(vim.fn.getpos("'<") + vim.fn.getpos("'>"))

  -- Extract the selected text using the range
  local selected_text = vim.fn.getline(start_line, end_line)

  -- If the selection spans multiple lines, adjust the text
  if start_line ~= end_line then
    selected_text[#selected_text] = selected_text[#selected_text]:sub(1, end_col)
    selected_text[1] = selected_text[1]:sub(start_col)
  else
    selected_text[1] = selected_text[1]:sub(start_col, end_col)
  end

  -- Join the lines to create a single string
  ---@diagnostic disable-next-line: discard-returns, param-type-mismatch
  local textstring = table.concat(selected_text, '\n')

  -- Create a popup with the extracted text
  local popup_opts = {
    line = 10,
    col = 10,
    width = #textstring + 4,
    height = #textstring + 2,
    border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
    padding = { 0, 1, 0, 1 },
  }

  local popup_bufnr = vim.api.nvim_create_buf(false, true)
  ---@diagnostic disable-next-line: discard-returns, param-type-mismatch
  vim.api.nvim_buf_set_lines(popup_bufnr, 0, -1, false, vim.fn.split(selected_text, '\n'))
  local popup_winid = popup.create(popup_bufnr, popup_opts)

  -- You can close the popup after a delay (e.g., 5 seconds) if needed
  vim.defer_fn(function()
    vim.api.nvim_win_close(popup_winid, true)
  end, 5000)
end

extract_paragraph_at_cursor = function()
  -- Get the current line number
  local current_line = vim.fn.line('.')

  -- Find the start and end lines of the paragraph
  local start_line = current_line
  local end_line = current_line

  -- Find the start line of the paragraph
  while start_line > 1 and vim.fn.trim(vim.fn.getline(start_line - 1)) ~= '' do
    start_line = start_line - 1
  end

  -- Find the end line of the paragraph
  while end_line < vim.fn.line('$') and vim.fn.trim(vim.fn.getline(end_line + 1)) ~= '' do
    end_line = end_line + 1
  end

  -- Extract the paragraph text
  local paragraph_lines = {}
  for line = start_line, end_line do
    table.insert(paragraph_lines, vim.fn.getline(line))
  end

  -- Join the lines to create a single string
  local paragraph_text = table.concat(paragraph_lines, '\n')

  -- Print or use the extracted paragraph text as needed
  -- print(paragraph_text)
  -- You can also return the extracted paragraph text for further use
  return paragraph_text
end

-- utilities.readFromFile = function(file_path)
--   local file = io.open(file_path, "r");
--   if file then
--     local content = file:read("*a");
--     file:close();
--     return content;
--   else
--     return nil;
--   end
-- end

readFromFile = function(file_path)
  local bufnr = vim.fn.bufadd(file_path)
  if bufnr ~= 0 then
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    vim.api.nvim_buf_delete(bufnr, { force = true })
    if #lines > 0 then
      return table.concat(lines, '\n')
    else
      return 'Error: File is empty.'
    end
  else
    return 'Error: Unable to open the file.'
  end
end

run_shell_command_to_buffer = function(command)
  local output = vim.fn.systemlist(command)
  local bufnr = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, output)
  vim.cmd('enew | setlocal buftype=nofile bufhidden=hide noswapfile')
  vim.cmd('setlocal filetype=text')
  vim.api.nvim_set_current_buf(bufnr)
end

run_shell_to_string = function(command)
  local output = vim.fn.systemlist(command)
  return output
end

readFromFile2 = function(file_path)
  local file = io.open(file_path, 'r') -- Open the file in read mode
  if file then
    local content = file:read('*a')
    file:close()
    if content == '' then
      return 'File was empty'
    else
      return content
    end
    return content
  else
    return 'Error: Unable to open the file.'
  end
end

show_simple_popup = function(text)
  local popup = require('plenary.popup')
  local popup_opts = {
    line = vim.fn.line('.') + 1,
    col = vim.fn.col('.'),
    width = 30,
    height = 3,
    padding = { 0, 1, 0, 1 },
    move_on_insert = true,
    close_on_buf_leave = true,
  }
  ---@diagnostic disable-next-line: discard-returns, param-type-mismatch, unused-local
  local popup_winid, popup_bufnr = popup.create(split_string_at_newlines(text), popup_opts)
end

show_paragraph_in_popup = function()
  local paragraph = extract_paragraph_at_cursor()
  show_simple_popup(paragraph)
end

local show_buffer_info = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local winid = vim.api.nvim_get_current_win()
  local bufname = vim.api.nvim_buf_get_name(bufnr)
  local buflines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local line_count = #buflines
  local modified = vim.api.nvim_buf_get_option(bufnr, 'modified')
  local filetype = vim.api.nvim_buf_get_option(bufnr, 'filetype')
  local readonly = vim.api.nvim_buf_get_option(bufnr, 'readonly')
  local info = {
    'Buffer Information:',
    'Buffer Number: ' .. bufnr,
    'Window Number: ' .. winid,
    'Name: ' .. bufname,
    'Line Count: ' .. line_count,
    'Modified: ' .. tostring(modified),
    'Filetype: ' .. (filetype ~= '' and filetype or 'none'),
    'Read-only: ' .. tostring(readonly),
  }

  local width = 50
  local height = #info + 2

  local opts = {
    title = 'Buffer Info',
    border = true,
    style = 'minimal',
    relative = 'editor',
    width = width,
    height = height,
    row = 5,
    col = 5,
  }

  local bufnr_info = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(bufnr_info, 0, -1, false, info)

  local win_id = popup.create(bufnr_info, opts)
  vim.api.nvim_win_set_option(win_id, 'winhighlight', 'Normal:Normal')
end

-- function send_visual_selection_to_first_terminal()
--   -- Get the start and end positions of the visual selection
--   local s_start = vim.fn.getpos("'<")
--   local s_end = vim.fn.getpos("'>")
--
--   -- Extract selected lines from the buffer
--   local lines = vim.api.nvim_buf_get_lines(0, s_start[2] - 1, s_end[2], false)
--
--   -- Adjust first and last lines based on selection columns
--   if #lines > 0 then
--     lines[1] = string.sub(lines[1], s_start[3])              -- Trim start of the first line
--     if #lines > 1 then
--       lines[#lines] = string.sub(lines[#lines], 1, s_end[3]) -- Trim end of the last line
--     else
--       lines[1] = string.sub(lines[1], 1, s_end[3])           -- Handle single line selection
--     end
--   end
--
--   -- Find the first terminal buffer
--   local term_bufnr = nil
--   local tabpage_buffs = vim.fn.tabpagebuflist()
--   for _, bufnr in ipairs(tabpage_buffs) do
--     if vim.bo[bufnr].buftype == 'terminal' then
--       term_bufnr = bufnr
--       break
--     end
--   end
--
--   -- If a terminal buffer is found, send the lines
--   if term_bufnr then
--     local win_id = vim.fn.bufwinid(term_bufnr)
--     if win_id ~= -1 then
--       -- Switch to the terminal buffer
--       vim.api.nvim_set_current_win(win_id)
--       vim.cmd('startinsert') -- Enter insert mode
--
--       -- Send each line to the terminal buffer
--       for _, line in ipairs(lines) do
--         vim.api.nvim_feedkeys(line, 'n', true)
--         vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<CR>', true, false, true), 'n', true) -- Press Enter
--       end
--       -- Return to the original window
--       vim.api.nvim_set_current_win(0) -- Switch back to the previous window
--     else
--       print("Terminal buffer not found.")
--     end
--   else
--     print("No terminal buffer available.")
--   end
-- end

mymap('n', '<Space>bi', '<CMD>lua show_buffer_info()<CR>')
mymap('n', '<A-return>', '<CMD>lua send_line_to_buffer()<CR>')
mymap('v', '<A-return>', '<CMD>lua send_lines_to_buffer()<CR>')
-- mymap('v', '<A-return>', '<CMD>lua send_visual_selection_to_first_terminal()<CR>')

-- }}} Inbox
