# JVim

This document explains the basics of getting started with `jvim`. If you are new
to `vim`, consider reading the `Vim` section below for the basics.

### Setup



## Features

This section describes the functionality in jvim not present in vanilla neovim.

### Structure

```bash
.
├── ftdetect
│   ├── ansible.lua
│   └── ...
├── init.lua
├── lazy-lock.json
├── lsp
│   ├── init.lua
│   ├── ...
│   ├── clangd.lua
│   └── ...
├── lua
│   ├── types
│   │   └── jvim.lua
│   ├── config
│   │   ├── init.lua
│   │   ├── autocmd.lua
│   │   ├── cmd.lua
│   │   ├── fn.lua
│   │   ├── ide.lua
│   │   ├── keymap.lua
│   │   ├── lazy.lua
│   │   ├── lsp.lua
│   │   ├── opt.lua
│   │   ├── prefs.lua
│   │   ├── syms.lua
│   │   └── wiki.lua
│   ├── overseer
│   │   └── ...
│   ├── plugins
│   │   ├── init.lua
│   │   ├── ai.lua
│   │   ├── build.lua
│   │   ├── completion.lua
│   │   ├── debug.lua
│   │   ├── editing.lua
│   │   ├── git.lua
│   │   ├── lint.lua
│   │   ├── mini.lua
│   │   ├── notes.lua
│   │   ├── sessions.lua
│   │   ├── snacks.lua
│   │   ├── test.lua
│   │   ├── theme.lua
│   │   └── treesitter.lua
│   └── prompts
│       └── ...
├── queries
│   ├── cpp
│   │   └── injections.scm
│   ├── markdown
│   │   └── textobjects.scm
│   └── ...
├── README.md
└── snippets
    ├── package.json
    ├── cpp.json
    └── ...
```

### Keymaps

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

- `<leader>L`: Lua
- `<leader>M`: Markdown
- `<leader>W`: Wiki (notes)

## Vim

This section describes the basics of vim.

### Modes

- `"i"` - `insert`: Text insertion mode
- `"n"` - `normal`: Keyboard command execution mode
- `"v"` - `visual | select`: Union of `x` and `s`
- `"x"` - `visual`: Any visual mode, `v` (character), `V` (line), or `<C-v>` (block)
- `"o"` - `operator pending`: Mode after an operator starts that requires a motion, e.g.
  `d` or `c`
- `"c"` - `command line`: Entered when you type `:` to write EX Commands
- `"t"` - `terminal`: Neovim's integrated terminal
- `"s"` - `select`: Highlighted selection will be replaced e.g. `gH` (rarely used)
- `"R"` - `replace`: Similar to Insert key, typing will overwrite characters `<C-R>`

### Basic Keys

- `h/j/k/l`: Move cursor left/down/up/right
- `<C-d>`/`<C-u>` (`Ctrl+d`/`Ctrl+u`): Page down/up
- TODO(POVIRK): 

### Advanced

- `]`: Go to next occurrence of `<something>` in the file (`[` for previous)

## Lua

This section serves as a desk reference for Lua.

### General

Lua uses `1`-based indexing.

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

// TODO(POVIRK): document

- `vim.keymap.set(<modes>, <keys>, <func>, <opts>)`
- `vim.print(<string>)`

- `vim.api.nvim_create_autocmd`
- `vim.api.nvim_create_user_command`
- `vim.api.nvim_get_current_line()`
- `vim.api.nvim_win_get_cursor(0)`
- `vim.api.nvim_list_bufs()`
- `vim.api.nvim_set_hl(0, "<Name>", { link = "<SomeOtherHighlight>" })`
- `vim.api.nvim_feedkeys("<keys>", <modes>, false)`
- `vim.api.nvim_win_set_cursor(0, { line, col })`

- `vim.fs.dirname`
- `vim.fs.mkdir`
- `vim.fs.fs_stat`

- `vim.fn.system(<command-string>)`
- `vim.fn.expand("~/<some>/<path>")`
- `vim.fn.filereadable(<file>)`
- `vim.fn.writefile`
- `vim.fn.readfile`
- `vim.fn.stdpath("config"|"data"|"state"|"cache"|"log")`
- `vim.fn.sort`
- `vim.fn.expand()`
- `vim.fn.has()`
- `vim.fn.join()`
- `vim.fn.json_encode()`
- `vim.fn.json_decode()`
- `vim.fn.input()`
- `vim.fn.getcwd()`
- `vim.fn.flattennew()`
- `vim.fn.filter()`
- `vim.fn.extendnew()`

- `vim.opt`
- `vim.bo`
- `vim.env`
- `vim.g`

--------------------------------------------------------------------------------

## To Do List

This section contains upcoming changes to jvim.

- Docs
- more snippets!
- Custom folds for Doxygen `{`

### Plugins

### Dev

- gtest
    - watch doesn't work
- coverage

--------------------------------------------------------------------------------

[pattern]: https://www.lua.org/pil/20.2.html
