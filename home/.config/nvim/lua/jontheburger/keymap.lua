-- Misc.
vim.api.nvim_set_keymap("n", "\\", " ", {})  -- Alias \ to <space> <leader>
vim.keymap.set("n", "<C-c>", "<ESC>")        -- Ctrl+C == Esc
vim.keymap.set("x", "<leader>p", "\"_dP")    -- Paste & Maintain Register
vim.keymap.set("", "q:", "<NOP>")            -- Useless
vim.keymap.set("t", "<ESC>", [[<C-\><C-n>]]) -- Seriously, quit terminal mode
vim.keymap.set("i", "jk", "<ESC>", { desc = "Normal Mode" })
vim.keymap.set("n", "]q", ":cn<CR>", { desc = "Next QuickFix Entry" })
vim.keymap.set("n", "[q", ":cp<CR>", { desc = "Previous QuickFix Entry" })
vim.keymap.set("n", "<leader>X",
  "<CMD>!chmod +x %<CR>",
  { desc = "chmod +x", silent = true }
)
vim.keymap.set("n", "<leader>s",
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "Substitute word" }
)
vim.keymap.set("v", "<leader>lf",
  [[:s/\%V/\r/]],
  { desc = "Insert newline" }
)
vim.keymap.set("n", "<leader>wp", "vipgq", { desc = "Wrap paragraph" })
vim.keymap.set("n", "<leader>wt", [[:%s/\s\+$//e<CR>]], { desc = "Trim Whitespace" })
vim.keymap.set("n", "<leader>wr", [[:%s/\r//<CR>]], { desc = "Remove CR" })
vim.keymap.set("n", "<leader>wl", function()
    local pattern = vim.fn.getreg("/")
    vim.cmd([[:s/\s\+/\r/g]])
    vim.fn.setreg("/", pattern)
  end,
  { desc = "Split words on lines" }
)
vim.keymap.set("", "<leader>/", "//-1<Left><Left><Left>", { desc = "Line before search" })
vim.keymap.set("", "<leader>?", "//+1<Left><Left><Left>", { desc = "Line after search" })
vim.keymap.set("n", "<leader>n", "<CMD>nohl<CR>", { desc = "No Highlight Search" })
vim.keymap.set("n", "<leader>q", "<CMD>bp|bd#<CR>", { desc = "Delete Buffer, Keep Split" })
vim.keymap.set("n", "ci_", "dt_dT_i", { desc = "inner _underscores_" })
vim.keymap.set("n", "ci,", "dt,dT,i", { desc = "inner ,commas," })

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
vim.keymap.set({ "n", "o", }, "'", "`", { noremap = true })
vim.keymap.set({ "n", "o", }, "`", "'", { noremap = true })

-- Stay in Indent Mode
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Shift Through Buffers
vim.keymap.set("n", ">", ":bnext<CR>")
vim.keymap.set("n", "<", ":bprevious<CR>")

-- Tab Through Tabs
vim.keymap.set({ "n", "i" }, "<C-TAB>",   ":tabnext<CR>")
vim.keymap.set({ "n", "i" }, "<C-S-TAB>", ":tabprevious<CR>")
vim.keymap.set("n", "<leader><TAB>", ":tabnew<CR>")
vim.keymap.set("n", "<leader><C-S-TAB>", ":tabm -1<CR>")
vim.keymap.set("n", "<leader><C-TAB>", ":tabm +1<CR>")

-- Split Navigation (See tmux.lua)
-- vim.keymap.set("n", "<C-h>", "<C-w><C-h>")
-- vim.keymap.set("n", "<C-j>", "<C-w><C-j>")
-- vim.keymap.set("n", "<C-k>", "<C-w><C-k>")
-- vim.keymap.set("n", "<C-l>", "<C-w><C-l>")

-- Resize Splits with Arrows
vim.keymap.set("n", "<C-Left>",  ":vertical resize -2<CR>")
vim.keymap.set("n", "<C-Down>",  ":resize -2<CR>")
vim.keymap.set("n", "<C-Up>",    ":resize +2<CR>")
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>")

-- Move Splits with Shift+Arrows
vim.keymap.set("n", "<S-Left>",  "<C-w><S-h>")
vim.keymap.set("n", "<S-Down>",  "<C-w><S-j>")
vim.keymap.set("n", "<S-Up>",    "<C-w><S-k>")
vim.keymap.set("n", "<S-Right>", "<C-w><S-l>")

-- Custom Functions
vim.keymap.set("n", "<leader>Tdi", function ()
  vim.api.nvim_feedkeys("iTODO(POVIRK): ", "n", false)
end, { desc = "Insert TODO" })
vim.keymap.set("n", "<leader>Tda", function ()
  vim.api.nvim_feedkeys("aTODO(POVIRK): ", "n", false)
end, { desc = "Append TODO" })
