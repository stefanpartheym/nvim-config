-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local Util = require("lazyvim.util")
local MiniComment = require("mini.comment")
local map = vim.keymap.set
local del = vim.api.nvim_del_keymap

-- Unset keymaps
del("n", "<C-/>")
del("n", "<leader>xl")
del("n", "<leader>xq")
del("t", "<C-h>")
del("t", "<C-j>")
del("t", "<C-k>")
del("t", "<C-l>")

-- Normal mode
if Util.has("bufferline.nvim") then
  map("n", "<S-tab>", "<Cmd>BufferLineCyclePrev<Cr>", { desc = "Prev buffer" })
  map("n", "<tab>", "<Cmd>BufferLineCycleNext<Cr>", { desc = "Next buffer" })
else
  map("n", "<S-tab>", "<Cmd>bprevious<Cr>", { desc = "Prev buffer" })
  map("n", "<tab>", "<Cmd>bnext<Cr>", { desc = "Next buffer" })
end
map("n", "<Esc>", "<Cmd>noh<Cr>", { desc = "Clear highlighing" })
map("n", "<C-y>", "<Cmd>%y+<Cr>", { desc = "Copy whole file" })
map("n", "<C-_>", function()
  return MiniComment.operator() .. "_"
end, { expr = true, desc = "Comment line" })

-- Insert mode
map("i", "<C-h>", "<Left>", { desc = "Move cursor left" })
map("i", "<C-l>", "<Right>", { desc = "Move cursor right" })
map("i", "<C-j>", "<Down>", { desc = "Move cursor down" })
map("i", "<C-k>", "<Up>", { desc = "Move cursor up" })
map("i", "<C-b>", "<Esc>^i", { desc = "Move cursor to beginning of line" })
map("i", "<C-e>", "<End>", { desc = "Move cursor to end of line" })

-- Terminal mode
map("t", "<C-x>", vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, true, true), { desc = "Enter Normal Mode" })
