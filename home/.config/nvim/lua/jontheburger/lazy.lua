-- https://github.com/folke/lazy.nvim
-- https://www.lazyvim.org/
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  print("Setting up Lazy...")
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
  print("Setting up Lazy: DONE")
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("jontheburger.plugins", {
  ui = {
    -- icons = {
    --   cmd = "⌘",
    --   config = "🛠",
    --   event = "📅",
    --   ft = "📂",
    --   init = "⚙",
    --   keys = "🗝",
    --   plugin = "🔌",
    --   runtime = "💻",
    --   source = "📄",
    --   start = "🚀",
    --   task = "📌",
    --   lazy = "💤 ",
    -- },
  },
  change_detection = {
    enabled = false,
  },
  dev = {
    path = "~/Projects/nvim",
    ---@type string[] plugins that match these patterns will use your local versions instead of being fetched from GitHub
    patterns = { "neotest-gtest" },
    fallback = true, -- Fallback to git when local plugin doesn't exist
  },
  -- colorscheme = { "space-vim-dark" },
})
-- Interesting Plugins:
-- https://github.com/stevearc/overseer.nvim
