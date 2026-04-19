return {
  {
    -- https://github.com/mbbill/undotree
    "mbbill/undotree",
    enabled = not vim.g.vscode,
    event = "BufEnter",
    keys = {
      { "<leader>u",  "<cmd>UndotreeToggle<CR>", desc = "Toggle Undo Tree" },
      { "_u",  "<cmd>UndotreeToggle<CR>", desc = "Toggle Undo Tree" },
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
      { "_g", "<cmd>CodeDiff<CR>", desc = "Git DiffView" },
    },
    opts = {
      explorer = {
        view_mode = "tree",
      },
      keymaps = {
        view = {
          toggle_stage = "<tab>",
        },
      }
    },
  },
  {
    -- https://github.com/lewis6991/gitsigns.nvim
    "lewis6991/gitsigns.nvim",
    enabled = not vim.g.vscode,
    keys = {
      { "<leader>gb", require("config.fn").util.git_blame_toggle, desc = "Git Blame Toggle" },
      { "_b",         require("config.fn").util.git_blame_toggle, desc = "Git Blame Toggle" },
      { "]g",         "<cmd>Gitsigns nav_hunk next<CR>",          desc = "Next Git Change" },
      { "[g",         "<cmd>Gitsigns nav_hunk prev<CR>",          desc = "Previous Git Change" },
    },
    cmd = {
      "Gitsigns",
    },
    opts = {},
  },
}
