# JVim

This document explains the basics of getting started with `jvim`. If you are new
to `vim`, consider reading the `Vim` section below for the basics.

JVim is a neovim distribution focused on the development of embedded systems and
associated tooling. Language support for C, C++, Python, Rust, and C# are
present, alongside server administration tools (`sh`, `nix`, `ansible`, etc).
JVim provides a reasonable terminal-IDE experience, accommodating the build,
edit, debug, test cycle.

## Setup

JVim provides 2 installation options, copied and soft linked. Not matter which
you pick, your `nvim` config and executable will remain untouched, and a `jvim`
command will be created in `~/.local/bin`. You can remove either `jvim`
installation entirely by running `make jvim.clean` at the root of this repo.

To install the copied variant, run `make jvim` from the root of this repository.
This copies the JVim config files into an isolated `~/.config/jvim` directory.
This allows you to easily modify the JVim config files to your liking.

To install the soft linked variant, run `make jvim.link` from the root of this
repository. This symlinks the `~/.config/jvim` directory to the current clone,
allowing you to `git pull` updates directly.

Only one variant may be installed at a time. If you switch between variants, you
must `make jvim.clean` between switching.

> [!NOTE]
> JVim assumes several executables are in your `$PATH`:
> - `rg` (ripgrep)
> - `fd` (faster find)
> - `tree-sitter`

## Features

This section describes the functionality in jvim not present in vanilla neovim.
Note that `<leader>` in JVim refers to `<space>` by default.

### Build System

The build system is wired into `cmake`, `cargo`, and `make`. Building uses
[overseer.nvim] to run the jobs in a split, and [trouble.nvim] to capture the
result diagnostics. Typical workflow resembles the following:

1. `<leader>bp` to select the CMake configure preset
2. `<F7>` to build (`<leader>bo` toggles the build output panel)
3. Navigate to the build output
4. Use `[e` or `[d` to go to the previous diagnostic
5. `gf` to pick a split to open the diagnostic
6. `<leader>wd` to open the buffer diagnostics window

> [!NOTE]
> When a CMake configure preset is selected, `compile_commands.json`
> is symlinked into `$(pwd)`. `clangd`, the C/C++ language server, uses this
> file to determine which flags should be used when parsing your code. If
> clangd is not parsing correctly, double check your compile commands and
> re-launch.

### Debugging

Debugging both on host and on target is supported. Standard Visual Studio style
shortcuts are supported:

- `<F5>` Start debugger (or pause)
- `<F6>` Run to line
- `<F8>` Conditional breakpoint
- `<F9>` Breakpoint
- `<F10>` Step Over
- `<F11>` Step Into
- `<F12>` Step Out

The DapView can be navigated with `<leader>d<LETTER>`, where `<LETTER>` is one
of the widget letters (e.g. `T` for `threads`, `S` for `scopes`). Lowercase
`<LETTER>` will open the widget, captialized `<LETTER>` will open and focus.
`>` and `<` can be used to switch between debugger tabs.

- Stack frames can be navigated with `<leader>dj` / `<leader>dk`
- Variables can be inspected in the code window with `?`

Multiple debugger adapters are supported:

- `cppdbg`: Code style debugger (may require debugging C/C++ with Code)
- `gdb server`: Remove GDB server connect (debug on target)
- `gdb`: GDB Native DAP
- `lldb`: Clang/LLVM Native DAP

`CMakeLists.txt`, `python`, and `rust` debugging are also configured.

### Unit Testing

JVim ships with a unit test browser / executor. GTest executables are
automatically found in the build directory and mapped to test cases. Typical
workflow resembles the following:

- `<leader>te` to open the test explorer
    - `t` runs the test under cursor
    - `d` debugs the test under cursor
    - `o` shows output for the test under cursor
- `<leader>tf` Runs all tests in the file
- `<leader>tt` Runs the test under cursor
- `<leader>td` Debugs the test under cursor
- `<leader>to` Shows output for the test under cursor

> [!NOTE]
> `TEST_P` is not supported. You must use `<F5>` to debug parameterized
> tests instead of the test explorer.

