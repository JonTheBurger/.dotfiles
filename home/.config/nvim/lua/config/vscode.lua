if not not vim.g.vscode then
  local vscode = require("vscode")
  vim.notify = vscode.notify

  -- Functions
  local zz = function()
    -- vim.cmd(":norm! *")
    local curline = vim.fn.line(".")
    vscode.call("revealLine", { args = {lineNumber = curline, at = "center"} })
  end

  -- Cursor to Middle for Search Next/Previous
  vim.keymap.set("n", "*", function()
    vim.cmd(":silent! :norm! *")
    zz()
  end, { noremap = true, silent = true })
  vim.keymap.set("n", "n", function()
    vim.cmd(":silent! norm! n")
    zz()
  end, { noremap = true, silent = true })
  vim.keymap.set("n", "N", function()
    vim.cmd(":silent! norm! N")
    zz()
  end, { noremap = true, silent = true })

  -- Undo/Redo
  vim.keymap.set("n", "u", function() vscode.call("undo") end)
  vim.keymap.set("n", "<C-r>", function() vscode.call("redo") end)

  -- Move Splits with Shift+Arrows
  vim.keymap.set("n", "<C-l>", function() vscode.action("workbench.action.focusRightGroup") end)
  vim.keymap.set("n", "<C-h>", function() vscode.action("workbench.action.focusLeftGroup") end)
  vim.keymap.set("n", "<C-k>", function() vscode.action("workbench.action.focusAboveGroup") end)
  vim.keymap.set("n", "<C-j>", function() vscode.action("workbench.action.focusBelowGroup") end)

  -- Close Buffers
  vim.keymap.set("n", "<leader>q", function() vscode.action("workbench.action.closeActiveEditor") end)
  vim.api.nvim_create_user_command("QAEV", function()
    vscode.action("workbench.action.closeOtherEditors")
    -- vscode.action("workbench.action.closeEditorsInOtherGroups")
  end, {})

  vim.api.nvim_create_user_command("A", function()
    -- vscode.action("C_Cpp.SwitchHeaderSource")
    vscode.action("clangd.switchheadersource")
  end, {})

  -- Shift Through Buffers
  vim.keymap.set("n", ">", function() vscode.action("workbench.action.nextEditor") end)
  vim.keymap.set("n", "<", function() vscode.action("workbench.action.previousEditor") end)

  -- Diagnostics
  vim.keymap.set("n", "]d", function() vscode.action("editor.action.marker.next") end)
  vim.keymap.set("n", "[d", function() vscode.action("editor.action.marker.prev") end)

  -- Side Bar
  vim.keymap.set("n", "<leader>e", function() vscode.action("workbench.view.explorer") end)
  vim.keymap.set("n", "<ESC>", function() vscode.action("workbench.action.closeSidebar") end)

  -- Tests
  vim.keymap.set("n", "<leader>t", function() vscode.action("workbench.view.extension.test") end)
  vim.keymap.set("n", "<leader>tt", function() vscode.action("testing.runAtCursor") end)
  vim.keymap.set("n", "<leader>td", function() vscode.action("testing.debugAtCursor") end)
  vim.keymap.set("n", "<leader>tf", function() vscode.action("testing.runCurrentFile") end)
end