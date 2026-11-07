---@module "Key Bindings"
----------------------------------------------------------------------------------------
---@section General
----------------------------------------------------------------------------------------
vim.keymap.set("n", "<C-c>", "<ESC>", { desc = "Ctrl+C == <Esc>" })
vim.keymap.set("x", "<leader>p", '"_dP', { desc = "Paste & Maintain Register" })
vim.keymap.set("", "q:", "<NOP>", { desc = "Nobody likes q: Command Line Window" })
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit Terminal Mode" })
vim.keymap.set("i", "jk", "<ESC>", { desc = "Normal Mode" })
vim.keymap.set("n", "<leader>q", "<cmd>bp|bd#<CR>", { desc = "Delete Buffer, Keep Split" })
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search" })
vim.keymap.set("n", "<leader>RR", "<cmd>restart<CR>", { desc = "Reload Neovim" })
vim.keymap.set("n", "<leader>X", "<cmd>!chmod +x %<CR>", { silent = true, desc = "chmod +x" })

vim.keymap.set("o", "F", "vF", { desc = "Inclusive reverse find (also delete char under cursor)" })
vim.keymap.set("o", "T", "vT", { desc = "Inclusive reverse till (also delete char under cursor)" })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { silent = true, desc = "Move selected text down with Shift-J" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { silent = true, desc = "Move selected text up with Shift-K" })

vim.keymap.set("v", "<", "<gv", { desc = "Stay in indent mode after de-indenting" })
vim.keymap.set("v", ">", ">gv", { desc = "Stay in indent mode after indenting" })

vim.keymap.set("n", "<S-h>", function() require("config.fn").buf.jump("prev") end, { desc = "Current buffer back" })
vim.keymap.set("n", "<S-l>", function() require("config.fn").buf.jump("next") end, { desc = "Current buffer forward" })
vim.keymap.set({ "n", "x" }, "gt", "<S-h>", { desc = "Go to the top of the screen" })
vim.keymap.set({ "n", "x" }, "gb", "<S-l>", { desc = "Go to the bottom of the screen" })
vim.keymap.set({ "n", "x" }, "gm", "<S-m>", { desc = "Go to the middle of the screen" })

vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Cursor to middle for Page Down" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Cursor to middle for Page Up" })

