-- {{{ Include guard

if vim.g.did_load_telescope_plugin then
  return
end
vim.g.did_load_telescope_plugin = true

-- }}} Include guard

-- {{{ Imports
local telescope = require('telescope')
local actions = require('telescope.actions')

local builtin = require('telescope.builtin')

-- local utilities = require 'utilities'
local actions = require 'telescope.actions'
-- local finders = require 'telescope.finders'
-- local pickers = require 'telescope.pickers'
local actions_state = require 'telescope.actions.state'

local telescope = require("telescope")

-- }}} imports

-- {{{ Utility functions


local layout_config = {
  vertical = {
    width = function(_, max_columns)
      return math.floor(max_columns * 0.99)
    end,
    height = function(_, _, max_lines)
      return math.floor(max_lines * 0.99)
    end,
    prompt_position = 'bottom',
    preview_cutoff = 0,
  },
}

-- Fall back to find_files if not in a git repo
local project_files = function()
  local opts = {} -- define here if you want to define something
  local ok = pcall(builtin.git_files, opts)
  if not ok then
    builtin.find_files(opts)
  end
end

---@param picker function the telescope picker to use
local function grep_current_file_type(picker)
  local current_file_ext = vim.fn.expand('%:e')
  local additional_vimgrep_arguments = {}
  if current_file_ext ~= '' then
    additional_vimgrep_arguments = {
      '--type',
      current_file_ext,
    }
  end
  local conf = require('telescope.config').values
  picker {
    vimgrep_arguments = vim.tbl_flatten {
      conf.vimgrep_arguments,
      additional_vimgrep_arguments,
    },
  }
end

--- Grep the string under the cursor, filtering for the current file type
local function grep_string_current_file_type()
  grep_current_file_type(builtin.grep_string)
end

--- Live grep, filtering for the current file type
local function live_grep_current_file_type()
  grep_current_file_type(builtin.live_grep)
end

--- Like live_grep, but fuzzy (and slower)
local function fuzzy_grep(opts)
  opts = vim.tbl_extend('error', opts or {}, { search = '', prompt_title = 'Fuzzy grep' })
  builtin.grep_string(opts)
end

local function fuzzy_grep_current_file_type()
  grep_current_file_type(fuzzy_grep)
end






---@diagnostic disable-next-line: unused-function
local function file_exists(filename)
  local file = io.open(filename, 'r')
  if file then
    io.close(file)
    return true
  else
    return false
  end
end

---@diagnostic disable-next-line: unused-local, unused-function
local function on_project_selected(prompt_bufnr)
  local entry = actions_state.get_selected_entry()
  print("Hello from project selected")
  actions.close(prompt_bufnr)
  print(entry['value']:gsub("/+$", ""))
  if entry['value']:gsub("/+$", ""):match("([^/]+)$") == "nvim-playground" then
    vim.cmd('edit ' .. entry['value'] .. '/init.lua')
  else
    if file_exists('' .. entry['value'] .. '/README.org') then
      vim.cmd('edit ' .. entry['value'] .. '/README.org')
    else
      vim.cmd('edit ' .. entry['value'] .. '/README.md')
    end
  end
  -- Toggle the NvimTree buffer
  -- vim.cmd 'split'
  -- vim.cmd 'terminal'
  vim.cmd 'NvimTreeToggle'
  -- vim.cmd 'Neotree toggle'
  -- vim.cmd 'Workspace LeftPanelToggle'
  vim.cmd 'wincmd l'
  -- vim.print('about to cd ' .. entry["value"]) -- test out
  vim.cmd('cd ' .. entry["value"])
  -- vim.cmd 'SidebarNvimToggle'
  if file_exists('' .. entry['value'] .. '/TODO.org') then
    vim.cmd 'split'
    vim.cmd('edit ' .. entry['value'] .. '/TODO.org')
    vim.api.nvim_win_set_height(0, 8)
    vim.cmd 'wincmd k'
  end
  -- vim.cmd('cd ')
end

-- }}} Utility functions

-- {{{ Setup

require('telescope').setup {
  defaults = {
    mappings = {
      i = { ['<C-d>'] = require('telescope.actions').delete_buffer },
      n = { ['<C-d>'] = require('telescope.actions').delete_buffer },
    },
  },
  prompt_prefix = ' ',
  selection_caret = '* ',
  path_display = { 'smart' },
  vimgrep_arguments = {
    'rg',
    '--color=never',
    '--no-heading',
    '--with-filename',
    '--line-number',
    '--column',
    '--smart-case',
    '--no-ignore',
    '--hidden',
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = 'smart_case',
    },
    fzy_native = {
      override_generic_sorter = false,
      override_file_sorter = true,
    },
    project = {
      hidden_files = true, -- default: false
      theme = 'dropdown',
      order_by = 'asc',
      search_by = 'title',
      sync_with_nvim_tree = false, -- default false
      -- default for on_project_selected = find project files
      on_project_selected = function(prompt_bufnr)
        on_project_selected(prompt_bufnr)
      end,
    },

   -- This configuration only affects this extension.
    telescope_words = {

      -- Define custom mappings. Default mappings are {} (empty).
      mappings = {
        -- n = {
        --   ["<CR>"] = word_actions.replace_word_under_cursor,
        -- },
        -- i = {
        --   ["<CR>"] = word_actions.replace_word_under_cursor,
        -- },

      },

      -- Default pointers define the lexical relations listed under each definition,
      -- see Pointer Symbols below.
      -- Default is as below ("antonyms", "similar to" and "also see").
      pointer_symbols = { "!", "&", "^" },

      -- The number of characters entered before fuzzy searching is used. Raise this
      -- if results are slow. Default is 3.
      fzy_char_threshold = 3,

      -- Choose the layout strategy. Default is as below.
      layout_strategy = "horizontal",

      -- And your layout config. Default is as below.
      layout_config = { height = 0.75, width = 0.75, preview_width = 0.65 },
    },



  },
}

-- }}} Setup

