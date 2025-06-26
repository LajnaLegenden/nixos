require("config.lazy")
require("config.keys")

-- LSP Setup
require("config.lsp")

-- Enable LSP servers (they will automatically use the global LspAttach autocmd)
vim.lsp.enable('luals')
vim.lsp.enable('vtsls')
vim.lsp.enable('eslint')
vim.lsp.enable('biome')
vim.lsp.enable('gopls')
vim.lsp.enable('nixd')

-- Show line numbers
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.shiftwidth = 2     -- Set indentation width
vim.opt.expandtab = true   -- Use spaces instead of tabs
vim.opt.smartindent = true -- Auto indent new lines
vim.o.foldcolumn = '1'     -- '0' is not bad
vim.o.foldlevel = 99       -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

-- Enable folding
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true
}
local language_servers = vim.lsp.get_clients() -- or list servers manually like {'gopls', 'clangd'}
for _, ls in ipairs(language_servers) do
  require('lspconfig')[ls].setup({
    capabilities = capabilities
    -- you can add other fields for setting up lsp server in this table
  })
end
