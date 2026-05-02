---@module "Main Entrypoint"
require("config.opt")
require("config.prefs")
require("config.autocmd") -- Create augroup before lazy
require("config.lazy")
require("config.cmd")
require("config.ide")
require("config.keymap")
require("config.lsp")
require("config.syms")
require("config.wiki")
_G.F = require("config.fn")
