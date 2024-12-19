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
set_keymap("n", "<leader>e", ":Telescope file_browser<CR>", "workbench.action.toggleSidebarVisibility")

-- Line movement (VSCode has built-in commands for these)
set_keymap("n", "-", ":normal ddp<CR>", "editor.action.moveLinesDownAction")
set_keymap("n", "_", "@='kddpk'<CR>", "editor.action.moveLinesUpAction")
set_keymap("v", "-", ":m '>+1<CR>gv=gv", "editor.action.moveLinesDownAction")
set_keymap("v", "_", ":m '<-2<CR>gv=gv", "editor.action.moveLinesUpAction")

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
