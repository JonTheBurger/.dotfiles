-- Commands
vim.api.nvim_create_user_command("Colorize", function()
  Snacks.terminal.colorize()
end, {})
vim.api.nvim_create_user_command("AnimateOn", function()
  vim.g.snacks_animate = true
  require("smear_cursor").enabled = true
  vim.notify("Animations On")
end, {})
vim.api.nvim_create_user_command("AnimateOff", function()
  vim.g.snacks_animate = false
  require("smear_cursor").enabled = false
  vim.notify("Animations Off")
end, {})

-- AutoCommands
vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  desc = "Highlight when yanking (copying) text",
  callback = function()
    vim.highlight.on_yank()
  end,
})
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Yank Ring",
  callback = function()
    local event = vim.v.event
    if event.operator == "y" then
      -- Shift numbered registers up (1 becomes 2, etc.)
      for i = 9, 1, -1 do
        vim.fn.setreg(tostring(i), vim.fn.getreg(tostring(i - 1)))
      end
    end
  end,
})
vim.api.nvim_create_autocmd({ "BufReadPost", "FileType" }, {
  desc = "Enable TreeSitter Folds",
  pattern = { "*" },
  callback = function()
    -- For some reason, this breaks snacks_input a little bit
    if vim.bo.filetype ~= "snacks_input" then
      vim.cmd("normal zx")  -- zR
    end
  end,
})
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
  desc = "Lint Files",
  callback = function()
    require("lint").try_lint()
  end,
})
vim.api.nvim_create_autocmd({ "FileType" }, {
  desc = "Support Makefile Tabs",
  pattern = { "make" },
  command = "setlocal noexpandtab",
})
vim.api.nvim_create_autocmd({ "WinNew", "WinLeave", "BufWinEnter" }, {
  desc = "Keep Widgets out of BufferLine",
  pattern = { "*DAP*", "*dap*", "Neotest *" },
  callback = function(args)
    vim.api.nvim_set_option_value("buflisted", false, { buf = args.buf })
  end,
})
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  desc = "Keep unnamed buffers out of BufferLine",
  pattern = { "*" },
  callback = function(args)
    if args.file == "" then
      vim.api.nvim_set_option_value("buflisted", false, { buf = args.buf })
    end
  end,
})
vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
  desc = "Dump hex",
  pattern = { "*.bin" },
  callback = function()
    require("config.fn").toggle_hex()
  end,
})
vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
  desc = "Dump archives",
  pattern = { "*.a" },
  callback = function()
    vim.cmd([[:%! ar -t ]] .. vim.fn.expand("%:p"))
  end,
})
