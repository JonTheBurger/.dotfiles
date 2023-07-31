-- Misc.
vim.api.nvim_set_keymap("n", "\\", " ", {}) -- Alias \ to <space> <leader>
vim.keymap.set("n", "<C-c>", "<ESC>")       -- Ctrl+C == Esc
vim.keymap.set("x", "<leader>p", "\"_dP")   -- Paste & Maintain Register
vim.keymap.set("", "q:", "<NOP>")           -- Useless
vim.keymap.set("n", "<leader>x",            -- chmod +x
  "<CMD>!chmod +x %<CR>", { silent = true }
)
vim.keymap.set("n", "<leader>s",            -- Substitute word
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]]
)
vim.keymap.set("v", "<leader>lf",           -- Insert newline
  [[:s/\%V/\r/]]
)

-- Move highlighted text up/down w/ shift JK
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Cursor to Middle for PgUp/PgDown
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Cursor to Middle for Search Next/Previous
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Navigate Popup
vim.keymap.set("n", "<C-k>", "<CMD>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<CMD>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<CMD>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<CMD>lprev<CR>zz")

-- Custom Functions
local fn = require("jontheburger.functions")
vim.keymap.set("n", "<leader>r", fn.reload.config, { silent = false })
vim.keymap.set("n", "<leader>wt", [[:%s/\s\+$//e<CR>]])  -- Trim Whitespace
