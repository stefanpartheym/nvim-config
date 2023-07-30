local map = vim.keymap.set
local del = vim.api.nvim_del_keymap

-- Unset unwanted keymaps
del("n", "<C-/>")
del("n", "<leader>xl")
del("n", "<leader>xq")
del("t", "<C-h>")
del("t", "<C-j>")
del("t", "<C-k>")
del("t", "<C-l>")

--
-- General
--
map("n", "<C-y>", "<Cmd>%y+<Cr>", { desc = "Copy current buffer to system clipboard" })

--
-- Buffers
--
map("n", "<S-Tab>", "<S-h>", { remap = true, desc = "Previous buffer" })
map("n", "<Tab>", "<S-l>", { remap = true, desc = "Next buffer" })
map("n", "<leader>x", "<leader>bd", { remap = true, desc = "Close current buffer" })

--
-- Coding
--
-- Toggle line comment
map("n", "<C-_>", "gcc", { remap = true, desc = "Toggle line comment" })
-- Toggle comment (visual mode)
map("v", "<C-_>", "gc", { remap = true, desc = "Comment selection" })

-- Cursor navigation (insert mode)
map("i", "<C-h>", "<Left>", { desc = "Move cursor left" })
map("i", "<C-l>", "<Right>", { desc = "Move cursor right" })
map("i", "<C-j>", "<Down>", { desc = "Move cursor down" })
map("i", "<C-k>", "<Up>", { desc = "Move cursor up" })
map("i", "<C-b>", "<Esc>^i", { desc = "Move cursor to beginning of line" })
map("i", "<C-e>", "<End>", { desc = "Move cursor to end of line" })

-- Terminal
map("t", "<C-x>", vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, true, true), { desc = "Enter Normal Mode" })
