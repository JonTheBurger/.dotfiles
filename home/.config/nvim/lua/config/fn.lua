---@diagnostic disable: duplicate-doc-field
local M = {}

----------------------------------------------------------------------------------------
---@section Types
----------------------------------------------------------------------------------------

---@class Breakpoint
---@field line integer Line number
---@field condition? string An optional condition to trigger the breakpoint
---@field hit_condition? string Number of hits a breakpoint must hit before activating
---@field log_message? string Message to log when hit

---@class Breakpoints
---@field [string] Breakpoint[] A table mapping file paths to arrays of breakpoints.

----------------------------------------------------------------------------------------
---@endsection
----------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------
---@section Globals
----------------------------------------------------------------------------------------

M.gbl = {

  ---@type string? Path to the most recently selected debug executable
  dap_executable = nil,

}

----------------------------------------------------------------------------------------
---@endsection
----------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------
---@section List
----------------------------------------------------------------------------------------

M.lst = {

  ---Reverses a list, in-place.
  ---@param list List The list to reverse.
  ---@return List The list passed in.
  reverse = function(list)
    local len = #list
    for i = 1, math.floor(len / 2) do
      list[i], list[len - i + 1] = list[len - i + 1], list[i]
    end
    return list
  end,

  ---Returns a copy of a list, reversed.
  ---@param list List The list to reverse.
  ---@return List A newly reversed list.
  reversed = function(list)
    local reversed = {}
    for i = #list, 1, -1 do
      table.insert(reversed, list[i])
    end
    return reversed
  end,

  ---Finds the first occurrence of a value in a list.
  ---@generic T
  ---@param list T[] List to search
  ---@param value T Value to find
  ---@return integer? Index of matching value, else nil if no match was found
  find = function(list, value)
    for i, element in ipairs(list) do
      if element == value then
        return i
      end
    end
    return nil
  end,

  ---Moves an element matching value to the front of the list. Only moves 1 value.
  ---@generic T
  ---@param list T[] List to reorder
  ---@param value T Value to move to the front
  ---@return boolean True if a value was moved, false otherwise.
  to_front = function(list, value)
    for i, e in ipairs(list) do
      if e == value then
        table.remove(list, i)
        table.insert(list, 1, e)
        return true
      end
    end
    return false
  end,

}

----------------------------------------------------------------------------------------
---@endsection
----------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------
---@section String
----------------------------------------------------------------------------------------

