return {
	"ThePrimeagen/refactoring.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	lazy = false,
	config = function()
		local jsPrint = "console.log({\nmessage: '%s', \n%s\n },\n { depth: null }\n)"
		require("refactoring").setup({
			debug = false,
			print_var_statements = {
				typescript = {
					jsPrint,
				},
				typescriptreact = {
					jsPrint,
				},
                javascript = {
					jsPrint,
				},
                javascriptreact = {
					jsPrint,
				}
			},
			printf_statements = {
				-- add a custom printf statement for cpp
				typescript = {
					jsPrint,
				},
				typescriptreact = {
					jsPrint,
				},
				javascript = {
					jsPrint,
				},
				javascriptreact = {
					jsPrint,
				},
			},
		})

		vim.keymap.set({ "n", "x" }, "<leader>rr", function()
			require("telescope").extensions.refactoring.refactors()
		end)
		vim.keymap.set({ "x", "n" }, "<leader>rv", function()
			require("refactoring").debug.print_var()
		end)
		-- Supports both visual and normal mode

		vim.keymap.set("n", "<leader>rc", function()
			require("refactoring").debug.cleanup({})
		end)
		-- Supports only normal mode
	end,
}
