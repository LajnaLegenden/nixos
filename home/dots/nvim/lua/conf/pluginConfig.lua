require("fzf-lua").setup({
	"borderless",
	fzf_opts = { ["-i"] = "" },
})

-- LSP
local lspconfig = require("lspconfig")
local servers = {
	"lua_ls",
	"nil_ls",
	"eslint",
	"html",
	"jsonls",
	"cssls",
	"gopls",
}
local on_attach = function(client, bufnr)
	local function buf_set_keymap(...)
		vim.api.nvim_buf_set_keymap(bufnr, ...)
	end
	local function buf_set_option(...)
		vim.api.nvim_buf_set_option(bufnr, ...)
	end

	buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
	local opts = { noremap = true, silent = true }

	-- Existing LSP keybindings
	buf_set_keymap("n", "gD", "<cmd>FzfLua lsp_type_definitions<CR>", opts)
	buf_set_keymap("n", "gd", "<cmd>FzfLua lsp_definitions<CR>", opts)
	buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
	buf_set_keymap("n", "gh", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
	buf_set_keymap("n", "gi", "<cmd>FzfLua lsp_implementations<CR>", opts)
	buf_set_keymap("n", "<C-.>", "<cmd>FzfLua lsp_code_actions<CR>", opts)
	buf_set_keymap("n", "<leader>ca", "<cmd>FzfLua lsp_code_actions<CR>", opts)
	buf_set_keymap("n", "gr", "<cmd>FzfLua lsp_references<CR>", opts)
	buf_set_keymap("n", "gnd", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
	buf_set_keymap("n", "gpd", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
	buf_set_keymap("n", "<leader>cl", "<cmd>lua vim.lsp.codelens.run()<cr>", opts)
	buf_set_keymap("n", "<leader>cr", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
end
-- Setup servers with capabilities and on_attach
for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup({
		capabilities = require("conf.lsputils").capabilities(),
		on_attach = on_attach,
	})
end

lspconfig.emmet_language_server.setup({
	filetypes = {
		"css",
		"eruby",
		"html",
		"javascript",
		"javascriptreact",
		"less",
		"sass",
		"scss",
		"pug",
		"typescriptreact",
	},
	-- Read more about this options in the [vscode docs](https://code.visualstudio.com/docs/editor/emmet#_emmet-configuration).
	-- **Note:** only the options listed in the table are supported.
	init_options = {
		---@type table<string, string>
		includeLanguages = {},
		--- @type string[]
		excludeLanguages = {},
		--- @type string[]
		extensionsPath = {},
		--- @type table<string, any> [Emmet Docs](https://docs.emmet.io/customization/preferences/)
	},
})

require("gitsigns").setup({
	current_line_blame = true,
	current_line_blame_opts = {
		virt_text = true,
		virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
		delay = 10,
		ignore_whitespace = false,
		virt_text_priority = 100,
		use_focus = true,
	},
})
require("mini.ai").setup()
require("lualine").setup()
require("onedarkpro").setup({
	options = {
		transparency = true,
	},
})

vim.cmd("colorscheme onedark")

vim.opt.termguicolors = true
require("bufferline").setup{}
