
local function mymap(mode, key, value)
  vim.keymap.set(mode, key, value, { silent = true, remap = true })
end

mymap('n', '<A-return>', '<CMD>SlimeSend<CR>')
