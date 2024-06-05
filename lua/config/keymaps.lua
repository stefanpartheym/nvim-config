local map = vim.keymap.set
local del = vim.api.nvim_del_keymap

-- Unset unwanted keymaps
del("t", "<C-h>")
del("t", "<C-j>")
del("t", "<C-k>")
del("t", "<C-l>")
del("n", "<leader>l")
del("n", "<leader>L")
del("n", "<leader>xl")
del("n", "<leader>xq")

--
-- General
--
map("n", "<C-y>", "<Cmd>%y+<Cr>", { desc = "Copy current buffer to system clipboard" })
map("x", "<leader>p", '"_dP', { desc = "Paste without yank" })

--
-- Coding
--
-- Cursor navigation (insert mode)
map("i", "<C-h>", "<Left>", { desc = "Move cursor left" })
map("i", "<C-l>", "<Right>", { desc = "Move cursor right" })
map("i", "<C-j>", "<Down>", { desc = "Move cursor down" })
map("i", "<C-k>", "<Up>", { desc = "Move cursor up" })
map("i", "<C-b>", "<Esc>^i", { desc = "Move cursor to beginning of line" })
map("i", "<C-e>", "<End>", { desc = "Move cursor to end of line" })

-- Terminal
map("t", "<C-x>", vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, true, true), { desc = "Enter Normal Mode" })

-- Misc
map("n", "<leader>Ll", "<cmd>Lazy<cr>", { desc = "Lazy" })
map("n", "<leader>Le", "<cmd>LazyExtras<cr>", { desc = "LazyExtras" })
