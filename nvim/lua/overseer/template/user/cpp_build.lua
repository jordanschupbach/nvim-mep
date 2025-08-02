-- /home/stevearc/.config/nvim/lua/overseer/template/user/cpp_build.lua
return {
  name = "g++ build",
  builder = function()
    local file = vim.fn.expand("%:p")
    local filename = vim.fn.fnamemodify(file, ":t")
    local example_name = filename:gsub("^prefix_cpp_", ""):gsub("%.cpp$", "")
    return {
      cmd = { "just" },
      args = { "run", "example", example_name .. "_cpp"  },
      components = { 
        { "on_output_quickfix", open = true },
        {
          on_exit = function()
            vim.cmd("norm G")  -- Scroll to the bottom of the buffer
          end,
        },
        "default" },
    }
  end,
  condition = {
    filetype = { "cpp" },
  },
}
