-- /home/stevearc/.config/nvim/lua/overseer/template/user/cpp_build.lua
return {
  name = "g++ build",
  builder = function()
    -- Full path to current file (see :help expand())
    local file = vim.fn.expand("%:p")
    local filename = vim.fn.fnamemodify(file, ":t")
    local example_name = filename:gsub("^prefix_cpp_", ""):gsub("%.cpp$", "") -- Adjust this line based on your prefix
    return {
      cmd = { "just", "run", "TARGET=" .. example_name },
      components = { { "on_output_quickfix", open = true }, "default" },
    }
  end,
  condition = {
    filetype = { "cpp" },
  },
}
