---@module "lazy"
---@type LazyPluginSpec[]
return {
  {
    -- https://github.com/mbbill/undotree
    "mbbill/undotree",
    enabled = not vim.g.vscode,
    keys = {
      -- stylua: ignore start
      { "<leader>u",  "<cmd>UndotreeToggle<CR>", desc = "Toggle Undo Tree" },
      { "_u",         "<cmd>UndotreeToggle<CR>", desc = "Toggle Undo Tree" },
      -- stylua: ignore end
    },
    init = function()
      vim.g.undotree_SetFocusWhenToggle = 1
      vim.g.undotree_WindowLayout = 1
      vim.g.undotree_DiffpanelHeight = 20
      vim.g.undotree_DiffAutoOpen = 0
      vim.g.undotree_DiffCommand = "diff"
      vim.api.nvim_create_autocmd("FileType", {
        desc = "UndoTree maps",
        pattern = { "undotree" },
        callback = function()
          vim.keymap.set("n", "l", "J", { buffer = true, remap = true })
          vim.keymap.set("n", "h", "K", { buffer = true, remap = true })
          vim.keymap.set("n", "d", "D", { buffer = true, remap = true })
        end,
      })
    end,
  },
  {
    -- https://github.com/esmuellert/codediff.nvim
    "esmuellert/codediff.nvim",
    enabled = true and not vim.g.vscode,
    cmd = "CodeDiff",
    keys = {
      -- stylua: ignore start
      { "<leader>gd", "<cmd>CodeDiff<CR>", desc = "Git DiffView" },
      { "_g",         "<cmd>CodeDiff<CR>", desc = "Git DiffView" },
      -- stylua: ignore end
    },
    opts = {
      explorer = {
        view_mode = "tree",
      },
      keymaps = {
        view = {
          toggle_stage = "<tab>",
        },
      },
    },
  },
  {
    -- https://github.com/lewis6991/gitsigns.nvim
    "lewis6991/gitsigns.nvim",
    enabled = not vim.g.vscode,
    keys = {
      -- stylua: ignore start
      { "<leader>gb", "<cmd>GitBlame<CR>",                     desc = "Git Blame Toggle" },
      { "_b",         "<cmd>GitBlame<CR>",                     desc = "Git Blame Toggle" },
      { "<leader>gq", "<cmd>Gitsigns setqflist all<CR>",       desc = "Git Changes in qflist" },
      { "]g",         "<cmd>Gitsigns nav_hunk next<CR>",       desc = "Next Git Change" },
      { "[g",         "<cmd>Gitsigns nav_hunk prev<CR>",       desc = "Previous Git Change" },
      { "<leader>hx", "<cmd>Gitsigns preview_hunk_inline<CR>", desc = "Hover Git Change" },
      -- stylua: ignore end
    },
    cmd = "Gitsigns",
    ---@module "gitsigns.nvim"
    ---@type Gitsigns.Config
    ---@diagnostic disable-next-line: missing-fields
    opts = {},
    init = function()
      vim.keymap.set({ "o", "x" }, "ix", "<cmd>Gitsigns select_hunk<CR>", { desc = "Git Change" })
      vim.api.nvim_create_user_command("GitBlame", function(_opts)
        local window = -1
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          if vim.bo[buf].filetype == "gitsigns-blame" then
            window = win
            break
          end
        end
        if window == -1 then
          require("gitsigns").blame()
        else
          vim.api.nvim_win_close(window, true)
        end
      end, { desc = "Git Blame" })
    end,
  },
}
