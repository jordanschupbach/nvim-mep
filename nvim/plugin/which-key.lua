
local whichkey = require("which-key")

require('which-key').setup { }

whichkey.add({
  { "<Space>a",        group = "Aerial" },
  { "<Space>b",        group = "Buffer" },
  { "<Space>c",        group = "Code" },
  { "<Space>d",        group = "Debug" },
  { "<Space>e",        group = "Errors" },
  { "<leader>f",       group = "File" },
  { "<Space>g",        group = "Git" },
  { "<Space>m",        group = "Make" },
  { "<Space>l",        group = "Lsp" },
  { "<Space>o",        group = "Open" },
  { "<Space>p",        group = "Project" },
  { "<Space>q",        group = "Quit" },
  { "<Space>r",        group = "Reload" },
  { "<Space>s",        group = "Strip" },
  { "<Space>t",        group = "Telescope" },
  { "<Space>x",        group = "Edit/Errors" },
  { "<Space>w",        group = "Window" },
  { "<Space>h",        group = "Help" },
  { "<Space>y",        group = "Snippets" },
  { "<Space><Return>", group = "Make" },
  { "<Space>z",        group = "Zen" },
})
