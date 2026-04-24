-- Misc.
vim.keymap.set("n", "<C-c>", "<ESC>") -- Ctrl+C == Esc
vim.keymap.set("x", "<leader>p", '"_dP') -- Paste & Maintain Register
vim.keymap.set("", "q:", "<NOP>") -- Useless
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit Terminal Mode" })
vim.keymap.set("i", "jk", "<ESC>", { desc = "Normal Mode" })
vim.keymap.set("n", "<leader>q", "<cmd>bp|bd#<CR>", { desc = "Delete Buffer, Keep Split" })
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Yanks
vim.keymap.set("n", "yA", "gg0yG<C-o>", { desc = "Yank all" })
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
vim.keymap.set("n", "<leader>c<TAB>", ":tabnew<CR>", { desc = "New Tab", noremap = true })
vim.keymap.set("n", "<leader><TAB>", "gt", { desc = "Next Tab", noremap = true })
vim.keymap.set("n", "<leader><S-TAB>", "gT", { desc = "Previous Tab", noremap = true })
vim.keymap.set("n", "<leader>d<TAB>", ":tabclose<CR>", { desc = "Tab Close", noremap = true })

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

vim.cmd("packadd nvim.undotree")
vim.keymap.set("n", "<leader>U", require("undotree").open, { desc = "Toggle Undotree" })

-- LSP
-- incremental selection treesitter/lsp
vim.keymap.set({ "n", "x", "o" }, "<A-o>", function()
  if vim.treesitter.get_parser(nil, nil, { error = false }) then
    require("vim.treesitter._select").select_parent(vim.v.count1)
  else
    vim.lsp.buf.selection_range(vim.v.count1)
  end
end, { desc = "Select parent treesitter node or outer incremental lsp selections" })
vim.keymap.set({ "n", "x", "o" }, "<A-i>", function()
  if vim.treesitter.get_parser(nil, nil, { error = false }) then
    require("vim.treesitter._select").select_child(vim.v.count1)
  else
    vim.lsp.buf.selection_range(-vim.v.count1)
  end
end, { desc = "Select child treesitter node or inner incremental lsp selections" })

vim.api.nvim_create_user_command("TSExplore", function()
  vim.cmd("InspectTree")
end, { desc = "Show Parse Tree" })

vim.keymap.set("n", "g.", vim.lsp.buf.code_action, { desc = "Code Action/Fix" })
vim.keymap.set("n", "gC", vim.lsp.buf.incoming_calls, { desc = "Callers" })
vim.keymap.set("n", "<F2>", function()
  vim.lsp.buf.rename()
end, { desc = "Rename" })
vim.keymap.set("i", "<F1>", vim.lsp.buf.signature_help, {})
vim.keymap.set({ "n", "i" }, "<F7>", require("config.fn").util.build, { desc = "Build" })
vim.keymap.set("n", "?", function()
  if require("dap").session() then
    -- require("dapui").eval()
    require("dap.ui.widgets").hover()
  else
    vim.diagnostic.open_float()
  end
end, { desc = "Float Diagnostic" })

vim.keymap.set("n", "]e", function()
  vim.diagnostic.jump({ count = 1, float = true, severity = vim.diagnostic.severity.ERROR })
end, { desc = "Go to next error" })
vim.keymap.set("n", "[e", function()
  vim.diagnostic.jump({ count = 1, float = true, severity = vim.diagnostic.severity.ERROR })
end, { desc = "Go to previous error" })

-- Lua
vim.keymap.set("n", "<leader>LL", ":lua =", { desc = ":lua =" })
vim.keymap.set("n", "<leader>LR", ':lua require("', { desc = ':lua require("' })
vim.keymap.set("n", "<leader>LF", ":lua F.", { desc = ":lua F." })

-- Custom Functions
local fn = require("config.fn")
vim.keymap.set("n", "<leader>Wx", fn.buf.close_widgets, { desc = "Close all widget windows" })
vim.keymap.set("n", "__", fn.buf.close_widgets, { desc = "Close all widget windows" })
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

-- Yanks
vim.keymap.set("n", "yF", function()
  local path = vim.api.nvim_buf_get_name(0)
  for _, reg in ipairs({'"', "+", "*"}) do
    vim.fn.setreg(reg, path)
  end
end, { desc = "Yank Filename" })
vim.keymap.set("n", "yR", function()
  local path = vim.fn.expand("%:.")
  for _, reg in ipairs({'"', "+", "*"}) do
    vim.fn.setreg(reg, path)
  end
end, { desc = "Yank Filename, Relative" })
vim.keymap.set("n", "yN", function()
  local path = vim.fn.expand("%:.")
  local pos = require("config.fn").str.rfind_char(path, "/")
  if pos then
    path = path:sub(pos + 1)
  end
  for _, reg in ipairs({'"', "+", "*"}) do
    vim.fn.setreg(reg, path)
  end
end, { desc = "Yank Filename, Basename" })

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
