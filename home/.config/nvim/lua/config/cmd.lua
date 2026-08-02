---@module "User-defined commands"

vim.api.nvim_create_user_command("E", function(opts) vim.cmd("e " .. vim.fn.expand("%:p:h") .. "/" .. opts.args) end, {
  desc = "Edit a file relative to the current one",
  nargs = "+",
  ---Auto-complete relative file paths
  ---@param arglead string Text entered by the user so far
  ---@param _line string Full EX command line
  ---@param _cursor integer Cursor position
  ---@return string[] Suggestions list
  complete = function(arglead, _line, _cursor)
    local dir = vim.fn.expand("%:p:h")
    ---@type string[]
    local matches = vim.fn.glob(dir .. "/" .. arglead .. "*", false, true)
    return vim.tbl_map(function(m)
      local rel = m:sub(#dir + 2) -- strip "dir/" prefix → relative path
      if vim.fn.isdirectory(m) == 1 then
        rel = rel .. "/" -- append / to dirs so you can keep tabbing into them
      end
      return rel
    end, matches)
  end,
})

vim.api.nvim_create_user_command("Reverse", function(opts) vim.cmd(string.format("%d,%d!tac", opts.line1, opts.line2)) end, { range = true, desc = "Reverse lines" })

vim.api.nvim_create_user_command("Sort", function(opts)
  if opts.range ~= 2 then
    vim.cmd("sort i")
  else
    vim.cmd(string.format("%d,%d sort i", opts.line1, opts.line2))
  end
end, { range = true, desc = "Sort, case insensitive (sort i)" })

vim.api.nvim_create_user_command("ISort", function(opts)
  local range = (opts.count ~= -1) and vim.lsp.util.make_range_params(0, "utf-8") or nil
  ---@diagnostic disable-next-line: param-type-mismatch
  vim.lsp.buf.code_action({
    range = range,
    apply = true,
    context = {
      triggerKind = vim.lsp.protocol.CodeActionTriggerKind.Invoked,
      diagnostics = vim.diagnostic.get(0, { lnum = vim.api.nvim_win_get_cursor(0)[1] - 1 }),
      only = { "source.organizeImports" },
    },
  })
end, { desc = "Sort Imports / Includes", range = true })

vim.api.nvim_create_user_command("LspInfo", function()
  vim.print(vim.tbl_map(function(client) return client.name end, vim.lsp.get_clients({ bufnr = 0 })))
end, { desc = "Show LSP for current bufffer" })

vim.api.nvim_create_user_command(
  "Mkspell",
  function(_opts) vim.cmd("mkspell! ~/.local/share/nvim/site/spell/en.utf-8.add.spl ~/.local/share/nvim/site/spell/en.utf-8.add") end,
  { desc = "Rebuild spell index" }
)

vim.api.nvim_create_user_command("TSExplore", function() vim.cmd("InspectTree") end, { desc = "Show Parse Tree" })
vim.api.nvim_create_user_command("Vh", "vertical help<CR>", { desc = "Vertical Help" })
vim.api.nvim_create_user_command("QAEV", require("config.fn").buf.close_non_visible, { desc = "Quit All Except Visible | Breakpoint" })
