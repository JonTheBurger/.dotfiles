-- Wiki
local edit_file = require("config.fn").edit_file
local WIKI = vim.fn.expand("~/Documents/wiki")
local DIARY = vim.fn.expand(WIKI .. "/diary")
local MONTH_NAME = { "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" }
local TEMPLATE = [[
## Tasks

- [ ] Todo

## Notes

]]

vim.keymap.set("n", "<leader>wn", function()
  edit_file(WIKI .. "/index.md")
end, { desc = "Open Wiki Notes" })

vim.keymap.set("n", "<leader>ww", function()
  edit_file(WIKI .. "/index.md", { chdir = true })
end, { desc = "Open Wiki Index" })

vim.keymap.set("n", "<leader>wk", function()
  edit_file(DIARY .. os.date("/%Y/%m/w%U.md"), { initial_contents = os.date("# %Y-%m: Week %U\n\n") .. TEMPLATE })
end, { desc = "Open Weekly Notes" })

vim.keymap.set("n", "<leader>wi", function()
  local Path = require("plenary.path")
  local scan = require("plenary.scandir")
  local fn = require("config.fn")

  local path = Path:new(DIARY)
  if not path:exists() or not path:is_dir() then
    return
  end

  path = path / "index.md"
  path:write("", "w")

  local years = scan.scan_dir(tostring(DIARY), { depth = 1, only_dirs = true })
  for _, year in ipairs(fn.identity(years)) do
    path:write("# " .. fn.basename(year) .. "\n\n", "a")

    local months = scan.scan_dir(tostring(year), { depth = 1, only_dirs = true })
    for _, month_dir in ipairs(fn.identity(months)) do
      local month_idx = fn.basename(month_dir)
      path:write("## " .. month_idx .. " - " .. MONTH_NAME[tonumber(month_idx)] .. "\n\n", "a")

      local weeks = scan.scan_dir(tostring(month_dir), { depth = 1 })
      for _, week_file in ipairs(fn.identity(weeks)) do
        local relative = fn.remove_prefix(week_file, DIARY)
        local week = fn.remove_suffix(fn.basename(week_file), ".md")
        path:write("- [" .. week .. "](." .. relative .. ")\n", "a")
      end

      path:write("\n", "a")
    end
  end

  vim.notify("Updated " .. path .. "!")
end, { desc = "Update Diary Index" })
