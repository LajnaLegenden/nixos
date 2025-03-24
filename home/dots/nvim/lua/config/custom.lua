local function rename_current_file()
	-- Get file name
	local file_path = vim.fn.expand("%:p")
	-- Prevent crashing when editing files that are not created yet
	if file_path == "" then
		return
	end
	-- Request input for changing file name
	vim.ui.input({ prompt = "New file name > ", default = file_path, completion = "file" }, function(new_file_path)
		if new_file_path and file_path ~= new_file_path then
			os.execute("mv " .. file_path .. " " .. new_file_path) -- Move the current file
			vim.cmd.edit(new_file_path) -- Open the newly created file
		end
	end)
end

local function create_new_file()
	-- Get path to current file
	local location_path = vim.fn.expand("%:p:h") .. "/"
	-- Request name for new file with path
	vim.ui.input({ prompt = "Name for new file > ", default = location_path, completion = "file" }, function(file_path)
		if file_path and file_path ~= location_path then
			-- Create the new file
			os.execute("touch " .. file_path)
			-- Navigate to the newly created file
			vim.cmd.edit(file_path)
		end
	end)
end

-- Motivation: When I open a big repo,
-- sometimes, I want to go to a file, and
-- make the folder where the file is placed
-- by "session root folder". This means
-- that my fzf search will only output
-- occurrences for the nw "session root folder" .
-- This works with other tools, like nerdtree, as well.
local function change_session_root()
	vim.cmd("cd " .. vim.fn.expand("%:p:h"))
end

-- Triggers :FzfLua files with variable
-- name that is currently under the cursor.
-- Useful when working with amend.
local function search_with_word()
	-- Pick word under the cursor
	local current_word = vim.fn.expand("<cword>")
	-- Trigger FzfLua files screen with search state set to current_word
	require("fzf-lua").files({ query = current_word })
end

-- Triggers :FzfLua files with variable
-- name that is currently under the cursor.
-- Useful when working with amend.
local function grep_search_with_word()
	-- Pick word under the cursor
	local current_word = vim.fn.expand("<cword>")
	-- Trigger FzfLua files screen with search state set to current_word
	require("fzf-lua").live_grep_native({ query = current_word })
	-- Trigger backspace, because FzfLua files seems to add ">" sign at the
	-- end of query value
end

-- Triggers :FzfLua files with text
-- that is currently selected in visual mode.
local function search_with_selection()
	-- Get visually selected text
	local start_pos = vim.fn.getpos("'<")
	local end_pos = vim.fn.getpos("'>")
	local start_line, start_col = start_pos[2], start_pos[3]
	local end_line, end_col = end_pos[2], end_pos[3]
	
	-- Get the text based on selection type
	local selected_text = ""
	if start_line == end_line then
		-- Single line selection
		local line = vim.fn.getline(start_line)
		selected_text = string.sub(line, start_col, end_col)
	else
		-- Multi-line selection (gets first line only for simplicity)
		local line = vim.fn.getline(start_line)
		selected_text = string.sub(line, start_col)
	end
	
	-- Trigger FzfLua files screen with search state set to selected_text
	require("fzf-lua").files({ query = selected_text })
end

-- Triggers :FzfLua live_grep with text
-- that is currently selected in visual mode.
local function grep_search_with_selection()
	-- Get visually selected text
	local start_pos = vim.fn.getpos("'<")
	local end_pos = vim.fn.getpos("'>")
	local start_line, start_col = start_pos[2], start_pos[3]
	local end_line, end_col = end_pos[2], end_pos[3]
	
	-- Get the text based on selection type
	local selected_text = ""
	if start_line == end_line then
		-- Single line selection
		local line = vim.fn.getline(start_line)
		selected_text = string.sub(line, start_col, end_col)
	else
		-- Multi-line selection (gets first line only for simplicity)
		local line = vim.fn.getline(start_line)
		selected_text = string.sub(line, start_col)
	end
	
	-- Trigger FzfLua live_grep with search state set to selected_text
	require("fzf-lua").live_grep_native({ query = selected_text })
end

return {
	rename_current_file = rename_current_file,
	create_new_file = create_new_file,
	change_session_root = change_session_root,
	search_with_word = search_with_word,
	grep_search_with_word = grep_search_with_word,
	search_with_selection = search_with_selection,
	grep_search_with_selection = grep_search_with_selection,
}