`python` and `rust` tests are also configured.

### Linting

In addition to LSP diagnostics and build errors, linters from [nvim-lint] and
formatters from [conform.nvim] are wired up to [trouble.nvim] and `gq` (format).

## Keymap Cheat Sheet

`jvim` tends to group commands behind common keymap prefixes. While not an
exhaustive list, the groupings here should help users discover key mappings.

- `<leader>a`: AI
- `<leader>b`: Build
- `<leader>d`: Debugger
- `<leader>f`: Find
- `<leader>g`: Git
- `<leader>h`: Hover
- `<leader>s`: Search (additional Find)
- `<leader>t`: Tests
- `<leader>o`: Toggle Options
- `<leader>w`: Warnings (diagnostics)
- `_`: Window and Widget Management (`__` to close all)

Common key mappings include:

- `<C-h>/<C-j>/<C-k>/<C-l>` Move to the window ///
- `<C-Left>/<C-Down>/<C-Up>/<C-Right>` Resize window -horizontal/-vertical/+vertical/+horizontal
- `<` and `>` (`<S-,>/<S-.>`) Go to previous / next buffer
- `<C-p>` Find Files
- `<C-f>` Find Text
- `g.` Code Action/Fix
- `?` Hover diagnostic
- `<A-o>/<A-i>` Outer/Inner Incremental Selection
- `<Down>/<Up>` Add cursor below/above
- `<F5>...<F12>` Are used for debugging, `<F7>` for building

## Structure

JVim follows the standard Neovim config layout. The most consequential
directories for most uses will be `lua/config/` and `lua/plugins/`.

```bash
├── 📄 README.md  # You are currently here
├── 📄 init.lua   # Entry point to the jvim config, the "main" function
├── 📂 ftdetect/  # Detect files not known to neovim, e.g. ansible yaml files
├── 📂 lsp/       # Contains a file for each Language Server used for auto-completion
├── 📂 lua/
│   ├── 📂 types/   # emmylua type annotations for JVim types or for plugins that don't provide types
│   ├── 📂 config/  # JVim configuration
│   ├── 📂 plugins/ # plugin files, organized by category
│   └── 📂 prompts/ # AI prompt markdown files
├── 📂 queries/   # Extensions for neovim's treesitter parser - this allows us to parse comments as markdown, for instance
└── 📂 snippets/  # vscode json format code snippets - these allow you to add code templates to auto-complete results
```

## FAQs

#### How do I know which key does what?

Use `<leader>sk` to search keymaps.

#### How do I view errors?

`:messages` will display errors, and `<leader>sn` will search notifications. Use
`Alt-w` to switch panes in the notifications output.

## Vim

This section describes the basics of vim. These apply to Neovim as well, as
Neovim is a fork of vim boasting additional features.

### Modes

When you start vim, you begin in "normal mode." This mode uses the keyboard to
issue commands to the editor, rather than to insert text. To insert text (like
in a normal editor), you must explicitly enter "insert mode." Selecting text to
copy in vim requires entering one of the "visual" modes. The modes' keymap
identifiers and descriptions can be found below:

- `"i"`: `insert`: Text insertion mode (enter with `i`, `a`, etc.)
- `"n"`: `normal`: Keyboard command execution mode (enter with `<Esc>`,
  `<C-c>`, `<C-[>`)
