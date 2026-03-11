-- Commands
vim.api.nvim_create_user_command("Sort", function(opts)
  if opts.range == 0 then
    vim.cmd("sort i")
  else
    vim.cmd(string.format("'<,'> sort i", opts.line1, opts.line2))
  end
end, { range = true, desc="Sort, case insensitive (sort i)" })
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
  desc = "Enable TreeSitter Folds",
  pattern = { "*" },
  callback = function()
    -- For some reason, this breaks snacks_input a little bit
    if vim.bo.filetype ~= "snacks_input" then
      vim.cmd("normal zx") -- zR
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
vim.api.nvim_create_autocmd({ "FileType" }, {
  desc = "gd support for vim help",
  pattern = { "help" },
  callback = function()
    vim.keymap.set("n", "gd", "<C-]>", { buffer = true, noremap = true, desc = "Go to help tag" })
  end,
})
vim.api.nvim_create_autocmd({ "FileType" }, {
  desc = "Go to file from output window",
  pattern = { "*output*", "*Output*" },
  callback = function()
    vim.keymap.set("n", "gf", function()
      local window = require("snacks").picker.util.pick_win({
        filter = function(win, buf)
          return not vim.bo[buf].filetype:find("^snacks") and
                 not vim.bo[buf].filetype:find("Overseer") and
                 not vim.bo[buf].filetype:find("neotest") and
                 not vim.bo[buf].filetype:find("trouble")
        end
      })
      local loc = require("config.fn").buf.file_under_cursor()
      if vim.api.nvim_win_is_valid(window) and vim.fn.filereadable(loc.file) == 1 then
        vim.api.nvim_set_current_win(window)
        vim.cmd.edit(loc.file)
        if loc.line then
          vim.api.nvim_win_set_cursor(0, { loc.line, (loc.col or 1) - 1 })
          vim.cmd("normal! zz")
        end
      end
    end, { buffer = true, noremap = true, })
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