-- {{{ Load extensions

-- require 'telescope'.load_extension('make')
pcall(require('telescope').load_extension, 'fzf')
pcall(require('telescope').load_extension, 'ultisnips')
pcall(require('telescope').load_extension, 'project')
pcall(require('telescope').load_extension, 'luasnip')
pcall(require('telescope').load_extension, 'media_files')
pcall(require('telescope').load_extension, 'thesaurus')
-- pcall(require('telescope').load_extension, 'bookmarks')
telescope.load_extension('fzy_native')

-- }}} Load extensions

-- {{{ mappings

local function mymap(mode, key, value)
  vim.keymap.set(mode, key, value, { silent = true, remap = true })
end

mymap('n', '<Space>bb', '<CMD>Telescope buffers<CR>')
mymap('n', '<Space>hh', '<CMD>Telescope help_tags<CR>')
mymap('n', '<A-x>hh', '<CMD>Telescope commands<CR>')
mymap('n', '/', '<CMD>Telescope current_buffer_fuzzy_find theme=ivy<CR>')
mymap('n', '<Space>pf', '<CMD>Telescope find_files<CR>')
mymap('n', '<Space>pr', '<CMD>Telescope live_grep<CR>')
mymap('n', '<Space>po', '<CMD>Telescope project<CR>')

-- }}} mappings

-- {{{ Old mappings
vim.keymap.set('n', '<leader>tp', function()
  builtin.find_files()
end, { desc = '[t]elescope find files - ctrl[p] style' })
vim.keymap.set('n', '<M-p>', builtin.oldfiles, { desc = '[telescope] old files' })
vim.keymap.set('n', '<C-g>', builtin.live_grep, { desc = '[telescope] live grep' })
vim.keymap.set('n', '<leader>tf', fuzzy_grep, { desc = '[t]elescope [f]uzzy grep' })
vim.keymap.set('n', '<M-f>', fuzzy_grep_current_file_type, { desc = '[telescope] fuzzy grep filetype' })
vim.keymap.set('n', '<M-g>', live_grep_current_file_type, { desc = '[telescope] live grep filetype' })
vim.keymap.set(
  'n',
  '<leader>t*',
  grep_string_current_file_type,
  { desc = '[t]elescope grep current string [*] in current filetype' }
)
vim.keymap.set('n', '<leader>*', builtin.grep_string, { desc = '[telescope] grep current string [*]' })
vim.keymap.set('n', '<leader>tg', project_files, { desc = '[t]elescope project files [g]' })
vim.keymap.set('n', '<leader>tc', builtin.quickfix, { desc = '[t]elescope quickfix list [c]' })
vim.keymap.set('n', '<leader>tq', builtin.command_history, { desc = '[t]elescope command history [q]' })
vim.keymap.set('n', '<leader>tl', builtin.loclist, { desc = '[t]elescope [l]oclist' })
vim.keymap.set('n', '<leader>tr', builtin.registers, { desc = '[t]elescope [r]egisters' })
vim.keymap.set('n', '<leader>tbb', builtin.buffers, { desc = '[t]elescope [b]uffers [b]' })
vim.keymap.set(
  'n',
  '<leader>tbf',
  builtin.current_buffer_fuzzy_find,
  { desc = '[t]elescope current [b]uffer [f]uzzy find' }
)
vim.keymap.set('n', '<leader>td', builtin.lsp_document_symbols, { desc = '[t]elescope lsp [d]ocument symbols' })
vim.keymap.set(
  'n',
  '<leader>to',
  builtin.lsp_dynamic_workspace_symbols,
  { desc = '[t]elescope lsp dynamic w[o]rkspace symbols' }
)

-- }}} Old mappings

-- {{{ Old config

-- telescope.setup {
--   defaults = {
--     path_display = {
--       'truncate',
--     },
--     layout_strategy = 'vertical',
--     layout_config = layout_config,
--     mappings = {
--       i = {
--         ['<C-q>'] = actions.send_to_qflist,
--         ['<C-l>'] = actions.send_to_loclist,
--         -- ['<esc>'] = actions.close,
--         ['<C-s>'] = actions.cycle_previewers_next,
--         ['<C-a>'] = actions.cycle_previewers_prev,
--       },
--       n = {
--         q = actions.close,
--       },
--     },
--     preview = {
--       treesitter = true,
--     },
--     history = {
--       path = vim.fn.stdpath('data') .. '/telescope_history.sqlite3',
--       limit = 1000,
--     },
--     color_devicons = true,
--     set_env = { ['COLORTERM'] = 'truecolor' },
--     prompt_prefix = '   ',
--     selection_caret = '  ',
--     entry_prefix = '  ',
--     initial_mode = 'insert',
--     vimgrep_arguments = {
--       'rg',
--       '-L',
--       '--color=never',
--       '--no-heading',
--       '--with-filename',
--       '--line-number',
--       '--column',
--       '--smart-case',
--     },
--   },
--   extensions = {
--     fzy_native = {
--       override_generic_sorter = false,
--       override_file_sorter = true,
--     },
--   },
-- }
-- 

-- }}} Old config
