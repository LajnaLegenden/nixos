-- Check if running in VSCode
local in_vscode = vim.g.vscode ~= nil

-- Helper function to set conditional keymaps
local function set_keymap(mode, lhs, nvim_rhs, vscode_cmd)
	if in_vscode then
		vim.keymap.set(mode, lhs, function()
			vim.fn.VSCodeNotify(vscode_cmd)
		end)
	else
		vim.keymap.set(mode, lhs, nvim_rhs)
	end
end

-- Helper function to set keymap with cursor word
local function set_keymap_with_word(mode, lhs, nvim_rhs, vscode_cmd)
	if in_vscode then
		vim.keymap.set(mode, lhs, function()
			local word = vim.fn.expand("<cword>")
			vim.fn.VSCodeNotify(vscode_cmd, word)
		end)
	else
		vim.keymap.set(mode, lhs, nvim_rhs)
	end
end

-- File navigation
set_keymap("n", "<leader>fg", ":FzfLua live_grep_native<CR>", "find-it-faster.findWithinFiles")
set_keymap("n", "<leader>ff", ":FzfLua files<CR>", "workbench.action.quickOpen")
set_keymap("n", "<leader><leader>", ":FzfLua files<CR>", "find-it-faster.findFiles")
set_keymap("n", "<C-p>", ":FzfLua buffers<CR>", "workbench.action.showAllEditors")

-- File explorer
set_keymap("n", "<leader>ee", ":Neotree toggle<CR>", "workbench.action.toggleSidebarVisibility")
set_keymap("n", "<leader>er", ":Neotree reveal<CR>", "workbench.action.toggleSidebarVisibility")

-- Line movement (VSCode has built-in commands for these)
set_keymap("n", "-", ":normal ddp<CR>", "editor.action.moveLinesDownAction")
set_keymap("n", "_", "@='kddpk'<CR>", "editor.action.moveLinesUpAction")
set_keymap("v", "-", ":m '>+1<CR>gv=gv", "editor.action.moveLinesDownAction")
set_keymap("v", "_", ":m '<-2<CR>gv=gv", "editor.action.moveLinesUpAction")

-- Line diagnostic
set_keymap("n", "<leader>ld", ":lua vim.diagnostic.open_float()<CR>", "editor.action.showDefinitionPreviewHover")
set_keymap("v", "<leader>ld", ":lua vim.diagnostic.open_float()<CR>", "editor.action.showDefinitionPreviewHover")

-- Search/Find references
set_keymap_with_word(
	"n",
	"<leader>d",
	':lua require"config.custom".search_with_word()<CR>',
	"find-it-faster.findReferences"
)

set_keymap_with_word(
	"n",
	"<leader>s",
	':lua require"config.custom".grep_search_with_word()<CR>',
	"find-it-faster.findWithinFiles"
)
-- Numeric tab navigation
for i = 1, 9 do
	set_keymap(
		"n",
		string.format("<leader>b%d", i),
		string.format(':lua require("bufferline").go_to_buffer(%d)<CR>', i),
		string.format("workbench.action.openEditorAtIndex%d", i - 1) -- VSCode is 0-based
	)
end

-- Tab navigation
set_keymap("n", "<leader>bn", ":bnext<CR>", "workbench.action.nextEditor")
set_keymap("n", "<leader>bp", ":bprevious<CR>", "workbench.action.previousEditor")
set_keymap("n", "<leader>bd", ":bdelete<CR>", "workbench.action.closeActiveEditor")
set_keymap("n", "<leader>bb", ":b#<CR>", "workbench.action.navigateBack")
set_keymap("n", "<leader>t", ":FzfLua buffers<CR>", "workbench.action.quickOpen")

-- Refactoring
vim.keymap.set(
	{"n", "x"},
	"<leader>rr",
	function() require('telescope').extensions.refactoring.refactors() end,
	{desc = "Show refactoring options"}
)

-- You can also use below = true here to to change the position of the printf
-- statement (or set two remaps for either one). This remap must be made in normal mode.
vim.keymap.set(
	"n", 
	"<leader>rp",
	function() require('refactoring').debug.printf({below = false}) end,
	{desc = "Add printf debug statement"}
)

-- Print var
vim.keymap.set(
	{"x", "n"}, 
	"<leader>rv", 
	function() require('refactoring').debug.print_var() end,
	{desc = "Print variable debug statement"}
)
-- Supports both visual and normal mode

vim.keymap.set(
	"n", 
	"<leader>rc", 
	function() require('refactoring').debug.cleanup({}) end,
	{desc = "Clean up debug statements"}
)
