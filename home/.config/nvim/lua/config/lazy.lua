---@module "Package Manager"
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim (https://lazy.folke.io/configuration)
---@type LazyConfig
---@diagnostic disable-next-line: missing-fields
local opts = {
  change_detection = { enabled = false },
  checker = { enabled = false },
  install = { colorscheme = { "onedark" } },
  lockfile = vim.fn.stdpath("config") .. "/lazy-lock.json",
  spec = { { import = "plugins" } },
  dev = {
    path = "~/Projects/nvim",
    fallback = true, -- Fallback to git when local plugin doesn't exist
    patterns = { "neotest-gtest", "nvim-elf-file" }, -- Plugins that match these patterns will use your local versions
  },
}
require("lazy").setup(opts)
