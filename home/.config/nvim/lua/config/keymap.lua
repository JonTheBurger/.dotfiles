-- Misc.
vim.keymap.set("n", "<C-c>", "<ESC>") -- Ctrl+C == Esc
vim.keymap.set("x", "<leader>p", '"_dP') -- Paste & Maintain Register
vim.keymap.set("", "q:", "<NOP>") -- Useless
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit Terminal Mode" })
vim.keymap.set("i", "jk", "<ESC>", { desc = "Normal Mode" })
vim.keymap.set("n", "<leader>q", "<cmd>bp|bd#<CR>", { desc = "Delete Buffer, Keep Split" })
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Yanks
vim.keymap.set("n", "yaa", "gg0yG<C-o>", { desc = "Yank all" })
vim.keymap.set("n", "yd", "yyp", { desc = "Duplicate line" })

-- Move highlighted text up/down w/ shift JK
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Cursor to Middle for PgUp/PgDown
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Cursor to Middle for Search Next/Previous
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Swap ' and `
vim.keymap.set({ "n", "o" }, "'", "`", { noremap = true })
vim.keymap.set({ "n", "o" }, "`", "'", { noremap = true })

-- Stay in Indent Mode
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Shift Through Buffers
vim.keymap.set("n", ">", ":bnext<CR>")
vim.keymap.set("n", "<", ":bprevious<CR>")

-- Tab Through Tabs
vim.keymap.set({ "n", "i" }, "<C-TAB>", ":tabnext<CR>")
vim.keymap.set({ "n", "i" }, "<C-S-TAB>", ":tabprevious<CR>")
-- vim.keymap.set("n", "<leader><M-TAB>", ":tabnew<CR>")
-- vim.keymap.set("n", "<leader><TAB>", ":tabm +1<CR>")
-- vim.keymap.set("n", "<leader><S-TAB>", ":tabm -1<CR>")

-- Resize Splits with Arrows
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>")
vim.keymap.set("n", "<C-Down>", ":resize -2<CR>")
vim.keymap.set("n", "<C-Up>", ":resize +2<CR>")
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>")

-- Move Splits with Shift+Arrows
vim.keymap.set("n", "<S-Left>", "<C-w><S-h>")
vim.keymap.set("n", "<S-Down>", "<C-w><S-j>")
vim.keymap.set("n", "<S-Up>", "<C-w><S-k>")
vim.keymap.set("n", "<S-Right>", "<C-w><S-l>")

-- Motions
vim.keymap.set("n", "]q", ":cn<CR>", { desc = "Next QuickFix Entry" })
vim.keymap.set("n", "[q", ":cp<CR>", { desc = "Previous QuickFix Entry" })
vim.keymap.set("o", "a_", ":<C-u>lua require('config.fn').select_motion_char('_', 'a')<CR>", { noremap = true, silent = true })
vim.keymap.set("x", "a_", ":<C-u>lua require('config.fn').select_motion_char('_', 'a')<CR>", { noremap = true, silent = true })
vim.keymap.set("o", "i_", ":<C-u>lua require('config.fn').select_motion_char('_', 'i')<CR>", { noremap = true, silent = true })
vim.keymap.set("x", "i_", ":<C-u>lua require('config.fn').select_motion_char('_', 'i')<CR>", { noremap = true, silent = true })
vim.keymap.set("o", "_", ":<C-u>lua require('config.fn').select_motion_char('_', '')<CR>", { noremap = true, silent = true })
vim.keymap.set("x", "_", ":<C-u>lua require('config.fn').select_motion_char('_', '')<CR>", { noremap = true, silent = true })

-- LSP
vim.api.nvim_create_user_command("Fmt", function()
  vim.lsp.buf.format()
end, { desc = "Format" })
vim.keymap.set("n", "<leader>FF", vim.lsp.buf.format, { desc = "Format" })
vim.keymap.set("n", "?", vim.diagnostic.open_float, {})
vim.keymap.set("n", "gD", vim.diagnostic.open_float, {})
vim.keymap.set({ "n", "i" }, "<C-S-SPACE>", vim.lsp.buf.signature_help, {})
vim.keymap.set("i", "<S-F1>", vim.lsp.buf.signature_help, {})
vim.keymap.set("n", "gf", vim.lsp.buf.code_action, {})
vim.keymap.set("n", "<leader>ld", function()
  vim.diagnostic.setqflist()
  vim.cmd("copen") -- Open the quickfix window
end, { desc = "Show all diagnostics in quickfix" })

-- Lua
vim.keymap.set("n", "LL", ":lua =")
vim.keymap.set("n", "LR", ':lua require("')
vim.keymap.set("n", "LF", ":lua F.")

-- Custom Functions
local fn = require("config.fn")
vim.api.nvim_create_user_command("QAEV", fn.buffer_quit_all_except_visible, { desc = "Quit All Except Visible" })
vim.keymap.set("n", "<leader>x", fn.toggle_hex, { noremap = true, silent = true, desc = "Toggle Hex" })
vim.api.nvim_create_user_command("Vh", "vertical help<CR>", {})
vim.keymap.set("n", "<leader>X", "<cmd>!chmod +x %<CR>", { desc = "chmod +x", silent = true })
vim.keymap.set("n", "<leader>sub", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Substitute word" })
vim.keymap.set("v", "<leader>lf", [[:s/\%V/\r/]], { desc = "Insert newline" })
vim.keymap.set("n", "<leader>wq", [[:%s/'/"/g]], { desc = "Rewrite quotes" })
vim.keymap.set("n", "<leader>wp", "vipgq", { desc = "Wrap paragraph" })
vim.keymap.set("n", "<leader>wt", [[:%s/\s\+$//e<CR>]], { desc = "Trim Whitespace" })
vim.keymap.set("n", "<leader>wr", [[:%s/\r//<CR>]], { desc = "Remove CR" })
vim.keymap.set("n", "<leader>wl", function()
  local pattern = vim.fn.getreg("/")
  vim.cmd([[:s/\s\+/\r/g]])
  vim.fn.setreg("/", pattern)
end, { desc = "Split words on lines" })

-- Wiki
local wiki = vim.fn.expand("~/Documents/wiki")
local diary = vim.fn.expand(wiki .. "/diary")
local edit_file = require("config.fn").edit_file
vim.keymap.set("n", "<leader>wn", function()
  edit_file(wiki .. "/index.md")
end, { desc = "Open Wiki Notes" })
vim.keymap.set("n", "<leader>ww", function()
  edit_file(wiki .. "/index.md", { cd = true })
end, { desc = "Open Wiki Index" })
vim.keymap.set("n", "<leader>wd", function()
  edit_file(diary .. "/" .. os.date("%Y-%m-%d") .. ".md")
end, { desc = "Open Daily Notes" })
vim.keymap.set("n", "<leader>wi", function()
  require("config.fn").update_diary_index(diary)
end, { desc = "Update Diary Index" })

-- To-do
vim.keymap.set("n", "<leader>Tdi", function()
  vim.api.nvim_feedkeys("iTODO(POVIRK): ", "n", false)
end, { desc = "Insert TODO" })
vim.keymap.set("n", "<leader>Tda", function()
  vim.api.nvim_feedkeys("aTODO(POVIRK): ", "n", false)
end, { desc = "Append TODO" })
