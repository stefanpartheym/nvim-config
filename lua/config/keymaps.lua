local map = vim.keymap.set

--
-- General
--
map("x", "<leader>p", '"_dP', { desc = "Paste without yank" })
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })
map("n", "<Esc>", "<cmd>nohlsearch<cr>")
map("n", "<leader>q", "<cmd>qa<cr>", { desc = "Quit all" })

--
-- Windows
--
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })

--
-- Buffers
--
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>bn", "<cmd>enew<cr>", { desc = "New buffer" })
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to other buffer" })

--
-- Editing
--

-- Better indenting (will keep visual mode after indentation)
map("v", "<", "<gv")
map("v", ">", ">gv")

--
-- Terminal
--

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
map("t", "<C-x>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

--
-- Misc keymaps
--

-- Lazy
map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- vim: ts=2 sts=2 sw=2 et
