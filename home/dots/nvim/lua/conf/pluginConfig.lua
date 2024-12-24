require("fzf-lua").setup({
	"telescope",
	fzf_opts = { ["-i"] = "" },
})

-- LSP
local lspconfig = require("lspconfig")
local eslint = require("eslint")
lspconfig.lua_ls.setup({})
eslint.setup({
	bin = "eslint_d", -- or `eslint_d`
	code_actions = {
		enable = true,
		apply_on_save = {
			enable = true,
			types = { "directive", "problem", "suggestion", "layout" },
		},
	},
	diagnostics = {
		enable = true,
		report_unused_disable_directives = false,
		run_on = "type", -- or `save`
	},
})

-- Define on_attach before using it
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
	buf_set_keymap("n", "gr", "<cmd>FzfLua lsp_references<CR>", opts)
	buf_set_keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
	buf_set_keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
	buf_set_keymap("n", "<leader>cl", "<cmd>lua vim.lsp.codelens.run()<cr>", opts)
	buf_set_keymap("n", "<leader>cr", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
end

require("gitsigns").setup({
	current_line_blame = true,
	current_line_blame_opts = {
		virt_text = true,
		virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
		delay = 250,
		ignore_whitespace = false,
		virt_text_priority = 100,
		use_focus = true,
	},
})
require("lualine").setup()
require("onedarkpro").setup({
	options = {
		transparency = true,
	},
})
vim.cmd("colorscheme onedark")
local servers = {
	"lua_ls",
	"nil_ls",
}
-- Setup servers with capabilities and on_attach
for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup({
		capabilities = require("conf.lsputils").capabilities(),
		on_attach = require("conf.lsputils").on_attach(on_attach),
	})
end

