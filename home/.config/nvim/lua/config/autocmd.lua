-- Commands
vim.api.nvim_create_user_command("Sort", function(opts)
  if opts.range == 0 then
    vim.cmd("sort i")
  else
    vim.cmd(string.format("'<,'> sort i", opts.line1, opts.line2))
  end
end, { range = true, desc="Sort, case insensitive (sort i)" })
vim.api.nvim_create_user_command("Mkspell", function(opts)
  vim.cmd("mkspell! ~/.local/share/nvim/site/spell/en.utf-8.add.spl ~/.local/share/nvim/site/spell/en.utf-8.add")
end, { desc="Rebuild spell index" })
-- vim.api.nvim_create_user_command("Sort", "sort i", { range = true, desc="Sort, case insensitive (sort i)" })
vim.api.nvim_create_user_command("Colorize", function()
  Snacks.terminal.colorize()
  vim.wo.number = true
  vim.wo.relativenumber = true
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
vim.api.nvim_create_user_command("Reverse", function(opts)
  vim.cmd(string.format("%d,%d!tac", opts.line1, opts.line2))
end, { range = true })
vim.api.nvim_create_user_command("LspInfo", function()
  vim.print(vim.tbl_map(function(client)
    return client.name
  end, vim.lsp.get_clients({ bufnr = 0 })))
end, { desc = "Show LSP for current bufffer" })

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
  desc = "Enable TreeSitter Highlights",
  pattern = {
    "bash",
    "c",
    "cpp",
    "lua",
    "markdown",
    "python",
    "rust",
 },
  callback = function()
    vim.treesitter.start()
  end,
})
vim.api.nvim_create_autocmd({ "BufReadPost", "FileType" }, {
  desc = "Expand Folds",
  pattern = { "nvim-undotree" },
  callback = function()
    vim.cmd("normal zR") -- zx
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
vim.api.nvim_create_autocmd({ "FileType" }, {
  desc = "gd support for vim help",
  pattern = { "help" },
  callback = function()
    vim.keymap.set("n", "gd", "<C-]>", { buffer = true, noremap = true, desc = "Go to help tag" })
  end,
})
vim.api.nvim_create_autocmd({ "FileType" }, {
  desc = "Go to file from output window",
  pattern = { "*output*", "*Output*", "" },
  callback = function()
    vim.keymap.set("n", "gf", function()
      require("config.fn").buf.gf()
    end, { buffer = true, noremap = true, desc = "Go to file, pick split" })
  end,
})
vim.api.nvim_create_autocmd({ "TermOpen" }, {
  pattern = "*",
  callback = function(ev)
    local opts = { buffer = ev.buf, noremap = true, silent = true }
    vim.keymap.set("n", "gf", function() require("config.fn").buf.gf() end, opts)
    vim.keymap.set("n", "]d", function() require("config.fn").buf.jump_to_diagnostic("next") end, opts)
    vim.keymap.set("n", "[d", function() require("config.fn").buf.jump_to_diagnostic("prev") end, opts)
  end,
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
    -- require("config.fn").toggle_hex()
  end,
})
vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
  desc = "Dump archives",
  pattern = { "*.a" },
  callback = function()
    vim.cmd([[:%! ar -t ]] .. vim.fn.expand("%:p"))
  end,
})
