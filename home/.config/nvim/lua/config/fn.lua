---@module "Custom utility functions"
local M = {}

----------------------------------------------------------------------------------------
---@section Globals
----------------------------------------------------------------------------------------

M.gbl = {
  ---@type string? Path to the most recently selected debug executable
  dap_executable = nil,

  ---@type string Arguments passed to DAP executable
  dap_exe_args = "",

  ---@type string[] Arguments to pass to cmake debug adapter. The cmake debugger doesn't
  ---respect "launch" "args" DAP setting, so we instead modify the original adapter
  ---command as a workaround.
  cmake_args = { "--debugger", "--debugger-pipe", "${pipe}" },

  ---@type string Default <custom> arguments used for cmake; remembered across runs
  default_cmake_args = "",
}

----------------------------------------------------------------------------------------
---@endsection
---@section List
----------------------------------------------------------------------------------------

M.lst = {

  ---Reverses a list, in-place.
  ---@generic T
  ---@param list T[] The list to reverse.
  ---@return T[] The list passed in.
  reverse = function(list)
    local len = #list
    for i = 1, math.floor(len / 2) do
      list[i], list[len - i + 1] = list[len - i + 1], list[i]
    end
    return list
  end,

  ---Returns a copy of a list, reversed.
  ---@generic T
  ---@param list T[] The list to reverse.
  ---@return T[] A newly reversed list.
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
      if element == value then return i end
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
---@section String
----------------------------------------------------------------------------------------

M.str = {

  ---Checks if a string starts with a given prefix
  ---@param str string String to check
  ---@return boolean True if the string begins with the prefix, else false
  starts_with = function(str, prefix) return str:sub(1, #prefix) == prefix end,

  ---Removes a prefix from a string, if it starts with that prefix
  ---@param str string String to remove prefix from
  ---@param prefix string Prefix to remove
  ---@return string String with prefix removed
  remove_prefix = function(str, prefix)
    if M.str.starts_with(str, prefix) then return str:sub(1 + #prefix, #str) end
    return str
  end,

  ---Checks if a string starts with a given prefix
  ---@param str string String to check
  ---@return boolean True if the string ends with the suffix, else false
  ends_with = function(str, suffix) return str:sub(-#suffix) == suffix end,

  ---Removes a suffix from a string, if it ends with that suffix
  ---@param str string String to remove suffix from
  ---@param suffix string Suffix to remove
  ---@return string String with suffix removed
  remove_suffix = function(str, suffix)
    if M.str.ends_with(str, suffix) then return str:sub(1, #str - #suffix) end
    return str
  end,

  --- Finds the index of an ascii character in a string
  ---@param str string to search
  ---@param char string character to search for
  ---@param idx? integer start index; defaults to 1
  ---@return integer? index of char, or nil if not found
  find_char = function(str, char, idx)
    local ascii = char:byte(1)
    idx = idx or 1
    for i = idx, #str, 1 do
      if str:byte(i) == ascii then return i end
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
      if str:byte(i) == ascii then return i end
    end
    return nil
  end,

  --- Splits strings on \r or \n. Use `vim.split` if you only need one delimiter.
  ---@param str string to split
  ---@return string[] List of newline-delimited strings, with newlines removed.
  split_lines = function(str)
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

  ---@param str string String to strip
  ---@return string String with leading and trailing whitespace removed
  trim = function(str)
    str = str:gsub("^%s+", "")
    str = str:gsub("%s+$", "")
    return str
  end,

  ---Checks :match() on each string in  list
  ---@param str string Value to check
  ---@param list string[] List of patterns to match against
  ---@return boolean True if str matches any list items.
  match_any = function(str, list)
    for _, pattern in ipairs(list) do
      if str:match(pattern) then return true end
    end
    return false
  end,
}

----------------------------------------------------------------------------------------
---@endsection
---@section Path
----------------------------------------------------------------------------------------

M.path = {

  ---Gives the basename of a path "/home/Projects/main.cpp" -> "main.cpp"
  ---@param path string Path to get the basename of
  ---@return string Basename as a string
  basename = function(path) return vim.fn.fnamemodify(path, ":t") end,

  ---Gives the extension for path "/home/Projects/main.cpp" -> "cpp".
  ---If you're using a buffer name, use `vim.fn.expand("%:e")`.
  ---@param path string Path to get the extension of
  ---@return string extension without the dot
  extension = function(path) return vim.fn.fnamemodify(path, ":e") end,

  ---Removes all extensions from a name "/home/Projects/main.test.cpp" -> "main"
  ---@param path string Path to remove extensions from
  ---@return string Path with extensions removed
  remove_ext = function(path) return tostring(path):match("[^.]*") or path end,

  ---Returns a string representation of the current dir that can be used as a
  ---file name, such as for stdpath("data") .. "/sessions"
  ---@param rep string? Directory to convert, cwd by default
  ---@return string File path that can be used to represent a directory
  dir_as_fname = function(rep)
    if rep == nil then rep = vim.fn.getcwd() end
    local home = vim.fn.expand("~")
    if M.str.starts_with(rep, home) then rep = "@" .. M.str.remove_prefix(rep, home) end
    rep, _ = rep:gsub("[/\\:]", "%%")
    return rep
  end,
}

----------------------------------------------------------------------------------------
---@endsection
---@section Filesystem
----------------------------------------------------------------------------------------

M.fs = {

  ---A reminder that `vim.uv.fs_stat` exists
  ---@param path string path to check
  ---@return boolean `true` if the path exists
  exists = function(path) return vim.uv.fs_stat(path) ~= nil end,

  ---Generates a per-session path name with a given suffix
  ---@param ext string? File suffix, .json by default
  ---@return string Per-session-directory file path
  session_file = function(ext)
    if ext == nil then ext = ".json" end
    local rep = vim.fn.stdpath("data") .. "/sessions/" .. M.path.dir_as_fname() .. ext
    vim.fn.mkdir(vim.fs.dirname(rep), "p")
    return rep
  end,

  ---Saves the current session to the session file
  save_session = function()
    M.bkpt.save()
    local json = M.fs.session_file(".fn.json")
    vim.fn.writefile({
      vim.fn.json_encode({
        ["dap_executable"] = M.gbl.dap_executable,
        ["dap_exe_args"] = M.gbl.dap_exe_args,
      }),
    }, json)
  end,

  ---Loads the session file
  load_session = function()
    M.bkpt.load()
    local json = M.fs.session_file(".fn.json")
    local data = nil

    if vim.uv.fs_stat(json) then data = vim.fn.json_decode(vim.fn.readfile(json)) end
    if data == nil then return end
    M.gbl.dap_executable = data["dap_executable"]
    M.gbl.dap_exe_args = data["dap_exe_args"] or ""
  end,

  ---@param filepath string Path to a file on disk
  ---@param pattern string String pattern to check
  ---@return boolean true if the file contains the given pattern
  file_contains = function(filepath, pattern)
    local f = io.open(filepath, "r")
    if not f then return false end
    local content = f:read("*all")
    f:close()
    return content:find(pattern, 1, true) ~= nil
  end,

  --- Finds executable files in the current directory down using fd.
  ---@param opts jvim.FindExecutableOpts? Options
  ---@return string[] Executables list
  find_executables = function(opts)
    opts = opts or {}
    local result = vim
      .system({
        "fd",
        "--type",
        "x",
        "--follow",
        "--max-depth",
        tostring(opts.max_depth or 20),
        "--no-ignore",
        "--exclude",
        "CMakeFiles",
      }, { text = true })
      :wait(opts.timeout or 10000)
    if result.code == nil then
      vim.notify("Finding executables timed out!", vim.log.levels.ERROR)
      return {}
    else
      return M.str.split_lines(result.stdout or "")
    end
  end,

  ---Finds an executable from vscode/server
  ---@param extension string VSCode extension to search
  ---@param binary string Binary name to search for
  ---@return string Path to binary on disk, else the binary name if not found
  find_vscode_binary = function(extension, binary)
    extension = string.gsub(extension or "ms-vscode.cpptools", "%-", "[-]") -- Escape "-", which has special meaning in lua
    binary = string.gsub(binary or "OpenDebugAD7", "%-", "[-]")

    ---@type string[]
    local paths = {
      vim.fn.expand("~/.vscode/extensions"),
      vim.fn.expand("~/.vscode-server/extensions"),
    }

    local scan = require("plenary.scandir")
    while #paths > 0 do
      local extensions = table.remove(paths, 1)
      ---@diagnostic disable-next-line: need-check-nil
      if vim.uv.fs_stat(extensions) and vim.uv.fs_stat(extensions).type == "directory" then
        ---@type string[]
        local dirs = scan.scan_dir(tostring(extensions), { depth = 1, only_dirs = true, search_pattern = extension })
        for d = #dirs, 1, -1 do -- start with last alphabetically
          local dir = dirs[d]
          ---@type string[]
          local exe = scan.scan_dir(tostring(dir), { search_pattern = binary })
          if #exe > 0 then
            -- Try and mark as executable
            vim.fn.system("chmod +x " .. exe[1])
            return exe[1]
          end
        end
      end
    end

    -- Give up and hope it's on $PATH
    -- vim.notify("Could not find " .. binary, vim.log.levels.WARN)
    return binary
  end,
}

----------------------------------------------------------------------------------------
---@endsection
---@section Breakpoints
----------------------------------------------------------------------------------------

M.bkpt = {

  ---Removes all breakpoints
  clear = function() require("dap").clear_breakpoints() end,

  ---Gets currently set breakpoints
  ---@return table<string, jvim.Breakpoint>
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
    vim.fn.writefile({ vim.fn.json_encode(bkpts) }, json)
  end,

  ---Loads breakpoints from a per-directory session file
  load = function()
    local dap_bkpt = require("dap.breakpoints")
    local json = M.fs.session_file(".bkpt.json")

    -- Load breakpoints from disk
    local data = nil
    if vim.uv.fs_stat(json) then data = vim.fn.json_decode(vim.fn.readfile(json)) end
    if data == nil then return end

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
---@section Buffer
----------------------------------------------------------------------------------------

M.buf = {

  ---Close all buffers except those currently visible in a window, keep windows (splits).
  close_non_visible = function(_)
    local buffers = vim.fn.getbufinfo({ buflisted = 1 })
    local breakpoints = M.bkpt.get()
    for _, buffer in ipairs(buffers) do
      local is_visible = vim.fn.bufwinnr(buffer.bufnr) > 0
      local has_breakpoint = breakpoints[vim.api.nvim_buf_get_name(buffer.bufnr)] ~= nil
      if not is_visible and not has_breakpoint then
        if buffer ~= vim.api.nvim_get_current_buf() then
          vim.bo[buffer.bufnr].buflisted = false
          vim.api.nvim_buf_delete(buffer.bufnr, { force = true })
        end
      end
    end
  end,

  ---Close all "widget" buffers
  close_widgets = function()
    local x_buftype = {
      "nofile",
      "prompt",
      "terminal",
    }
    local try_close = function(buffer)
      local winid = vim.fn.bufwinid(buffer.bufnr)
      if vim.api.nvim_win_is_valid(winid) then vim.api.nvim_win_close(winid, true) end
      if vim.api.nvim_buf_is_valid(buffer.bufnr) then vim.api.nvim_buf_delete(buffer.bufnr, { force = true }) end
    end

    local buffers = vim.fn.getbufinfo()
    for _, buffer in ipairs(buffers) do
      if not vim.api.nvim_buf_is_valid(buffer.bufnr) then goto continue end

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
  ---@param opts jvim.EditFileOpts? Options
  edit_file = function(filename, opts)
    local path = vim.fn.expand(filename)
    vim.fn.mkdir(vim.fs.dirname(path), "p")

    if vim.uv.fs_stat(path) == nil then
      if opts ~= nil and opts.initial_contents ~= nil then vim.fn.writefile({ opts.initial_contents }, path) end
    end

    if opts ~= nil and opts.chdir then vim.api.nvim_set_current_dir(vim.fs.dirname(path)) end

    vim.cmd("edit " .. tostring(path))
  end,

  ---@return jvim.SourceLocation Contiguous non-whitespace text under the cursor
  file_under_cursor = function()
    ---@type jvim.SourceLocation
    local loc = { file = "" }
    local _row, col0 = unpack(vim.api.nvim_win_get_cursor(0)) -- row 1-based, col 0-based
    local text = vim.api.nvim_get_current_line()
    if text == "" then return loc end

    local i = col0 + 1 -- convert to 1-based index into Lua string
    if i > #text then i = #text end

    -- If cursor is on whitespace, optionally step right to next non-ws (handy)
    while i <= #text and text:sub(i, i):match("%s") do
      i = i + 1
    end
    if i > #text then return loc end

    local left = i
    while left > 1 and not text:sub(left - 1, left - 1):match("%s") do
      left = left - 1
    end

    local right = i
    while right <= #text and not text:sub(right, right):match("%s") do
      right = right + 1
    end

    text = text:sub(left, right - 1)

    -- Get file name
    loc.file = text
    local sep = loc.file:find(":")
    if sep then loc.file = loc.file:sub(0, sep - 1) end

    -- Get Line Col
    i = 0
    for word in text:gmatch(":(%d+)") do
      if i == 0 then
        loc.line = tonumber(word)
      elseif i == 1 then
        loc.col = tonumber(word)
      else
        break
      end
      i = i + 1
    end

    return loc
  end,

  ---Open the file (and :line:column) under cursor, pick a destination
  gf = function()
    local window = Snacks.picker.util.pick_win({
      ---@param _win int Window id to check filter against
      ---@param buf int Buffer id to check filter against
      filter = function(_win, buf) return vim.bo[buf].buftype ~= "nofile" end,
    })
    local loc = M.buf.file_under_cursor()
    if vim.api.nvim_win_is_valid(window) and vim.fn.filereadable(loc.file) == 1 then
      vim.api.nvim_set_current_win(window)
      vim.cmd.edit(loc.file)
      if loc.line then
        vim.api.nvim_win_set_cursor(0, { loc.line, (loc.col or 1) - 1 })
        vim.cmd("normal! zz")
      end
    end
  end,

  ---Move the cursor to the GCC-style diagnostic
  ---@param direction ("next"|"prev") Direction to move
  jump_to_diagnostic = function(direction)
    -- Matches GCC/Clang style: file:line:col: warning/error/note: ...
    local pattern = [[\v^[^:]+:\d+:\d+:\s*(error|warning|note|hint)\s*:]]

    local flags = direction == "next" and "W" or "Wb"
    local result = vim.fn.search(pattern, flags)

    if result == 0 then vim.notify(direction == "next" and "No next diagnostic" or "No previous diagnostic", vim.log.levels.INFO) end
  end,

  ---@return int[] list of all currently visible buffers
  get_visible = function()
    local visible_buffers = {}
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
      if vim.fn.bufwinnr(bufnr) ~= -1 then table.insert(visible_buffers, bufnr) end
    end
    return visible_buffers
  end,
}

----------------------------------------------------------------------------------------
---@endsection
---@section Operating System
----------------------------------------------------------------------------------------

M.os = {

  ---Uses a clipboard program from the Windows host in a WSL distro
  use_wsl_clip = function()
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
      elseif vim.fn.executable(powershell) == 1 then
        vim.notify("Using clipboard: powershell", vim.log.levels.INFO)
        vim.g.clipboard = {
          name = "powershell-windows",
          copy = {
            ["+"] = powershell .. " -NoProfile -Command $input | Set-Clipboard",
            ["*"] = powershell .. " -NoProfile -Command $input | Set-Clipboard",
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
---@section Pickers
----------------------------------------------------------------------------------------

M.pick = {

  ---Pick arguments to send to the debugged program, remembering the last args
  args = function()
    return coroutine.create(function(coro)
      vim.ui.input({
        prompt = "Arguments: ",
        default = require("config.fn").gbl.dap_exe_args,
        completion = "file",
      }, function(choice)
        if choice then
          require("config.fn").gbl.dap_exe_args = choice
        else
          choice = ""
        end
        coroutine.resume(coro, vim.split(choice, " +"))
      end)
    end)
  end,

  ---Searches for executables either by searching CMake targets or using fd
  cxx_exe = function()
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
    if launch_target ~= nil then M.lst.to_front(choices, tostring(launch_target)) end
    -- Prefer the most recently selected
    if M.gbl.dap_executable ~= nil then M.lst.to_front(choices, M.gbl.dap_executable) end

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

  ---Pick arguments to send to the cmake debugger
  cmake_args = function()
    -- Reset table to original 3 values
    -- We do NOT reassign the table because we need the reference to stay the same
    for i = 4, #M.gbl.cmake_args do
      M.gbl.cmake_args[i] = nil
    end

    -- Get configure presets
    local configure_presets = {}
    local file = io.open("CMakePresets.json", "r")
    if file then
      local presets_json = file:read("a")
      local presets = vim.fn.json_decode(presets_json)
      if presets.configurePresets then
        for _, preset in ipairs(presets.configurePresets) do
          configure_presets[#configure_presets + 1] = preset.name
        end
      end
      configure_presets[#configure_presets + 1] = "<custom>"
      file:close()
    end

    return coroutine.create(function(coro)
      local enter_cmake_args = function()
        vim.ui.input({
          prompt = "Enter CMake Args: ",
          default = M.gbl.default_cmake_args,
        }, function(args)
          if args then
            M.gbl.default_cmake_args = args
            for word in string.gmatch(args, "%S+") do
              M.gbl.cmake_args[#M.gbl.cmake_args + 1] = word
            end
            dd(M.gbl.cmake_args)
            coroutine.resume(coro, {})
          end
        end)
      end

      if #configure_presets > 0 then
        vim.ui.select(configure_presets, {
          format_item = M.util.identity,
          prompt = "Select a configure preset:",
        }, function(choice)
          if choice ~= "<custom>" then
            M.gbl.cmake_args[#M.gbl.cmake_args + 1] = "--preset=" .. choice
            coroutine.resume(coro, {})
          else -- == "<custom>"
            enter_cmake_args()
          end
        end)
      else
        if vim.fn.expand("%:t") == "CMakeLists.txt" then
          M.gbl.cmake_args[#M.gbl.cmake_args + 1] = "-B"
          M.gbl.cmake_args[#M.gbl.cmake_args + 1] = "build"
        end

        enter_cmake_args()
      end
    end)
  end,

  ---Pick breakpoints
  breakpoints = function()
    local bkps = M.bkpt.get()

    ---@type snacks.picker.Item[]
    local items = {}

    for filepath, breakpoints in pairs(bkps) do
      local short = vim.fn.fnamemodify(filepath, ":~:.")
      for _, bp in ipairs(breakpoints) do
        local kind = "● break"
        if bp.log_message then
          kind = "✎ log"
        elseif bp.condition then
          kind = "󰯲 cond"
        elseif bp.hit_condition then
          kind = " hit"
        end

        local detail = bp.condition or bp.log_message or bp.hit_condition or ""

        table.insert(items, {
          text = ("%s:%d  %s  %s"):format(short, bp.line, kind, detail),
          file = filepath,
          pos = { bp.line, 0 },
          filename = short,
          lnum = bp.line,
          kind = kind,
          detail = detail,
          _bp = bp,
        })
      end
    end

    table.sort(items, function(a, b)
      if a.file ~= b.file then return a.file < b.file end
      return a.lnum < b.lnum
    end)

    Snacks.picker({
      title = "Breakpoints",
      items = items,
      ---@param item snacks.picker.Item
      format = function(item)
        local ret = {}
        dd(M.path.extension(item.filename))
        local icon, hl = require("nvim-web-devicons").get_icon(item.filename, M.path.extension(item.filename), { default = true })
        ret[#ret + 1] = { icon .. " ", hl }
        ret[#ret + 1] = { item.filename .. ":", "SnacksPickerFile" }
        ret[#ret + 1] = { tostring(item.lnum), "SnacksPickerLnum" }
        ret[#ret + 1] = { "  " }
        ret[#ret + 1] = { item.kind, "DiagnosticError" }
        if item.detail ~= "" then ret[#ret + 1] = { "  " .. item.detail, "SnacksPickerDimmed" } end
        return ret
      end,
      confirm = function(picker, item)
        picker:close()
        if not item then return end
        vim.schedule(function()
          vim.cmd("edit " .. vim.fn.fnameescape(item._filepath))
          vim.api.nvim_win_set_cursor(0, { item.lnum, 0 })
          vim.cmd("normal! zz")
        end)
      end,
      preview = "file",
    })
  end,
}

----------------------------------------------------------------------------------------
---@endsection
---@section Util
----------------------------------------------------------------------------------------

M.util = {

  ---Returns the input
  ---@generic T
  ---@param i T Input
  ---@return T Input
  identity = function(i) return i end,

  ---Selects inside of or around an ascii character within  a line. Kind of works.
  ---@param char string ASCII character
  ---@param grab ("i"|"a") Grab Inside or Around
  select_motion_char = function(char, grab)
    local text = vim.api.nvim_get_current_line()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    col = col + 1 -- Cursor columns are zero-indexed, lua strings are 1

    local next = M.str.find_char(text, char, col + 1)
    if next == nil then return end

    local prev = M.str.rfind_char(text, char, col - 1)
    if prev == nil then
      prev = next
      next = M.str.find_char(text, char, prev + 1)
    end

    if grab == "i" then
      next = next - 1
    else -- grab == "a"
      prev = prev - 1
    end

    if next ~= nil then
      vim.api.nvim_win_set_cursor(0, { line, prev })
      vim.cmd("normal! v")
      vim.api.nvim_win_set_cursor(0, { line, next - 1 })
    end
  end,

  --- Invoke the build command
  build = function()
    local cmake_tools = require("cmake-tools")
    ---@diagnostic disable-next-line: assign-type-mismatch
    ---@type overseer.Api
    local overseer = require("overseer")

    if vim.uv.fs_stat("Cargo.toml") then
      overseer.run_task({ name = "cargo build" })
    elseif vim.uv.fs_stat("CMakeLists.txt") and cmake_tools.is_cmake_project() == true then
      vim.cmd("CMakeBuild")
    elseif vim.uv.fs_stat("Makefile") then
      overseer.run_task({ name = "make lint" })
    else
      vim.notify("No build task found", vim.log.levels.WARN)
    end
  end,

  ---Monkey-patch GlobalExecutableRegistry:for_dir(...) to find cmake test executables
  ---See: https://github.com/alfaix/neotest-gtest/issues/12
  ---@module "neotest-gtest.executables.global_registry"
  ---@param self neotest-gtest.GlobalExecutableRegistry
  ---@param _root_dir string
  find_cxx_tests = function(self, _root_dir)
    local ExecutablesRegistry = require("neotest-gtest.executables.registry")
    local cmake_tools = require("cmake-tools")
    local config = require("neotest-gtest.config")
    local lib = require("neotest.lib")
    local utils = require("neotest-gtest.utils")

    local normalized = utils.normalize_path(_root_dir)
    if self._root2registry[normalized] == nil then self._root2registry[normalized] = ExecutablesRegistry:new(normalized) end

    if cmake_tools.is_cmake_project() then
      local model_info = cmake_tools.get_model_info()
      local build_dir = utils.normalize_path(tostring(cmake_tools.get_build_directory()))

      for _, target_info in pairs(model_info) do
        if target_info.type == "EXECUTABLE" then
          local executable_path_relative = target_info.artifacts[1].path
          local executable_path = build_dir .. lib.files.sep .. executable_path_relative
          for _, source in ipairs(target_info.sources) do
            if config.is_test_file(source.path) then
              local source_path = utils.normalize_path(source.path)
              self._root2registry[normalized]._node2executable[source_path] = executable_path
            end
          end
        end
      end
    end

    return self._root2registry[normalized]
  end,
}

----------------------------------------------------------------------------------------
---@endsection
----------------------------------------------------------------------------------------

return M
