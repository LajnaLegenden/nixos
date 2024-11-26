-- Check if running in VSCode
if vim.g.vscode then
  require("config.lazy")
  require("config.options")
  require("config.keys")
else
  -- Your existing config
  vim.g.data_dir = vim.fn.expand("$HOME") .. "/.local/share/nvim"
  require("config.lazy")
  require("config.custom")
  require("config.options")
  require("config.keys")
  require("config.pluginConfig")
end
