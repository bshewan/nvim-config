-- =============================================================================
-- KEYMAP CONFIGURATION
-- =============================================================================

-- 1. SET LEADER KEY
-- Must happen before plugins are loaded (otherwise plugin mappings might fail)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.keymap.set

-- =============================================================================
-- GENERAL UI & BEHAVIOR
-- =============================================================================

-- Clear search highlights with <Esc>
-- (Stops the annoying yellow highlighting after you finish searching)
map("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Save file with Ctrl+s (Like a normal editor)
map({ "n", "i", "v" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

-- Quit with <leader>q
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })

-- Center the screen when scrolling half-page
-- (Keeps your cursor in the middle so you don't lose context)
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- Center the screen when searching next/prev result
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- =============================================================================
-- WINDOW MANAGEMENT
-- =============================================================================

-- Split windows easier (Leader + pipe/minus is awkward)
map("n", "<leader>sv", "<C-w>v", { desc = "Split Vertical" })
map("n", "<leader>sh", "<C-w>s", { desc = "Split Horizontal" })

-- Resize windows with Arrows (if you aren't using the mouse)
map("n", "<Up>", ":resize +2<CR>", { desc = "Resize Up" })
map("n", "<Down>", ":resize -2<CR>", { desc = "Resize Down" })
map("n", "<Left>", ":vertical resize -2<CR>", { desc = "Resize Left" })
map("n", "<Right>", ":vertical resize +2<CR>", { desc = "Resize Right" })

-- Note: Navigation (<C-h/j/k/l>) is handled by your 'vim-tmux-navigator' plugin

-- =============================================================================
-- CODING / EDITING
-- =============================================================================

-- Indent/Outdent while staying in Visual Mode
-- (Standard Vim exits visual mode after one indent, which
