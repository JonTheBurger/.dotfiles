return {
  "rmagatti/goto-preview",
  keys = {
    { "gpt", function() require("goto-preview").goto_preview_type_definition() end, desc = "Preview Type Definition", },
    { "gpi", function() require("goto-preview").goto_preview_implementation() end,  desc = "Preview Implementation", },
    { "gpD", function() require("goto-preview").goto_preview_declaration() end,     desc = "Preview Declaration", },
    { "gP",  function() require("goto-preview").close_all_win() end,                desc = "Close Preview", },
    { "gpr", function() require("goto-preview").goto_preview_references() end,      desc = "Preview References", },
  },
  opts = {
    opacity = nil;
  },
}