vim.keymap.set("n", "n", "nzzzv", { desc = "Cursor to middle for search next" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Cursor to middle for search previous" })

-- Swap ' and `
vim.keymap.set({ "n", "o" }, "'", "`", { desc = "Return to mark's line & column" })
vim.keymap.set({ "n", "o" }, "`", "'", { desc = "Return to mark's line" })

-- Swap gf and gF
vim.keymap.set("n", "gf", "gF", { desc = "Go to file & line" })
vim.keymap.set("n", "gF", "gf", { desc = "Go to file" })

-- Easy %
vim.keymap.set("n", "mm", "%", { desc = "Go to matching delimiter" })
vim.keymap.set({ "v", "o", "x" }, "m", "%", { desc = "Go to matching delimiter" })

vim.keymap.set("n", "j", function() return vim.v.count > 0 and "m'" .. vim.v.count .. "j" or "gj" end, { expr = true, desc = "Save <#>j to the jumplist" })
vim.keymap.set("n", "k", function() return vim.v.count > 0 and "m'" .. vim.v.count .. "k" or "gk" end, { expr = true, desc = "Save <#>k to the jumplist" })

vim.keymap.set("n", "ZK", "<cmd>qa!<CR>", { desc = "Quit all without saving" })
vim.keymap.set("n", "ZV", require("config.fn").buf.close_non_visible, { desc = "Quit All Except Visible | Breakpoint" })

----------------------------------------------------------------------------------------
---@endsection
---@section Tabs/Windows/Buffers
----------------------------------------------------------------------------------------
vim.keymap.set({ "n", "i" }, "<C-TAB>", ":tabnext<CR>", { silent = true, desc = "Next Tab" })
vim.keymap.set({ "n", "i" }, "<C-S-TAB>", ":tabprevious<CR>", { silent = true, desc = "Previous Tab" })
vim.keymap.set("n", "<leader><TAB>", "gt", { silent = true, desc = "Next Tab" })
vim.keymap.set("n", "<leader><S-TAB>", "gT", { silent = true, desc = "Previous Tab" })
vim.keymap.set("n", "<leader>c<TAB>", ":tabnew<CR>", { silent = true, desc = "New Tab" })
vim.keymap.set("n", "<leader>d<TAB>", ":tabclose<CR>", { silent = true, desc = "Close Tab" })

-- Change between buffers with >/<
vim.keymap.set("n", "<", ":bprevious<CR>", { silent = true, desc = "Shift to previous buffer" })
vim.keymap.set("n", ">", ":bnext<CR>", { silent = true, desc = "Shift to next buffer" })

-- Resize Splits with Arrows
vim.keymap.set({ "n", "i" }, "<C-Left>", function()
  vim.cmd("stopinsert")
  vim.cmd("vertical resize -2")
end, { desc = "Resize Window " })
vim.keymap.set({ "n", "i" }, "<C-Down>", function()
  vim.cmd("stopinsert")
  vim.cmd("resize -2")
end, { desc = "Resize Window " })
vim.keymap.set({ "n", "i" }, "<C-Up>", function()
  vim.cmd("stopinsert")
  vim.cmd("resize +2")
end, { desc = "Resize Window " })
vim.keymap.set({ "n", "i" }, "<C-Right>", function()
  vim.cmd("stopinsert")
  vim.cmd("vertical resize +2")
end, { desc = "Resize Window " })

-- Move Splits with Shift+Arrows
vim.keymap.set("n", "<S-Left>", "<C-w>R", { desc = "Rotate Windows " })
vim.keymap.set("n", "<S-Down>", "<C-w>r", { desc = "Rotate Windows " })
vim.keymap.set("n", "<S-Up>", "<C-w>R", { desc = "Rotate Windows " })
vim.keymap.set("n", "<S-Right>", "<C-w>r", { desc = "Rotate Windows " })

----------------------------------------------------------------------------------------
---@endsection
---@section Motions
----------------------------------------------------------------------------------------
vim.keymap.set("n", "]h", "]c", { desc = "Next Hunk" })
vim.keymap.set("n", "[h", "[c", { desc = "Previous Hunk" })
vim.keymap.set("n", "]q", ":cn<CR>", { silent = true, desc = "Next QuickFix Entry" })
vim.keymap.set("n", "[q", ":cp<CR>", { silent = true, desc = "Previous QuickFix Entry" })

----------------------------------------------------------------------------------------
---@endsection
---@section Yanks
----------------------------------------------------------------------------------------
vim.keymap.set("n", "yA", "gg0yG<C-o>", { desc = "Yank all" })

vim.keymap.set("n", "yF", function()
  local abspath = vim.api.nvim_buf_get_name(0)
  for _, reg in ipairs({ '"', "+", "*" }) do
    vim.fn.setreg(reg, abspath)
  end
end, { desc = "Yank File Path, Full" })

vim.keymap.set("n", "yR", function()
  local relpath = vim.fn.expand("%:.")
  for _, reg in ipairs({ '"', "+", "*" }) do
    vim.fn.setreg(reg, relpath)
  end
end, { desc = "Yank File Path, Relative" })

vim.keymap.set("n", "yN", function()
  local path = vim.fn.expand("%:.")
  local pos = require("config.fn").str.rfind_char(path, "/")
  if pos then path = path:sub(pos + 1) end
  for _, reg in ipairs({ '"', "+", "*" }) do
    vim.fn.setreg(reg, path)
  end
end, { desc = "Yank File Path, Basename" })

vim.keymap.set("n", "yI", function()
  local relpath = vim.fn.expand("%:.")
  local path, _ = string.gsub(relpath, "%..*", "")
  for _, reg in ipairs({ '"', "+", "*" }) do
    vim.fn.setreg(reg, path)
  end
end, { desc = "Yank Import Path" })

vim.keymap.set("n", "yB", function()
  local relpath = vim.fn.expand("%:.")
  local dirname = vim.fs.dirname(relpath)
  local pkg = "//" .. dirname .. ":"

  local line = vim.api.nvim_get_current_line()
  local match = line:match('"(.*)"') or "all"
  local target = pkg .. match

  for _, reg in ipairs({ '"', "+", "*" }) do
    vim.fn.setreg(reg, target)
  end
end, { desc = "Yank Bazel Target" })

vim.keymap.set({ "n", "x" }, "<leader>yg", function()
  local proc = vim.system({ "git", "rev-parse", "HEAD" }, { text = true }):wait()
  if proc.code ~= 0 then
    vim.notify("Could not get commit (code " .. proc.code .. "):\n" .. proc.stderr)
    return
  end
  local commit = vim.trim(proc.stdout or "")

  proc = vim.system({ "git", "remote", "get-url", "origin" }, { text = true }):wait()
  if proc.code ~= 0 then
    vim.notify("Could not deduce repository (code " .. proc.code .. "):\n" .. proc.stderr)
    return
  end

  local file_path = vim.fn.expand("%:.")
  local line_number = vim.fn.getpos("v")[2] -- {bufnum, lnum, col, off}
  local line_end = vim.fn.getpos("v")[2]

  local url = vim.trim(proc.stdout or "")
  url = string.gsub(url, "git@github%.com:", "https://gitub.com/")
  url = string.gsub(url, "%.git", "/blob/")
  url = url .. commit .. "/" .. file_path

  local mode = vim.api.nvim_get_mode().mode
  if mode == "v" or mode == "V" or mode == "\22" then
    url = url .. "#L" .. line_number
    if line_number ~= line_end then
      url = url .. "-L" .. line_end
    end
  end

  vim.notify(url)
  for _, reg in ipairs({ '"', "+", "*" }) do
    vim.fn.setreg(reg, url)
  end
end, { desc = "Yank Git(hub) link" })

----------------------------------------------------------------------------------------
---@endsection
---@section LSP
----------------------------------------------------------------------------------------
vim.keymap.set("i", "<F1>", vim.lsp.buf.signature_help, { desc = "Show Function Docstring" })
vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, { desc = "Rename" })
vim.keymap.set("n", "g.", vim.lsp.buf.code_action, { desc = "Code Action/Fix" })
vim.keymap.set("n", "gC", vim.lsp.buf.incoming_calls, { desc = "Callers" })

-- Text Objects
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

-- Diagnostics
vim.keymap.set("n", "<leader>hd", vim.diagnostic.open_float, { desc = "Hover Diagnostic" })
vim.keymap.set("n", "?", function()
  if require("dap").session() then
    require("dap.ui.widgets").hover()
  else
    vim.diagnostic.open_float()
  end
end, { desc = "Float Diagnostic / DAP" })

vim.keymap.set("n", "]e", function() vim.diagnostic.jump({ count = 1, float = true, severity = vim.diagnostic.severity.ERROR }) end, { desc = "Go to next error" })
vim.keymap.set("n", "[e", function() vim.diagnostic.jump({ count = 1, float = true, severity = vim.diagnostic.severity.ERROR }) end, { desc = "Go to previous error" })

----------------------------------------------------------------------------------------
---@endsection
---@section Lua
----------------------------------------------------------------------------------------
vim.keymap.set("n", "<leader>LL", ":lua =", { desc = ":lua =" })
vim.keymap.set("n", "<leader>LR", ':lua require("', { desc = ':lua require("' })
vim.keymap.set("n", "<leader>LF", ":lua =F.", { desc = ":lua F." })

----------------------------------------------------------------------------------------
---@endsection
---@section Custom
----------------------------------------------------------------------------------------
-- Whitespace manipulation
vim.keymap.set("n", "<leader>wt", [[:%s/\s\+$//e<CR>]], { silent = true, desc = "Whitespace Trip" })
vim.keymap.set("n", "<leader>wr", [[:%s/\r//<CR>]], { silent = true, desc = "Remove Windows Line Endings" })
vim.keymap.set({ "n", "v" }, "<leader>wq", [[:%s/'/"/g<CR>]], { silent = true, desc = "Rewrite quotes" })
vim.keymap.set({ "n", "v" }, "<leader>wn", ":s/\\\\n/\\r/g<CR>", { silent = true, desc = "Wrap on literal \\n" })
vim.keymap.set({ "n", "v" }, "<leader>wo", [[:s/\(\)/\1\r/g<left><left><left><left><left><left><left><left><left>]], { silent = true, desc = "Wrap on" })
vim.keymap.set("n", "<leader>wl", function()
  local pattern = vim.fn.getreg("/")
  vim.cmd([[:s/\s\+/\r/g]])
  vim.fn.setreg("/", pattern)
end, { desc = "Wrap words across lines" })

-- Word substitution
vim.keymap.set("n", "<leader><F2>", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { silent = true, desc = "Substitute word" })
vim.keymap.set("v", "<leader><F2>", function()
  vim.cmd('normal! "zy')
  local escaped = vim.fn.escape(vim.fn.getreg("z"), "\\/")
  local left = vim.api.nvim_replace_termcodes("<Left><Left>", true, false, true)
  vim.api.nvim_feedkeys(string.format([[:%%s/\V%s//g]], escaped) .. left, "n", true)
end, { desc = "Substitute visual selection" })

-- Plugins
vim.keymap.set("n", "__", require("config.fn").buf.close_widgets, { desc = "Close all widget windows" })
vim.keymap.set({ "n", "i" }, "<F7>", require("config.fn").util.build, { desc = "Build" })

----------------------------------------------------------------------------------------
---@endsection
----------------------------------------------------------------------------------------
