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

-- Inclusive reverse delete find/till (also delete char under cursor)
vim.keymap.set("o", "F", "vF", { noremap = true })
vim.keymap.set("o", "T", "vT", { noremap = true })

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

-- Swap gf and gF
vim.keymap.set("n", "gf", "gF", { noremap = true })
vim.keymap.set("n", "gF", "gf", { noremap = true })

-- Easy %
vim.keymap.set("n", "mm", "%")
vim.keymap.set({ "v", "o", "x" }, "m", "%")

-- Save <N>j/k to jumplist
vim.keymap.set("n", "k", function()
  return vim.v.count > 0 and "m'" .. vim.v.count .. "k" or "gk"
end, { expr = true })

vim.keymap.set("n", "j", function()
  return vim.v.count > 0 and "m'" .. vim.v.count .. "j" or "gj"
end, { expr = true })

-- Stay in Indent Mode
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Shift Through Buffers
vim.keymap.set("n", ">", ":bnext<CR>")
vim.keymap.set("n", "<", ":bprevious<CR>")

-- Tab Through Tabs
vim.keymap.set({ "n", "i" }, "<C-TAB>", ":tabnext<CR>")
vim.keymap.set({ "n", "i" }, "<C-S-TAB>", ":tabprevious<CR>")
vim.keymap.set("n", "<leader><M-TAB>", ":tabnew<CR>")
vim.keymap.set("n", "<leader><TAB>", "gt", { desc = "Next Tab", noremap = true })
vim.keymap.set("n", "<leader><S-TAB>", "gT", { desc = "Next Previous", noremap = true })
vim.keymap.set("n", "<leader>d<TAB>", ":tabclose<CR>", { desc = "TabClose", noremap = true })

-- Resize Splits with Arrows
vim.keymap.set({ "n", "i" }, "<C-Left>", function()
  vim.cmd("stopinsert")
  vim.cmd(":vertical resize -2<CR>")
end)
vim.keymap.set({ "n", "i" }, "<C-Down>", function()
  vim.cmd("stopinsert")
  vim.cmd(":resize -2<CR>")
end)
vim.keymap.set({ "n", "i" }, "<C-Up>", function()
  vim.cmd("stopinsert")
  vim.cmd(":resize +2<CR>")
end)
vim.keymap.set({ "n", "i" }, "<C-Right>", function()
  vim.cmd("stopinsert")
  vim.cmd(":vertical resize +2<CR>")
end)

-- Move Splits with Shift+Arrows
vim.keymap.set("n", "<S-Left>", "<C-w>R")
vim.keymap.set("n", "<S-Down>", "<C-w>r")
vim.keymap.set("n", "<S-Up>", "<C-w>R")
vim.keymap.set("n", "<S-Right>", "<C-w>r")

-- Motions
vim.keymap.set("n", "]h", "]c", { desc = "Next Hunk", noremap = true })
vim.keymap.set("n", "[h", "[c", { desc = "Previous Hunk", noremap = true })
vim.keymap.set("n", "]q", ":cn<CR>", { desc = "Next QuickFix Entry" })
vim.keymap.set("n", "[q", ":cp<CR>", { desc = "Previous QuickFix Entry" })
vim.keymap.set("o", "a_", ":<C-u>lua require('config.fn').util.select_motion_char('_', 'a')<CR>", { noremap = true, silent = true })
vim.keymap.set("x", "a_", ":<C-u>lua require('config.fn').util.select_motion_char('_', 'a')<CR>", { noremap = true, silent = true })
vim.keymap.set("o", "i_", ":<C-u>lua require('config.fn').util.select_motion_char('_', 'i')<CR>", { noremap = true, silent = true })
vim.keymap.set("x", "i_", ":<C-u>lua require('config.fn').util.select_motion_char('_', 'i')<CR>", { noremap = true, silent = true })
vim.keymap.set("o", "_", ":<C-u>lua require('config.fn').util.select_motion_char('_', '')<CR>", { noremap = true, silent = true })
vim.keymap.set("x", "_", ":<C-u>lua require('config.fn').util.select_motion_char('_', '')<CR>", { noremap = true, silent = true })

