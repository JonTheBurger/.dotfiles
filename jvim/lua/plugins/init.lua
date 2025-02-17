-- This is an example for how to download a lazy package: https://github.com/folke/lazy.nvim?tab=readme-ov-file#-plugin-spec
--- @type LazyPlugin
return {
--[[
  -- Plugin ID on github
  "githubname/repository",
  -- Set to false to disable plugin
  enabled = true,
  -- You can constrain the semantic version - note that lazy lock freezes all exact versions
  version = "*",
  -- Other plugins that must be loaded first - if they are present in your plugins, your config will be used
  dependencies = {
    "githubname2/repository2",
    "githubname3/repository3",
    "githubname4/repository4",
  },
  -- Load when keys are pressed - also sets up shortcuts
  keys = {
    { "<leader>hi", function() require("theplugin").hi() end, desc = "Do Something", },
    { "<leader>bye", function() require("theplugin").bye() end, desc = "Do Something Else", },
  },
  -- Load the plugin when one of the following EX commands are run
  cmd = {
    "DoSomething",
    "DoSomethingElse",
  },
  -- Load when opening a file type - to see current filetype, use :set filetype?
  ft = {
    "c",
    "cpp",
    "python",
  },
  -- Load the plugin on event - can be a list of strings
  event = "BufEnter",
  -- Table or function returning a table to use for require("theplugin").setup(opts)
  opts = {
    ... -- plugin-specific
  },
  -- Allows you to call setup yourself when the plugin loads, using the opts from above
  config = function(plugin_spec, opts)
    require("theplugin").setup(opts)
  end,
  -- Init is always run at startup
  init = function()
    vim.g.some_option = 1
  end,
  -- Build is executed when a plugin is installed or updated
  build = function()
    -- Maybe build native code / download an exe
  end,
--]]
}

