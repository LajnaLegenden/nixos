-- LSP Configuration
local M = {}

-- Check if running in VSCode
local in_vscode = vim.g.vscode ~= nil

-- Helper function for buffer-local keymaps
local function buf_set_keymap(mode, lhs, nvim_rhs, vscode_cmd, opts, bufnr)
	opts = opts or {}
	opts.buffer = bufnr
	
	if in_vscode then
		vim.keymap.set(mode, lhs, function()
			vim.fn.VSCodeNotify(vscode_cmd)
		end, opts)
	else
		vim.keymap.set(mode, lhs, nvim_rhs, opts)
	end
end

-- Set up LSP keybinds when any LSP server attaches
vim.api.nvim_create_autocmd('LspAttach', {
	desc = 'LSP actions',
	callback = function(event)
		local bufnr = event.buf
		local client = assert(vim.lsp.get_client_by_id(event.data.client_id))
		-- Navigation keybinds
		if client.server_capabilities.declarationProvider then
			buf_set_keymap("n", "gD", vim.lsp.buf.declaration, "editor.action.goToDeclaration", { desc = "Go to Declaration" }, bufnr)
		end
		
		if client.server_capabilities.definitionProvider then
			buf_set_keymap("n", "gd", vim.lsp.buf.definition, "editor.action.revealDefinition", { desc = "Go to Definition" }, bufnr)
		end
		
		if client.server_capabilities.typeDefinitionProvider then
			buf_set_keymap("n", "gt", vim.lsp.buf.type_definition, "editor.action.goToTypeDefinition", { desc = "Go to Type Definition" }, bufnr)
		end
		
		if client.server_capabilities.implementationProvider then
			buf_set_keymap("n", "gi", vim.lsp.buf.implementation, "editor.action.goToImplementation", { desc = "Go to Implementation" }, bufnr)
		end
		
		if client.server_capabilities.referencesProvider then
			buf_set_keymap("n", "<leader>lr", vim.lsp.buf.references, "editor.action.goToReferences", { desc = "Show References" }, bufnr)
		end
		
		-- Documentation keybinds
		if client.server_capabilities.hoverProvider then
			buf_set_keymap("n", "K", vim.lsp.buf.hover, "editor.action.showHover", { desc = "Hover Documentation" }, bufnr)
		end
		
		if client.server_capabilities.signatureHelpProvider then
			buf_set_keymap("i", "<C-k>", vim.lsp.buf.signature_help, "editor.action.triggerParameterHints", { desc = "Signature Help" }, bufnr)
		end
		
		-- Refactoring keybinds
		if client.server_capabilities.renameProvider then
			buf_set_keymap("n", "<leader>rn", vim.lsp.buf.rename, "editor.action.rename", { desc = "Rename Symbol" }, bufnr)
		end
		
		if client.server_capabilities.codeActionProvider then
			buf_set_keymap("n", "<leader>ca", vim.lsp.buf.code_action, "editor.action.quickFix", { desc = "Code Actions" }, bufnr)
		end
		
		-- Format document (check if server supports formatting)
		if client.server_capabilities.documentFormattingProvider then
			buf_set_keymap("n", "<leader>lf", function() 
				vim.lsp.buf.format({ async = true }) 
			end, "editor.action.formatDocument", { desc = "LSP Format Document" }, bufnr)
		elseif client.server_capabilities.documentRangeFormattingProvider then
			buf_set_keymap("v", "<leader>lf", function() 
				vim.lsp.buf.format({ async = true }) 
			end, "editor.action.formatSelection", { desc = "LSP Format Selection" }, bufnr)
		end
		
		-- Diagnostics (these are always available)
		buf_set_keymap("n", "<leader>e", vim.diagnostic.open_float, "editor.action.showDiagnostics", { desc = "Show Line Diagnostics" }, bufnr)
		buf_set_keymap("n", "[d", vim.diagnostic.goto_prev, "editor.action.marker.prev", { desc = "Previous Diagnostic" }, bufnr)
		buf_set_keymap("n", "]d", vim.diagnostic.goto_next, "editor.action.marker.next", { desc = "Next Diagnostic" }, bufnr)
		buf_set_keymap("n", "<leader>q", vim.diagnostic.setloclist, "editor.action.showDiagnostics", { desc = "Diagnostics to Location List" }, bufnr)
		
		-- Workspace folders (only in Neovim and if server supports workspace folders)
		if not in_vscode and client.server_capabilities.workspaceFolders then
			buf_set_keymap("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, nil, { desc = "Add Workspace Folder" }, bufnr)
			buf_set_keymap("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, nil, { desc = "Remove Workspace Folder" }, bufnr)
			buf_set_keymap("n", "<leader>wl", function()
				print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
			end, nil, { desc = "List Workspace Folders" }, bufnr)
		end
	end,
})

-- Useful debugging command to inspect LSP client capabilities
vim.api.nvim_create_user_command('LspCapabilities', function()
	local clients = vim.lsp.get_clients({ bufnr = 0 })
	if #clients == 0 then
		vim.notify("No LSP clients attached to current buffer", vim.log.levels.WARN)
		return
	end
	
	for _, client in ipairs(clients) do
		vim.notify("LSP Client: " .. client.name, vim.log.levels.INFO)
		print("Capabilities for " .. client.name .. ":")
		print(vim.inspect(client.server_capabilities))
	end
end, { desc = "Show LSP client capabilities for current buffer" })

-- Configure diagnostic display
vim.diagnostic.config({
	virtual_text = {
		prefix = "●", -- Could be '■', '▎', 'x', '●', etc.
		source = "if_many", -- Or "always"
	},
	float = {
		source = "always", -- Or "if_many"
		border = "rounded",
	},
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "󰅚 ",
			[vim.diagnostic.severity.WARN] = "󰀪 ",
			[vim.diagnostic.severity.HINT] = "󰌶 ",
			[vim.diagnostic.severity.INFO] = " ",
		},
	},
	underline = true,
	update_in_insert = false,
	severity_sort = true,
})

return M
