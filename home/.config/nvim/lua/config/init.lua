require("config.opt")
require("config.lsp")
require("config.keymap")
require("config.lazy")
require("config.autocmd")
require("config.syms")
require("config.wiki")
_G.F = require("config.fn")
if _G.F.is_wsl() then
  _G.F.use_wsl_clip()
end
