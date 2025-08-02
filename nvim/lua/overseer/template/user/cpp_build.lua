-- /home/stevearc/.config/nvim/lua/overseer/template/user/cpp_build.lua
return {
  name = "g++ build",
  builder = function()
    local file = vim.fn.expand("%:p")
    local filename = vim.fn.fnamemodify(file, ":t")
    local example_name = filename:gsub("^prefix_cpp_", ""):gsub("%.cpp$", "")
    return {
      cmd = { "just ", "run ", "example " .. example_name .. "_cpp"  },
      components = { { "on_output_quickfix", open = true }, "default" },
    }
  end,
  condition = {
    filetype = { "cpp" },
  },
}
