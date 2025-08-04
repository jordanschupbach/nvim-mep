local function get_jdtls_path()
  local handle = io.popen("which jdtls")
  local path = handle:read("*a")
  handle:close()
  return path:gsub("\n", "") -- Remove trailing newline
end

local on_attach = function(client, bufnr)
  require("plugins.configs.lspconfig").on_attach(client, bufnr)
end

local capabilities = require("plugins.configs.lspconfig").capabilities
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

-- Get the jdtls path and calculate the install path
local jdtls_path = get_jdtls_path()
local install_path = vim.fn.fnamemodify(jdtls_path, ":h:h") -- Two directories back

-- Calculate workspace dir
local workspace_dir = vim.fn.stdpath("data") .. "/site/java/workspace-root/" .. project_name

-- Get the debug adapter install path (you can keep using mason for this if preferred)
-- local debug_install_path = require("mason-registry").get_package("java-debug-adapter"):get_install_path()

-- local bundles = {
--   vim.fn.glob(debug_install_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar", 1),
-- }

-- "--jvm-arg=-javaagent:" .. install_path .. "/lombok.jar",

local config = {
  cmd = {
    jdtls_path,
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Xms1g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens",
    "java.base/java.util=ALL-UNNAMED",
    "--add-opens",
    "java.base/java.lang=ALL-UNNAMED",
    "-data",
    workspace_dir,
  },
  on_attach = on_attach,
  capabilities = capabilities,
  root_dir = vim.fs.dirname(
    vim.fs.find({ ".gradlew", ".git", "mvnw", "pom.xml", "build.gradle" }, { upward = true })[1]
  ),
  settings = {
    java = {
      signatureHelp = { enabled = true },
    },
  },
  -- init_options = {
  --   bundles = bundles,
  -- },
}

require('jdtls').start_or_attach(config)
