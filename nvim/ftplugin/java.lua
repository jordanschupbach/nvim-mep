local function get_jdtls_path()
  local handle = io.popen("which jdtls")
  local path = handle:read("*a")
  handle:close()
  return path:gsub("\n", "") -- Remove trailing newline
end

local config = {
  cmd = { get_jdtls_path() }, -- Get the jdtls path dynamically
  root_dir = vim.fs.dirname(vim.fs.find({ 'gradlew', '.git', 'mvnw' }, { upward = true })[1]),
  settings = {
    java = {}
  }
}


require('jdtls').start_or_attach(config)
