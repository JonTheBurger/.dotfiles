local M = {}

---@class Breakpoint
---@field line integer Line number
---@field condition? string An optional condition to trigger the breakpoint
---@field hit_condition? string
---@field log_message? string

---@class Breakpoints
---@field [string] Breakpoint[] A table mapping file paths to arrays of breakpoints.

---Returns the input
---@param i any
---@return any
M.identity = function(i)
  return i
end

---Reverses a list, in-place.
---@param list List The list to reverse.
---@return List The list passed in.
M.reverse = function(list)
  local len = #list
  for i = 1, math.floor(len / 2) do
    list[i], list[len - i + 1] = list[len - i + 1], list[i]
  end
  return list
end

---Returns a copy of a list, reversed.
---@param list List The list to reverse.
---@return List A newly reversed list.
M.reversed = function(list)
  local reversed = {}
  for i = #list, 1, -1 do
    table.insert(reversed, list[i])
  end
  return reversed
end

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
---@param prefix string
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
  return str:sub(-#suffix) == suffix
end

---@param str string
---@return string
M.remove_suffix = function(str, suffix)
  if M.ends_with(str, suffix) then
    return str:sub(1, #str - #suffix)
  end
  return str
end

--- Finds the index of an ascii character in a string
---@param str string to search
---@param char string character to search for
---@param idx? integer start index; defaults to 1
---@return integer? index of char, or nil if not found
function M.find_char(str, char, idx)
  local ascii = char:byte(1)
  idx = idx or 1
  for i = idx, #str, 1 do
    if str:byte(i) == ascii then
      return i
    end
  end
  return nil
end

--- Finds the index of an ascii character in a string, backwards
---@param str string to search
---@param char string character to search for
---@param idx? integer start index; defaults to end of string
---@return integer? index of char, or nil if not found
function M.rfind_char(str, char, idx)
  local ascii = char:byte(1)
  idx = idx or #str
  for i = idx, 1, -1 do
    if str:byte(i) == ascii then
      return i
    end
  end
  return nil
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
---file name, such as for stdpath("data") .. "/sessions"
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
  local rep = vim.fn.stdpath("data") .. "/sessions/" .. M.dir_as_fname() .. ext
  local path = Path:new(rep)
  path:parent():mkdir({ parents = true, exists_ok = true })
  return Path:new(path)
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

M.buffer_quit_all_except_visible = function(_)
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
---@field chdir boolean? Also change to the directory
---@field initial_contents string? Initial contents of file, if it did not exist
M.edit_file = function(filename, opts)
  local Path = require("plenary.path")
  local path = Path:new(vim.fn.expand(filename))
  path:parent():mkdir({ parents = true, exists_ok = true }) -- path:touch() doesn't work

  if not path:exists() then
    if opts ~= nil and opts.initial_contents ~= nil then
      path:write(opts.initial_contents, "w")
    end
  end

  if opts ~= nil and opts.chdir then
    vim.api.nvim_set_current_dir(tostring(path:parent()))
  end

  vim.cmd("edit " .. tostring(path))
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

  return vim.fn.input("Path to executable: ", exe, "file")
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
  local cmake = require("cmake-tools")
  local targets = cmake.get_launch_targets()

  if targets == nil or targets.data == nil then
    vim.notify("You must configure cmake first!", vim.log.levels.ERROR)
    return
  end

  vim.ui.select(targets.data.abs_paths, {
    prompt = "Pick a target:",
    format_item = function(item)
      return M.basename(item)
    end,
  }, function(choice)
    M.dap_executable = choice
    require("dap").continue()
  end)
end

M.unwanted_buf_del = function()
  local x_buftype = {
    "nofile",
    "prompt",
    "terminal",
  }
  local x_filetype = {
    "neotest-summary",
    "snacks_picker_input",
    "trouble",
    "snacks_picker_list",
    "undotree",
  }
  local try_close = function(buffer)
    local winid = vim.fn.bufwinid(buffer.bufnr)
    if vim.api.nvim_win_is_valid(winid) then
      vim.api.nvim_win_close(winid, true)
    end
    if vim.api.nvim_buf_is_valid(buffer.bufnr) then
      vim.api.nvim_buf_delete(buffer.bufnr, { force = true })
    end
  end

  local buffers = vim.fn.getbufinfo()
  for _, buffer in ipairs(buffers) do
    if not vim.api.nvim_buf_is_valid(buffer.bufnr) then
      goto continue
    end

    local ftype = vim.api.nvim_get_option_value("filetype", { buf = buffer.bufnr })
    if M.contains(x_filetype, ftype) then
      try_close(buffer)
      goto continue
    end

    local btype = vim.api.nvim_get_option_value("buftype", { buf = buffer.bufnr })
    if M.contains(x_buftype, btype) then
      try_close(buffer)
      goto continue
    end

    ::continue::
  end
end

M.bkpt_clear = function()
  require("dap").clear_breakpoints()
end

---Gets currently set breakpoints
---@return Breakpoints
M.bkpt_get = function()
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

M.bkpt_save = function()
  local bkpts = M.bkpt_get()
  local json = require("config.fn").session_file(".bkpt.json")
  json:write(vim.fn.json_encode(bkpts), "w")
end

M.bkpt_load = function()
  local dap_bkpt = require("dap.breakpoints")
  local json = require("config.fn").session_file(".bkpt.json")

  -- Load breakpoints from disk
  local data = nil
  if json:exists() then
    data = vim.fn.json_decode(json:read())
  end
  if data == nil then
    return
  end

  -- Iterate through all buffers
  for _, buffer in ipairs(vim.fn.getbufinfo()) do
    -- If the given filename has breakpoints
    local breakpoints = data[vim.api.nvim_buf_get_name(buffer.bufnr)]
    if breakpoints ~= nil then
      for _, breakpoint in ipairs(breakpoints) do
        -- And the line number is valid
        if breakpoint.line <= vim.api.nvim_buf_line_count(buffer.bufnr) then
          -- Set a breakpoint
          dap_bkpt.set({
            condition = breakpoint.condition,
            hit_condition = breakpoint.hit_condition,
            log_message = breakpoint.log_message,
          }, buffer.bufnr, breakpoint.line)
        end
      end
    end
  end
end

---Selects inside of or around an ascii character within  a line. Kind of works.
---@param char string ASCII character
---@param grab ("i"|"a") Grab Inside or Around
function M.select_motion_char(char, grab)
  local text = vim.api.nvim_get_current_line()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  col = col + 1 -- Cursor columns are zero-indexed, lua strings are 1

  local next = M.find_char(text, char, col + 1)
  if next == nil then
    return
  end

  local prev = M.rfind_char(text, char, col - 1)
  if prev == nil then
    prev = next
    next = M.find_char(text, char, prev + 1)
  end

  if grab == "i" then
    next = next - 1
  elseif grab == "a" then
    prev = prev - 1
  end

  if next ~= nil then
    vim.api.nvim_win_set_cursor(0, { line, prev })
    vim.cmd("normal! v")
    vim.api.nvim_win_set_cursor(0, { line, next - 1 })
  end
end

function M.use_wsl_clip()
  if vim.fn.has("wsl") == 1 then
    -- sudo ln -s /mnt/c/Program\ Files/Neovim/bin/win32yank.exe /usr/local/bin/win32yank
    local win32yank = "win32yank"
    local clip_exe = "/mnt/c/Windows/System32/clip.exe"
    local powershell = "/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe"

    if vim.fn.executable(win32yank) ~= 0 then
      vim.g.clipboard = {
        name = "win32yank-wsl",
        copy = {
          ["+"] = win32yank .. " -i --crlf",
          ["*"] = win32yank .. " -i --crlf",
        },
        paste = {
          ["+"] = win32yank .. " -o --lf",
          ["*"] = win32yank .. " -o --lf",
        },
        cache_enabled = false,
      }
    elseif vim.fn.executable(clip_exe) and vim.fn.executable(powershell) then
      vim.g.clipboard = {
        name = "clip-windows",
        copy = {
          ["+"] = clip_exe,
          ["*"] = clip_exe,
        },
        paste = {
          ["+"] = powershell .. " -noprofile -command Get-Clipboard",
          ["*"] = powershell .. " -noprofile -command Get-Clipboard",
        },
        cache_enabled = false,
      }
    end
  end
end

---@param extension string
---@param binary string
M.find_vscode_binary = function(extension, binary)
  local Path = require("plenary.path")
  local scan = require("plenary.scandir")
  extension = string.gsub(extension or "ms-vscode.cpptools", "%-", "[-]") -- Escape "-", which has special meaning in lua
  binary = binary or string.gsub("OpenDebugAD7", "%-", "[-]")

  local paths = {
    Path:new(vim.fn.expand("~/.vscode/extensions")),
    Path:new(vim.fn.expand("~/.vscode-server/extensions")),
  }

  while #paths > 0 do
    local extensions = table.remove(paths, 1)
    if extensions:is_dir() then
      local dirs = scan.scan_dir(tostring(extensions), { depth = 1, only_dirs = true, search_pattern = extension })
      if #dirs > 0 then
        local dir = dirs[#dirs] -- get last alphabetically
        local exe = scan.scan_dir(tostring(dir), { search_pattern = binary })
        if #exe > 0 then
          return exe[1]
        end
      end
    end
  end

  -- Give up and hope it's on $PATH
  return binary
end

return M