-- LSP
vim.api.nvim_create_user_command("TSExplore", function()
  vim.cmd("InspectTree")
end, { desc = "Show Parse Tree" })
vim.api.nvim_create_user_command("Fmt", function()
  vim.lsp.buf.format()
  require("conform").format({ async = true, lsp_format = "fallback" })
  vim.lsp.buf.code_action({
    apply = true,
    context = {
      triggerKind = 1, -- 1: Invoked, 2: Automatic
      diagnostics = vim.diagnostic.get(0, { lnum = vim.api.nvim_win_get_cursor(0)[1] - 1 }),
      only = { "source.organizeImports" },
    },
  })
end, { desc = "Format" })
vim.keymap.set("n", "g.", vim.lsp.buf.code_action, { desc = "Code Action/Fix" })
vim.keymap.set("n", "gC", vim.lsp.buf.incoming_calls, { desc = "Callers" })
vim.keymap.set("n", "<F2>", function()
  vim.lsp.buf.rename()
end, { desc = "Rename" })
vim.keymap.set("i", "<F1>", vim.lsp.buf.signature_help, {})
vim.keymap.set({ "n", "i" }, "<F7>", require("config.fn").util.build, { desc = "Build" })
vim.keymap.set("n", "?", vim.diagnostic.open_float, { desc = "Float Diagnostic" })

vim.keymap.set("n", "]e", function()
  vim.diagnostic.jump({ count = 1, float = true, severity = vim.diagnostic.severity.ERROR })
end, { desc = "Go to next error" })
vim.keymap.set("n", "[e", function()
  vim.diagnostic.jump({ count = 1, float = true, severity = vim.diagnostic.severity.ERROR })
end, { desc = "Go to previous error" })

vim.keymap.set("n", "<leader>JJ", function()
  local client_id = vim.lsp.start_client({ name = "tcp-test", connect = { address = "127.0.0.1", port = 4321 } })
  vim.lsp.buf_attach_client(0, client_id)
end, {})

-- Lua
vim.keymap.set("n", "<leader>LL", ":lua =", { desc = ":lua =" })
vim.keymap.set("n", "<leader>LR", ':lua require("', { desc = ':lua require("' })
vim.keymap.set("n", "<leader>LF", ":lua F.", { desc = ":lua F." })

-- Custom Functions
local fn = require("config.fn")
vim.keymap.set("n", "<leader>Wx", fn.buf.close_widgets, { desc = "Close all widget windows" })
vim.api.nvim_create_user_command("QAEV", fn.buf.close_non_visible, { desc = "Quit All Except Visible" })
vim.keymap.set("n", "<leader>x", "<Plug>(nvim-elf-file-toggle-bin)", { noremap = true, silent = true, desc = "Toggle Hex" })
vim.api.nvim_create_user_command("Vh", "vertical help<CR>", {})
vim.keymap.set("n", "<leader>X", "<cmd>!chmod +x %<CR>", { desc = "chmod +x", silent = true })
vim.keymap.set("n", "<leader>sW", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Substitute word" })
vim.keymap.set("v", "<F2>", function()
  vim.cmd('normal! "zy')
  local escaped = vim.fn.escape(vim.fn.getreg("z"), "\\/")
  local left = vim.api.nvim_replace_termcodes("<Left><Left>", true, false, true)
  vim.api.nvim_feedkeys(string.format([[:%%s/\V%s//g]], escaped) .. left, "n", true)
end, { desc = "Substitute visual selection" })

vim.keymap.set("v", "<leader>lf", [[:s/\%V/\r/]], { desc = "Insert newline" })

vim.keymap.set("n", "<leader>wq", [[:%s/'/"/g<CR>]], { desc = "Rewrite quotes" })
vim.keymap.set("n", "<leader>wp", "vipgq", { desc = "Wrap paragraph" })
vim.keymap.set("n", "<leader>wt", [[:%s/\s\+$//e<CR>]], { desc = "Trim Whitespace" })
vim.keymap.set("n", "<leader>wr", [[:%s/\r//<CR>]], { desc = "Remove CR" })
vim.keymap.set({ "n", "v" }, "<leader>wn", ":s/\\\\n/\\r/g<CR>", { desc = "Wrap on literal \\n" })
vim.keymap.set({ "n", "v" }, "<leader>wo", [[:s/\(\)/\1\r/g<left><left><left><left><left><left><left><left><left>]], { desc = "Wrap on" })
vim.keymap.set("n", "<leader>wl", function()
  local pattern = vim.fn.getreg("/")
  vim.cmd([[:s/\s\+/\r/g]])
  vim.fn.setreg("/", pattern)
end, { desc = "Split words on lines" })

-- To-do
vim.keymap.set("n", "<leader>Tdi", function()
  vim.api.nvim_feedkeys("iTODO(POVIRK): ", "n", false)
end, { desc = "Insert TODO" })
vim.keymap.set("n", "<leader>Tda", function()
  vim.api.nvim_feedkeys("aTODO(POVIRK): ", "n", false)
end, { desc = "Append TODO" })
