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

set_keymap(
	"n",
	"<leader>ft",
	':lua MiniFiles.open()<CR>',
	""
)

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
