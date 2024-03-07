-- https://github.com/rmagatti/auto-session

--- Close all buffers whose names match the given pattern
--- @param pattern string string:match buffer name filter
local function close_matching(pattern)
  local buffers = vim.fn.getbufinfo({ buflisted = 1 })
  for _, buffer in ipairs(buffers) do
    if (buffer.name:match(pattern)) then
      vim.api.nvim_buf_delete(buffer.bufnr, { force = true })
    end
  end
end

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

local function dap_close()
  close_matching("DAP [^/\\]+$")
end

local function close_unnamed()
  close_matching("^$")
end


vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'NvimTree' },
  callback = function(args)
    vim.api.nvim_create_autocmd('VimLeavePre', {
      callback = function()
        vim.api.nvim_buf_delete(args.buf, { force = true })
        return true
      end
    })
  end,
})
vim.api.nvim_create_autocmd({ 'BufEnter' }, {
  pattern = 'NvimTree*',
  callback = function()
    local view = require('nvim-tree.view')
    local is_visible = view.is_visible()

    local api = require('nvim-tree.api')
    if not is_visible then
      api.tree.open()
    end
  end,
})

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
      post_restore_cmds = { change_nvim_tree_dir, },
      post_cwd_changed_hook = function()             -- example refreshing the lualine status line _after_ the cwd changes
        require("lualine").refresh()                 -- refresh lualine so the new session name is displayed in the status bar
      end,
      pre_restore_cmds = {
        -- Close all buffers without an existing file - autosession whines if you don't
        -- function() vim.cmd("bufdo if bufname('%') ==# '' | bd | endif") end,
        close_unnamed,
      },
      pre_save_cmds = {
        function() if vim.fn.exists(':TroubleClose') > 0 then vim.cmd("TroubleClose") end end,
        function() if vim.fn.exists(':IndentLinesToggle') > 0 then vim.cmd("NvimTreeClose") end end,
        neotest_close,
        dap_close(),
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
