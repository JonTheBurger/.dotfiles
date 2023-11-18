-- https://github.com/rmagatti/auto-session
local function change_nvim_tree_dir()
  local nvim_tree = require("nvim-tree")
  nvim_tree.change_dir(vim.fn.getcwd())
end

local function neotest_close()
  local has_neotest, neotest = pcall(require, "neotest")
  if has_neotest then
    neotest.summary.close()
    neotest.output_panel.close()
  end
end

return {
  "rmagatti/auto-session",
  config = function()
    require("auto-session").setup({
      log_level = "error",
      auto_session_suppress_dirs = {
        "/",
        "/tmp/*",
        "~/",
        "~/Desktop/*",
        "~/Downloads/*",
        "~/Projects",
      },
      auto_save_enabled = true,
      auto_restore_enabled = true,
      auto_sesison_use_git_branch = false,
      post_restore_cmds = { change_nvim_tree_dir, }, --"NvimTreeOpen" },
      post_cwd_changed_hook = function()             -- example refreshing the lualine status line _after_ the cwd changes
        require("lualine").refresh()                 -- refresh lualine so the new session name is displayed in the status bar
      end,
      pre_save_cmds = {
        function() if vim.fn.exists(':IndentLinesToggle') > 0 then vim.cmd("NvimTreeClose") end end,
        neotest_close,
        -- Close all "DAP" buffers
        function()
          local buffers = vim.fn.getbufinfo({ buflisted = 1 })
          for _, buffer in ipairs(buffers) do
            if (buffer.name:match("DAP [^/\\]+$")) then
              vim.api.nvim_buf_delete(buffer.bufnr, { force = true })
            end
          end
        end
      },
      session_lens = {
        load_on_setup = true,
        theme_conf = { border = true },
        previewer = false,
      },
    })
    vim.keymap.set("n", "<leader>fs", require("auto-session.session-lens").search_session, {
      noremap = true,
    })
  end
}
