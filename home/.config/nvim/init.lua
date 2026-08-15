if vim.env.DEBUG then
  if #vim.api.nvim_list_uis() == 0 then return end

  local profile = require("jit.profile")
  local log = io.open("/tmp/neotest_profile.log", "w")
  assert(log ~= nil, "Could not create temp log")
  profile.start("li1", function(th, _samples, _vmstate)
    log:write(profile.dumpstack(th, "pl", 20) or "", "\n---\n")
    log:flush()
  end)
end

if vim.env.PROFILE then
  local snacks = vim.fn.stdpath("data") .. "/lazy/snacks.nvim"
  vim.opt.rtp:append(snacks)
  require("snacks.profiler").startup({
    startup = {
      event = "VimEnter", -- stop profiler on this event. Defaults to `VimEnter`
      -- event = "UIEnter",
      -- event = "VeryLazy",
    },
  })
end
-- https://neovim.io/doc/user/lua.html
require("config")