- `"v"`: `visual | select`: Union of `x` and `s` (enter with `v`)
- `"x"`: `visual`: Any visual mode, `v` (character), `V` (line), or `<C-v>
  (block)
- `"o"`: `operator pending`: Mode after an operator starts that requires a
   motion, e.g. `d` or `c`
- `"c"`: `command line`: Entered when you type `:` to write EX Commands (e.g.
  `:qa`, `:w`)
- `"t"`: `terminal`: Neovim's integrated terminal
- `"s"`: `select`: Highlighted selection will be replaced e.g. `gH` (rarely
  used)
- `"R"`: `replace`: Similar to Insert key, typing will overwrite character

### Basic Keys

- `h/j/k/l`: Move cursor left/down/up/right
- `w/b`: Jump forward/backward by word
- `e`: Jump to end of word
- `<C-d>`/`<C-u>` (`Ctrl+d`/`Ctrl+u`): Page down/up
- `{`/`}`: Go to previous/next blank line
- `gg/G`: Top/bottom of file
- `i/a`: Insert before/after cursor
- `I/A`: Insert at start/end of line
- `<Esc>`: Go back to Normal mode (stop inserting text)
- `v`: Visual (character) selection
- `V`: Visual line selection
- `<C-v>`: Visual block selection
- `d`: Delete (cut) selected text
- `y`: Yank (copy) selected text
- `p/P`: Paste after/before cursor
- `u/<C-r>`: Undo / Redo
- `x`: Delete character under cursor
- `.`: Repeat last change
- `/text`: Search forward for `text`
- `n/N`: Next / previous match
- `*/#`: Search forward / backward for word under cursor
- `:w` Write (save) file
- `:q` Quit
- `:wq` Save and quit
- `:q!`: Quit without saving

### Buffers, Windows, and Tabs

A buffer in vim is text loaded into memory. Each open file is shown as a buffer,
but buffers don't necessarily refer to files on disk. For example, a file picker
is displayed as a buffer, but has no file on the filesystem matching its
contents. Plugins may create hidden buffers to use as scratch space as well.

A window in neovim is a visible buffer. If you open 3 files but only one is
visible on screen, you have 1 window and 3 buffers.

Tabs in vim do not refer to an open file. Rather, a tab is a completely
separate set of windows. Some vim users prefer to open widgets (such as a git
diff view) in a completely separate tab.

### Macros

In normal mode, you can use `q<letter>` to record a macro. All actions you take
will be recorded until you hit `q` again in normal mode. `@<letter>` can be used
to replay the macro you just recorded. `@@` is used to replay the most recently
replayed macro. Macros are often recorded after pressing `*` and `n` to find the
next occurrence of a pattern, thereby allowing the macro to easily run on each
occurrence.

### Substitute

Vim ships with a `sed`-like interface for substituting text. When a selection is
highlighted, you can use `:s/search/replace/g` to replace all occurrences of
`search` with `replace`. Note that `/` is an arbitrary delimiter - you could use
any character. Additionally, you can omit the trailing `g` to only substitute
once.

You can use `:g/search/d` to delete all lines containing `search`, or
`:v/search/d` to delete all lines *not* containing `search.`

### Motions

Each command in vim can be preceded with a number. For instance. `3x` will
execute the `x` command 3 times, that is it will delete 3 characters. However,
Vim and Neovim (with Treesitter) provide a number of "text objects" you can
supply as a suffix instead to turbo-charge some motions. For example, `p`
denotes a "paragraph" text object which is any text surrounded by blank lines:

```

This is a paragraph

So
Is
This

```

You instruct the command whether it should act **i**nside a text object, or
**a**round a text object. For example, when your cursor is in a paragraph, you
can use `dip` to delete all text within the paragraph (and later `p`aste it
somewhere else)

`]`/`[` can be used to find the next/previous occurrence of a text object. With
JVim, we use treesitter to extend these to go to next...

- `]2` to do comment
- `]c` class
- `]d` diagnostic
- `]f` function
- `]i` if statement / conditional
- `]q` quickfix
- `]z` fold
- `]<F9>` breakpoint

## Lua

This section serves as a desk reference for Lua.

### Modules

By default, all variables are global in lua. Use `local` to declare a non-global
variable. Modules are typically organized by creating an `M` table, adding
members, and returning it at the end of the file:

```lua
local M = {}

M.setup = function(opts)
  -- Your code here
end()

M.config = {
  -- Your data here
}

return M
```

To use code from a module, use `require("module")`. Modules are seached in the
lua runtime path, which by default includes your `~/.config/nvim/lua` as a root.
Dots in the `"module"` string denote path separators, i.e.
`~/.config/nvim/lua/config/foo.lua` is imported with `require("config.foo")`.
If a directory contains an `init.lua`, that file is imported when `require`ing
the directory name. For example, `~/.config/nvim/lua/config/init.lua` is
imported when running `require("config")`.

