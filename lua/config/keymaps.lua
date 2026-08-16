vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.keymap.set

map("n", ";", ":", { desc = "Command mode" })
map("i", "jk", "<ESC>", { desc = "Exit insert mode" })

map("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })
map("i", "<C-s>", "<cmd>w<CR>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit window" })

map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

map({ "n", "v" }, "<leader>y", [["+y]], { desc = "Copy to system clipboard" })
map({ "n", "v" }, "<leader>p", [["+p]], { desc = "Paste from system clipboard" })

map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })

map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })

map("n", "<C-Up>", "<cmd>resize +3<CR>", { desc = "Resize height up" })
map("n", "<C-Down>", "<cmd>resize -3<CR>", { desc = "Resize height down" })
map("n", "<C-Left>", "<cmd>vertical resize -3<CR>", { desc = "Resize width left" })
map("n", "<C-Right>", "<cmd>vertical resize +3<CR>", { desc = "Resize width right" })

map("n", "<leader>sv", "<cmd>vsplit<CR>", { desc = "Split vertical" })
map("n", "<leader>sh", "<cmd>split<CR>", { desc = "Split horizontal" })
map("n", "<leader>sc", "<cmd>close<CR>", { desc = "Close window" })
map("n", "<C-x>", "<cmd>close<CR>", { desc = "Close window" })
map("n", "<leader>so", "<cmd>only<CR>", { desc = "Close other windows" })
map("n", "<leader>qa", "<cmd>qa<CR>", { desc = "Quit all windows" })

map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

map("n", "<leader>th", function() require("config.theme").select() end, { desc = "Switch theme" })

require("config.lsp").setup()