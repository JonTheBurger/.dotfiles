local M = {}

---@return boolean
M.contains = function(list, value)
  for _, element in ipairs(list) do
    if element == value then
      return true
    end
  end
  return false
end

---@param str string
---@return boolean
M.starts_with = function(str, prefix)
  return str:sub(1, #prefix) == prefix
end

---@param str string
---@return string
M.remove_prefix = function(str, prefix)
  if M.starts_with(str, prefix) then
    return str:sub(1 + #prefix, #str)
  end
  return str
end

---@param str string
---@return boolean
M.ends_with = function(str, suffix)
  return str:sub(- #suffix) == suffix
end

---@param str string
---@return string
M.remove_suffix = function(str, suffix)
  if M.ends_with(str, suffix) then
    return str:sub(1, #str - #suffix)
  end
  return str
end

---@param path Path|string
---@return string
M.basename = function(path)
  return tostring(path):match("[/\\]([^/\\]*)$")
end

---Removes all extensions
---@param path Path|string
---@return string
M.remove_ext = function(path)
  return M.basename(path):match("[^.]*")
end

---Returns a string representation of the current dir that can be used as a
---file name, such as for stdpath("data") .. "/session"
---@param rep string? Directory to convert, cwd by default
---@return string
M.dir_as_fname = function(rep)
  if rep == nil then
    rep = vim.fn.getcwd()
  end
  local home = vim.fn.expand("~")
  if M.starts_with(rep, home) then
    rep = "@" .. M.remove_prefix(rep, home)
  end
  rep, _ = rep:gsub("[/\\:]", "%%")
  return rep
end

---@param ext string? File suffix, .json by default
---@return Path
M.session_file = function(ext)
  if ext == nil then
    ext = ".json"
  end
  local Path = require("plenary.path")
  local rep = vim.fn.stdpath("data") .. "/session/" .. M.dir_as_fname() .. ext
  return Path:new(rep)
end

---@param strings string[]
---@param by string
---@return string
M.str_join = function(strings, by)
  local t = {}
  for _, v in ipairs(strings) do
    t[#t + 1] = tostring(v)
  end
  return table.concat(t, by)
end

---@param filename string Name of file
---@param content string Contents of the file
M.write_to_file = function(filename, content)
  local fd = vim.loop.fs_open(filename, "w", 438) -- 438 is the octal for 0666 permissions
  if not fd then
    vim.notify("Failed to open file: " .. filename, vim.log.levels.ERROR)
    return
  end
  vim.loop.fs_write(fd, content, -1)
  vim.loop.fs_close(fd)
end

M.buffer_quit_all_except_visible = function(opts)
  local buffers = vim.fn.getbufinfo({ buflisted = 1 })
  for _, buffer in ipairs(buffers) do
    local is_visible = vim.fn.bufwinnr(buffer.bufnr) > 0
    if not is_visible then
      if buffer ~= vim.api.nvim_get_current_buf() then
        vim.api.nvim_buf_delete(buffer.bufnr, { force = true })
      end
    end
  end
end

M.toggle_hex = function()
  -- Save modified, readonly, and modifiable states
  local modified = vim.bo.modified
  local old_readonly = vim.bo.readonly
  local old_modifiable = vim.bo.modifiable

  -- Temporarily make buffer modifiable
  vim.bo.readonly = false
  vim.bo.modifiable = true

  if not vim.b.edit_hex then
    -- Save old options
    vim.b.old_ft = vim.bo.filetype
    vim.b.old_bin = vim.bo.binary

    -- Set new options
    vim.bo.binary = true
    vim.cmd("silent edit") -- Reload the file
    vim.bo.filetype = "xxd"

    -- Set status
    vim.b.edit_hex = true

    -- Switch to hex editor
    vim.cmd("%!xxd")
  else
    -- Restore old options
    vim.bo.filetype = vim.b.old_ft
    if not vim.b.old_bin then
      vim.bo.binary = false
    end

    -- Set status
    vim.b.edit_hex = false

    -- Return to normal editing
    vim.cmd("%!xxd -r")
  end

  -- Restore modified, readonly, and modifiable states
  vim.bo.modified = modified
  vim.bo.readonly = old_readonly
  vim.bo.modifiable = old_modifiable
end

---@param filename string Name of file
---@param opts table? Options
---@class edit_file_opts
---@field cd boolean Also change to the directory
M.edit_file = function(filename, opts)
  local Path = require("plenary.path")
  local path = Path:new(vim.fn.expand(filename))
  path:parent():mkdir({ parents = true, exists_ok = true }) -- path:touch() doesn't work

  if opts ~= nil and opts.cd then
    vim.api.nvim_set_current_dir(tostring(path:parent()))
  end

  vim.cmd("edit " .. tostring(path))
end

---@param diary string Directory containing diary index.md
M.update_diary_index = function(diary)
  diary = vim.fn.expand(diary)
  local Path = require("plenary.path")
  local scan = require("plenary.scandir")

  local path = Path:new(diary)
  if not path:exists() or not path:is_dir() then
    return
  end

  local files = scan.scan_dir(tostring(path), { depth = 1, search_pattern = ".*%d+-%d+-%d+.md" })
  path = path / "index.md"
  path:write("", "w")

  for _, value in ipairs(files) do
    local name = M.basename(Path:new(value))
    value = M.remove_suffix(name, ".md")
    path:write("- [" .. value .. "](./" .. name .. ")\n", "a")
  end

  vim.notify("Updated " .. path .. "!")
end

M.find_rust_executable = function()
  if vim.fn.filereadable("Cargo.toml") then
    return vim.fn.getcwd() .. "/target/debug/" .. M.basename(vim.fn.getcwd())
  end
  return vim.fn.getcwd()
end

M.find_cxx_executable = function()
  local exe = M.dap_executable
  M.dap_executable = nil
  if exe ~= nil then
    return exe
  end

  local fname = vim.api.nvim_buf_get_name(0)
  exe = vim.fn.getcwd() .. "/build/bin/" .. M.remove_ext(fname)

  local cmake = require("cmake-tools")
  local tgt = cmake.get_launch_target_path()
  if tgt ~= nil then
    exe = tostring(tgt)
  end

  return vim.fn.input(
    "Path to executable: ",
    exe,
    "file"
  )
end

M.find_python = function()
  local cwd = vim.fn.getcwd()
  if os.getenv("VIRTUAL_ENV") then
    return os.getenv("VIRTUAL_ENV") .. "/bin/python"
  elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
    return cwd .. "/.venv/bin/python"
  else
    return "python"
  end
end

M.dap_executable = nil
M.debug_cmake_executable = function()
  local dap = require("dap")
  local cmake = require("cmake-tools")

  vim.ui.select(cmake.get_launch_targets().data.abs_paths, {
    prompt = "Pick a target:",
    format_item = function(item) return M.basename(item) end,
  }, function(choice)
    M.dap_executable = choice
    dap.continue()
  end)
end

M.unwanted_buf_del = function()
  local x_buftype = {
    "nofile",
    "prompt",
  }
  local x_filetype = {
    "snacks_picker_list",
    "snacks_picker_input",
    "neotest-summary",
  }
  -- TODO: Save Widgets
  -- TODO: Close Windows
  local try_close = function(buffer)
    local winid = vim.fn.bufwinid(buffer.bufnr)
    if winid ~= -1 then
      vim.api.nvim_win_close(winid, true)
    end
    vim.api.nvim_buf_delete(buffer.bufnr, { force = true })
  end

  local buffers = vim.fn.getbufinfo()
  for _, buffer in ipairs(buffers) do
    local ftype = vim.api.nvim_buf_get_option(buffer.bufnr, "filetype")
    if M.contains(x_filetype, ftype) then
      try_close(buffer)
      goto continue
    end

    local btype = vim.api.nvim_buf_get_option(buffer.bufnr, "buftype")
    if M.contains(x_buftype, btype) then
      try_close(buffer)
      goto continue
    end

    ::continue::
  end
end

M.get_bkpts = function()
  local bkpts = {}
  local buffers = require("dap.breakpoints").get()
  if buffers ~= nil then
    for bufnr, lines in pairs(buffers) do
      local name = vim.api.nvim_buf_get_name(bufnr)
      bkpts[name] = lines
    end
  end
  return bkpts
end

return M