### Tables

Lua has a single data structure, the table. Tables act as dictionaries, but when
the key is an integer, it acts as a list. Lua uses `1`-based indexing for this
purpose.

To iterate over a list, use `ipairs` (integer pairs):

```lua
-- Creates a table { 1: 10, 2: 20, 3: 30 }
local mylist = { 10, 20, 30 }
-- prints:
-- 1 10
-- 2 20
-- 3 30
for idx, value in ipairs(mylist) do
  -- .. concatenates strings
  print(tostring(idx) .. " " .. tostring(value))
end
-- # gets the length of a table; prints 3
print(#mylist)
```

To iterate over a table, use `pairs`:

```lua
local mytable = {
  alice = 100,
  bob = 200,
  charlie = 300,
}
-- prints:
-- charlie: 300
-- bob: 200
-- alice: 100
for name, value in pairs(mytable) do
  print(name .. ": " .. tostring(value))
end
-- Index with [], prints"200
print(mytable["bob"])
```

Assigning `nil` to a table entry will delete that entry from the table.
Attempting to index into a table with a nonexistent key will return `nil`.

### Classes

TL;DR, `:` is essentially the member function operator. It passes the left side
of `:` as the first argument to the function on the right side. Use the
following blueprint for classes:

```lua
Account = {}
Account.__index = Account

function Account:new(balance)
  local this = {
    balance = balance
  }
  setmetatable(this, self)
  return this
end

function Account:withdraw(amount)
  self.balance = self.balance - amount
end

account = Account:new(1000)
account:withdraw(100)
```

### String Matching

Lua ships with a powerful string [pattern] matching facility similar to regex.
This is used for functions `str:match("pattern")`, `str:find("pattern")`, and
`str:gsub("pattern", "replacement")`. `match` will return the matched string.
`find` returns the (inclusive) start and end indices of the match, suitable for
use in `sub`. `gsub` returns the replaced string and number of replacements.

Patterns within `(parenthesis)`, also known as "capture groups", can be
supplied to return multiple matches. 

A number of character classes are supported out of the box:

| Class  | Description                           |
| ------ | ------------------------------------- |
| `.`    | all characters                        |
| `%a`   | letters                               |
| `%b()` | any balanced chars, `()` in this case |
| `%c`   | control characters                    |
| `%d`   | digits                                |
| `%l`   | lower case letters                    |
| `%p`   | punctuation characters                |
| `%s`   | space characters                      |
| `%u`   | upper case letters                    |
| `%w`   | alphanumeric characters               |
| `%x`   | hexadecimal digits                    |
| `%z`   | the character with representation 0   |

> [!NOTE]
> A capital letter inverts the character class.
> Matching is also locale dependent.

Character classes can also be made manually with `[]`. Ranges can also be used,
for example `[0-9]`, and a leading `^` can be used to invert the match. Escape
sequences such as `\n` are allowed.

Patterns can be made repeatable with pattern modifiers:

| Modifier | Description                  |
| -------- | ---------------------------- |
| `+`      | 1 or more repetitions        |
| `*`      | 0 or more repetitions        |
| `-`      | also 0 or more repetitions   |
| `?`      | optional (0 or 1 occurrence) |

Patterns can also be anchored to the start or end of a string using `^` or `$`
respectively.

`%` can be used to escape the magic characters: `( ) . % + - * ? [ ^ $`.

--------------------------------------------------------------------------------

## Neovim API

This section lists some of common, useful Neovim Lua API functions.

- `vim.keymap.set(<modes>, <keys>, <func>, <opts>)`: Add a new key binding
- `vim.print(<object>)`: Pretty print + notify a lua object
- `vim.deepcopy(<orig>)`: Create a new table, recursively copied
- `vim.tbl_filter(<func>, <list>)`: Return a new list containing only items
  where `<func>` returns `true`.
- `vim.tbl_contains(<list>, <value>)`: Returns `true` if `<value>` is in
  `<list>`
