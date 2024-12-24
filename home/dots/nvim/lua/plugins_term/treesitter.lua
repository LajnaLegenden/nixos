return {
{
    "nvim-treesitter/nvim-treesitter",
    build = function()
        require("nvim-treesitter.install").update({ with_sync = true })()
    end,
	opts = {
		ensure_installed = {
			"c",
			"lua",
			"vim",
			"markdown",
			"vimdoc",
			"query",
			"rust",
			"regex",
			"elixir",
			"heex",
			"javascript",
			"html",
			"typescript",
			"typescriptreact",
			"javascriptreact",
		},
		sync_install = false,
		highlight = { enable = true },
		indent = { enable = true },
	},
} 
}