M.str = {

  ---Checks if a string starts with a given prefix
  ---@param str string String to check
  ---@return boolean True if the string begins with the prefix, else false
  starts_with = function(str, prefix)
    return str:sub(1, #prefix) == prefix
  end,

  ---Removes a prefix from a string, if it starts with that prefix
  ---@param str string String to remove prefix from
  ---@param prefix string Prefix to remove
  ---@return string String with prefix removed
  remove_prefix = function(str, prefix)
    if M.str.starts_with(str, prefix) then
      return str:sub(1 + #prefix, #str)
    end
    return str
  end,

  ---Checks if a string starts with a given prefix
  ---@param str string String to check
  ---@return boolean True if the string ends with the suffix, else false
  ends_with = function(str, suffix)
    return str:sub(-#suffix) == suffix
  end,

  ---Removes a suffix from a string, if it ends with that suffix
  ---@param str string String to remove suffix from
  ---@param suffix string Suffix to remove
  ---@return string String with suffix removed
  remove_suffix = function(str, suffix)
    if M.str.ends_with(str, suffix) then
      return str:sub(1, #str - #suffix)
    end
    return str
  end,

  --- Finds the index of an ascii character in a string
  ---@param str string to search
  ---@param char string character to search for
  ---@param idx? integer start index; defaults to 1
  ---@return integer? index of char, or nil if not found
  find_char = function (str, char, idx)
    local ascii = char:byte(1)
    idx = idx or 1
    for i = idx, #str, 1 do
      if str:byte(i) == ascii then
        return i
      end
    end
    return nil
  end,

  --- Finds the index of an ascii character in a string, backwards
  ---@param str string to search
  ---@param char string character to search for
  ---@param idx? integer start index; defaults to end of string
  ---@return integer? index of char, or nil if not found
  rfind_char = function(str, char, idx)
    local ascii = char:byte(1)
    idx = idx or #str
    for i = idx, 1, -1 do
      if str:byte(i) == ascii then
        return i
      end
    end
    return nil
  end,

  --- Splits strings on \r or \n.
  ---@param str string to split
  ---@return string[] List of newline-delimited strings, with newlines removed.
  split_lines = function (str)
    local lines = {}
    for line in str:gmatch("[^\r\n]+") do
      table.insert(lines, line)
    end
    return lines
  end,

  ---Takes a list of strings and joins it together
  ---@param strings string[] List of strings to concatenate
  ---@param by string Separator between joined list of strings
  ---@return string String of all strings combined by join
  join = function(strings, by)
    local t = {}
    for _, v in ipairs(strings) do
      t[#t + 1] = tostring(v)
    end
    return table.concat(t, by)
  end,

}

----------------------------------------------------------------------------------------
---@endsection
----------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------
---@section Path
----------------------------------------------------------------------------------------

M.path = {

  ---Gives the basename of a path "/home/Projects/main.cpp" -> "main.cpp"
  ---@param path Path|string Path to get the basename of
  ---@return string Basename as a string
  basename = function(path)
    return tostring(path):match("[/\\]([^/\\]*)$")
  end,

  ---Removes all extensions from a name "/home/Projects/main.test.cpp" -> "main"
  ---@param path Path|string Path to remove extensions from
  ---@return string Path with extensions removed
  remove_ext = function(path)
    return tostring(path):match("[^.]*")
  end,

  ---Returns a string representation of the current dir that can be used as a
  ---file name, such as for stdpath("data") .. "/sessions"
  ---@param rep string? Directory to convert, cwd by default
  ---@return string File path that can be used to represent a directory
  dir_as_fname = function(rep)
    if rep == nil then
      rep = vim.fn.getcwd()
    end
    local home = vim.fn.expand("~")
    if M.str.starts_with(rep, home) then
      rep = "@" .. M.str.remove_prefix(rep, home)
    end
    rep, _ = rep:gsub("[/\\:]", "%%")
    return rep
  end,

}

----------------------------------------------------------------------------------------
---@endsection
----------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------
---@section Filesystem
----------------------------------------------------------------------------------------

M.fs = {

  ---Writes a string to a file, creating it if it doesn't exist, overwriting its contents otherwise
  ---@param filename string Name of file
  ---@param content string Contents of the file
  ---@return boolean True if the file was written to, false otherwise
  write_to_file = function(filename, content)
    local fd = vim.loop.fs_open(filename, "w", 438) -- 0666 permissions
    if not fd then
      vim.notify("Failed to open file: " .. filename, vim.log.levels.ERROR)
      return false
    end
    vim.loop.fs_write(fd, content, -1)
    vim.loop.fs_close(fd)
    return true
  end,

  ---Generates a per-session path name with a given suffix
  ---@param ext string? File suffix, .json by default
  ---@return Path Per-session-directory file path
  session_file = function(ext)
    if ext == nil then
      ext = ".json"
    end
    local Path = require("plenary.path")
    local rep = vim.fn.stdpath("data") .. "/sessions/" .. M.path.dir_as_fname() .. ext
    local path = Path:new(rep)
    path:parent():mkdir({ parents = true, exists_ok = true })
    return Path:new(path)
  end,

  --- Finds executable files in the current directory down using fd.
  ---@param opts table? Options
  ---@class find_executable_opts
  ---@field timeout integer? Milliseconds to search, 10'000 (10 seconds) by default
  ---@field max_depth integer? Number of directories to search. 20 by default.
  ---@return string[] Executables list
  find_executables = function(opts)
    opts = opts or {}
    local result = vim.system(
      {
        "fd",
        "--type", "x",
        "--follow",
        "--max-depth", tostring(opts.max_depth or 20),
        "--no-ignore",
        "--exclude", "CMakeFiles",
      },
      { text = true }
    ):wait(opts.timeout or 10000)
    if result.code == nil then
      vim.notify("Finding executables timed out!", vim.log.levels.ERROR)
      return {}
    else
      return M.str.split_lines(result.stdout)
    end
  end,

  ---Finds an executable from vscode/server
  ---@param extension string VSCode extension to search
  ---@param binary string Binary name to search for
  ---@return Path to binary on disk, else the binary name if not found
  find_vscode_binary = function(extension, binary)
    local Path = require("plenary.path")
    local scan = require("plenary.scandir")
    extension = string.gsub(extension or "ms-vscode.cpptools", "%-", "[-]") -- Escape "-", which has special meaning in lua
    binary = string.gsub(binary or "OpenDebugAD7", "%-", "[-]")

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
    return Path:new(binary)
  end,

}

----------------------------------------------------------------------------------------
---@endsection
----------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------
---@section Breakpoints
----------------------------------------------------------------------------------------

M.bkpt = {

  ---Removes all breakpoints
  clear = function()
    require("dap").clear_breakpoints()
  end,

  ---Gets currently set breakpoints
  ---@return Breakpoints
  get = function()
    local bkpts = {}
    local buffers = require("dap.breakpoints").get()
    if buffers ~= nil then
      for bufnr, lines in pairs(buffers) do
        local name = vim.api.nvim_buf_get_name(bufnr)
        bkpts[name] = lines
      end
    end
    return bkpts
  end,

  ---Saves breakpoints to a per-directory session file
  save = function()
    local bkpts = M.bkpt.get()
    local json = M.fs.session_file(".bkpt.json")
    json:write(vim.fn.json_encode(bkpts), "w")
  end,

  ---Loads breakpoints from a per-directory session file
  load = function()
    local dap_bkpt = require("dap.breakpoints")
    local json = M.fs.session_file(".bkpt.json")

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
  end,

}

----------------------------------------------------------------------------------------
---@endsection
----------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------
---@section Buffer
----------------------------------------------------------------------------------------

M.buf = {

  ---Close all buffers except those currently visible in a window, keep windows (splits).
  close_non_visible = function(_)
    local buffers = vim.fn.getbufinfo({ buflisted = 1 })
    for _, buffer in ipairs(buffers) do
      local is_visible = vim.fn.bufwinnr(buffer.bufnr) > 0
      if not is_visible then
        if buffer ~= vim.api.nvim_get_current_buf() then
          vim.api.nvim_buf_delete(buffer.bufnr, { force = true })
        end
      end
    end
  end,

  ---Show the current file contents as hex / toggle hex back to buffer.
  toggle_hex = function()
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
  end,

  ---Close all "widget" buffers
  close_widgets = function()
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
      if M.lst.find(x_filetype, ftype) then
        try_close(buffer)
        goto continue
      end

      local btype = vim.api.nvim_get_option_value("buftype", { buf = buffer.bufnr })
      if M.lst.find(x_buftype, btype) then
        try_close(buffer)
        goto continue
      end

      ::continue::
    end
  end,

  ---Open a file for editing, creating it if it doesn't exist.
  ---@param filename string Name of file to edit
  ---@param opts table? Options
  ---@class edit_file_opts
  ---@field chdir boolean? Also change to the directory
  ---@field initial_contents string? Initial contents of file, if it did not exist
  edit_file = function(filename, opts)
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
  end,

}

----------------------------------------------------------------------------------------
---@endsection
----------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------
---@section Operating System
----------------------------------------------------------------------------------------

M.os = {

  ---Checks if neovim is running in wsl
  ---@return boolean True if in WSL, false otherwise
  is_wsl = function()
    return vim.fn.has("wsl") == 1
  end,

  ---Uses a clipboard program from the Windows host in a WSL distro
  use_wsl_clip = function ()
    if vim.fn.has("wsl") == 1 then
      -- sudo ln -s /mnt/c/Program\ Files/Neovim/bin/win32yank.exe /usr/local/bin/win32yank
      local win32yank = "win32yank"
      -- local clip_exe = "/mnt/c/Windows/System32/clip.exe"
      local powershell = "/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe"

      if vim.fn.executable(win32yank) ~= 0 then
        vim.notify("Using clipboard: win32yank", vim.log.levels.INFO)
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
      elseif vim.fn.executable(powershell) then
        vim.notify("Using clipboard: powershell", vim.log.levels.INFO)
        vim.g.clipboard = {
          name = "powershell-windows",
          copy = {
            ["+"] = powershell .. ' -NoProfile -Command $input | Set-Clipboard',
            ["*"] = powershell .. ' -NoProfile -Command $input | Set-Clipboard',
          },
          paste = {
            ["+"] = powershell .. " -NoProfile -Command Get-Clipboard -Raw",
            ["*"] = powershell .. " -NoProfile -Command Get-Clipboard -Raw",
          },
          cache_enabled = false,
        }
      end
    end
  end,

  ---Finds python from venv or path
  ---@return string Path to python executable
  find_python = function()
    local cwd = vim.fn.getcwd()
    if os.getenv("VIRTUAL_ENV") then
      return os.getenv("VIRTUAL_ENV") .. "/bin/python"
    elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
      return cwd .. "/.venv/bin/python"
    else
      return "python"
    end
  end,

}

----------------------------------------------------------------------------------------
---@endsection
----------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------
---@section Util
----------------------------------------------------------------------------------------

M.util = {

  ---Returns the input
  ---@generic T
  ---@param i T Input
  ---@return T Input
  identity = function(i)
    return i
  end,

  ---Selects inside of or around an ascii character within  a line. Kind of works.
  ---@param char string ASCII character
  ---@param grab ("i"|"a") Grab Inside or Around
  select_motion_char = function(char, grab)
    local text = vim.api.nvim_get_current_line()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    col = col + 1 -- Cursor columns are zero-indexed, lua strings are 1

    local next = M.str.find_char(text, char, col + 1)
    if next == nil then
      return
    end

    local prev = M.str.rfind_char(text, char, col - 1)
    if prev == nil then
      prev = next
      next = M.str.find_char(text, char, prev + 1)
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
  end,

  --- Searches for executables either by searching CMake targets or using fd
  select_cxx_executable = function()
    local cmake = require("cmake-tools")
    local targets = cmake.get_launch_targets()

    local prompt = ""
    local choices = {}
    local format_item = M.util.identity

    if targets == nil or targets.data == nil then
      -- CMake Project not Configured
      vim.notify("CMake was not configured; searching filesystem...", vim.log.levels.WARN)
      prompt = "Pick an executable:"
      choices = M.fs.find_executables()
      format_item = M.util.identity
    else
      -- CMake Project Detected!
      prompt = "Pick a target:"
      choices = targets.data.abs_paths
      format_item = function(item) return M.path.basename(item) end
    end

    -- Prefer current CMake launch target
    local launch_target = cmake.get_launch_target_path()
    if launch_target ~= nil then
      M.lst.to_front(choices, tostring(launch_target))
    end
    -- Prefer the most recently selected
    if M.gbl.dap_executable ~= nil then
      M.lst.to_front(choices, M.gbl.dap_executable)
    end

    return coroutine.create(function(coro)
      vim.ui.select(choices, {
        prompt = prompt,
        format_item = format_item,
      }, function(choice)
          -- Save choice for next time
          M.gbl.dap_executable = choice
          coroutine.resume(coro, choice)
        end)
    end)
  end,

}

----------------------------------------------------------------------------------------
---@endsection
----------------------------------------------------------------------------------------

return M