- `vim.list_extend(<dst>, <src>)`: Append `<dst>` with the items in `<src>`

- `vim.api.nvim_create_user_command(<name>, <func>, <opts>)`: Create a new EX
  command for `:<name>` - note that `<name>` must start with a capital letter
- `vim.api.nvim_create_autocmd(<events>, <opts>)`: Run a function every time a
  particular Neovim event fires; often used to set `"FileType"`-specific options
- `vim.api.nvim_list_bufs()`: Return a list of all buffer handles (ints)
- `vim.api.nvim_get_current_line()`: Gets the current line as a string
- `vim.api.nvim_win_get_cursor(0)`: Get the line (1-based), col (0-based) of the
  cursor
- `vim.api.nvim_win_set_cursor(0, { line, col })`: Set the cursor in window to
  line (1-based) and col (0-based)
- `vim.api.nvim_set_hl(0, "<Name>", { link = "<SomeOtherHighlight>" })`: Sets
  the color and highlights of a group, use `sH` to search highlights. `link`
  maps to a pre-existing group, which is good for theme consistency
- `vim.api.nvim_feedkeys("<keys>", <modes>, false)`: "Press" the provided string
  of keys. Often used with `vim.api.nvim_replace_termcodes(<string>)`

- `vim.fs.dirname`: Get the directory name of a path
- `vim.fs.mkdir(<path>, { parents = true })`: Create directory if missing
- `vim.fs.fs_stat(<path>)`: Returns stats on path or `nil` if it does not exist

- `vim.fn.system(<command-string>)`: Run a shell command and return its string
  output
- `vim.fn.expand("~/<some>/<path>")`: Expand `~` and other special chars
- `vim.fn.filereadable(<file>)`: Return `1` if file is readable
- `vim.fn.writefile(<lines>, <file>)`: Write a list of lines to file
- `vim.fn.readfile(<file>)`: Read file into a list of lines
- `vim.fn.stdpath("config"|"data"|"state"|"cache"|"log")`: Get standard Neovim
  dirs
- `vim.fn.sort(<list>, <cmp>?)`: Sort a list in-place
- `vim.fn.has(<string>)`: Check for Neovim features, e.g. `"gui_running"`
- `vim.fn.join(<list>, <delimiter>)`: Join items inot a string
- `vim.fn.json_encode(<table>)`: Encode a lua table to a json string
- `vim.fn.json_decode(<string>)`: Decode a json string to a lua table
- `vim.fn.input(<prompt>)`: Prompt the user for input text
- `vim.fn.getcwd()`:  Get current working directory
- `vim.fn.flattennew(<list>)`: Return a new list with sub-lists flattened

- `vim.opt`: Neovim options, e.g. `number`.
- `vim.bo`: Buffer-specific options, use to set e.g. `shiftwidth` per-buffer type
- `vim.g`: Global variables, used for plugins (`vim.g.pluginname`)
- `vim.env`: Access host environment variables, e.g. `vim.env.PATH`

--------------------------------------------------------------------------------

## Upcoming

This section contains upcoming changes to jvim.

- snacks score order doesn't work
- TS auto install isn't working?
- midas/rr debugger
- picker+cache for Cortex Debug
- More Snippets
- Custom folds for Doxygen `{`

### Plugins

- https://github.com/jonboh/nvim-dap-rr
- Godbolt
    - https://github.com/NickTsaizer/splitasm.nvim
    - https://github.com/ii14/neobolt.nvim
    - https://sr.ht/~chinmay/godbolt.nvim/

### Dev

- nvim-dap-cortex-debug
    - nvim-dap-view for RTT
    - nvim-dap-view for gdbserver log
- gtest
    - watch doesn't work
    - TEST_P
- coverage

--------------------------------------------------------------------------------

[overseer.nvim]: https://github.com/stevearc/overseer.nvim
[trouble.nvim]: https://github.com/folke/trouble.nvim
[conform.nvim]: https://github.com/stevearc/conform.nvim
[nvim-lint]: https://github.com/mfussenegger/nvim-lint
[pattern]: https://www.lua.org/pil/20.2.html
