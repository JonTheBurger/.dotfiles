local M = {}

function M.config()
  for name, _ in pairs(package.loaded) do
    print(name)
    if name:match('^user') and not name:match('nvim-tree') then
      package.loaded[name] = nil
    end
  end

  vim.cmd([[source $MYVIMRC]])
  vim.notify("init.lua reloaded!", vim.log.levels.INFO)
end

return M
