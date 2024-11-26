vim.opt.number = true         -- Show line numbers
vim.opt.relativenumber = true -- Relative line numbers
vim.opt.tabstop = 4           -- Set tab width to 4 spaces
vim.opt.softtabstop = 4       -- Use 4 spaces when pressing tab
vim.opt.shiftwidth = 2        -- Set indentation width
vim.opt.expandtab = true      -- Use spaces instead of tabs
vim.opt.smartindent = true    -- Auto indent new lines

vim.opt.swapfile = true      -- Enables swapfiles  (safer multi-session file editing)
vim.opt.backup = false       -- Disable backups as it creates "ghost" (garbage) next to source file
vim.o.updatetime = 300       -- Faster tick (in my case, showing the errors popup on hover faster)
vim.o.signcolumn = "yes"     -- Always show signcolumn
vim.o.colorcolumn = "100"     -- Show color column at 100 characters
-- Override line numbers color after colorscheme is applied
-- NOTE: This setting only works if "termguicolors" is "true"
vim.cmd('highlight LineNr guifg=white')

-- Make background transparent
vim.cmd [[hi Normal guibg=NONE ctermbg=NONE]]


