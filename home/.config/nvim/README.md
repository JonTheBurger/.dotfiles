# JVim


## Lua

This section serves as a desk reference for lua.

### General

Lua uses `1`-based indexing.

### Classes

TL;DR, `:` is (essentially) the member function operator. Use the following
blueprint for classes:

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

[pattern]: https://www.lua.org/pil/20.2.html
