-- https://github.com/Vonr/align.nvim
return {
  "Vonr/align.nvim",
  keys = {
    {
      "aa",
      function()
        require("align").align_to_char({ length = 1, })
      end,
      mode = { "x" },
      noremap = true,
      silent = true,
      desc = "Align to 1 character"
    },
    {
      "ad",
      function() require("align").align_to_char({ preview = true, length = 2, }) end,
      mode = { "x" },
      noremap = true,
      silent = true,
      desc = "Align to 2 characters with previews"
    },
    {
      "aw",
      function() require("align").align_to_string({ preview = true, regex = false, }) end,
      mode = { "x" },
      noremap = true,
      silent = true,
      desc = "Align to a string with previews"
    },
    {
      "ar",
      function() require("align").align_to_string({ preview = true, regex = true, }) end,
      mode = { "x" },
      noremap = true,
      silent = true,
      desc = "Align to a Vim regex with previews"
    },
    {
      "gaw",
      function()
        local a = require "align"
        a.operator(
          a.align_to_string,
          {
            regex = false,
            preview = true,
          }
        )
      end,
      mode = { "n" },
      noremap = true,
      silent = true,
      desc = "Example gawip to align a paragraph to a string with previews"
    },
    {
      "gaa",
      function()
        local a = require "align"
        a.operator(a.align_to_char)
      end,
      mode = { "n" },
      noremap = true,
      silent = true,
      desc = "Example gaaip to align a paragraph to 1 character"
    },
  },
}
