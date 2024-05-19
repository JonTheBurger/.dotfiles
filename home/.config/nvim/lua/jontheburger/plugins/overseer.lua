-- https://github.com/stevearc/overseer.nvim/tree/master?tab=readme-ov-file#installation
return {
  "stevearc/overseer.nvim",
  opts = {},
  keys = {
    { "<leader>Or", function() require("overseer").run_template() end, desc = "Overseer Run", },
    { "<leader>Ot", function() require("overseer").toggle() end, desc = "Overseer Run", },
  },
  init = function()
    vim.api.nvim_create_user_command("Build", function(args) require("overseer").run_template() end, {desc = "Build via OverseerRun", nargs='*'} )
    vim.api.nvim_create_user_command("Make", function(params)
      -- Insert args at the '$*' in the makeprg
      local cmd, num_subs = vim.o.makeprg:gsub("%$%*", params.args)
      if num_subs == 0 then
        cmd = cmd .. " " .. params.args
      end
      local task = require("overseer").new_task({
        cmd = vim.fn.expandcmd(cmd),
        components = {
          { "on_output_quickfix", open = not params.bang, open_height = 8 },
          "default",
        },
      })
      task:start()
    end, {
      desc = "Run your makeprg as an Overseer task",
      nargs = "*",
      bang = true,
    })
  end,
}
