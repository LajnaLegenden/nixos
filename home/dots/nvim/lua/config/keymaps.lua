-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("i", "jk", "<Esc>", { noremap = true, silent = true, desc = "Exit insert mode" })

-- Easier access to brackets and braces
vim.keymap.set("n", "ö", "[", { noremap = true, desc = "Easy [ access" })
vim.keymap.set("n", "ä", "]", { noremap = true, desc = "Easy ] access" })
vim.keymap.set("n", "Ö", "{", { noremap = true, desc = "Easy { access" })
vim.keymap.set("n", "Ä", "}", { noremap = true, desc = "Easy } access" })

-- Quick pair insertion in insert mode
vim.keymap.set("i", "öä", "[]<Left>", { noremap = true, desc = "Insert []" })
vim.keymap.set("i", "ÖÄ", "{}<Left>", { noremap = true, desc = "Insert {}" })
-- Easier window navigation
vim.keymap.set("n", "<A-h>", "<C-w>h", { noremap = true, desc = "Move to left window" })
vim.keymap.set("n", "<A-j>", "<C-w>j", { noremap = true, desc = "Move to bottom window" })
vim.keymap.set("n", "<A-k>", "<C-w>k", { noremap = true, desc = "Move to top window" })
vim.keymap.set("n", "<A-l>", "<C-w>l", { noremap = true, desc = "Move to right window" })
-- Toggle line numbers
vim.keymap.set("n", "<leader>n", ":set invnumber<CR>", { noremap = true, desc = "Toggle line numbers" })

-- Toggle relative line numbers
vim.keymap.set("n", "<leader>r", ":set invrelativenumber<CR>", { noremap = true, desc = "Toggle relative numbers" })
