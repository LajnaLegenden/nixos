require("config.lazy")
require("config.keys")

-- LSP Setup
require("config.lsp")

-- Enable LSP servers (they will automatically use the global LspAttach autocmd)
vim.lsp.enable('luals')
vim.lsp.enable('vtsls')
vim.lsp.enable('eslint')
vim.lsp.enable('biome')

-- Show line numbers
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
