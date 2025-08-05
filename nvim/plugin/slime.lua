local function mymap(mode, key, value)
  vim.keymap.set(mode, key, value, { silent = true, remap = true })
end


local wrapped_slime = function()
  vim.cmd('sleep 10m')      -- Adjust the sleep as necessary
  vim.cmd("'<,'>SlimeSend") -- Send to Slime
end

mymap('n', '<A-return>', ':lua wrapped_slime()<CR>')
-- mymap('n', '<A-return>', '<CMD>SlimeSend<CR>')
