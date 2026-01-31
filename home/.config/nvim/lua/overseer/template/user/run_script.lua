-- https://github.com/stevearc/overseer.nvim/blob/master/doc/tutorials.md#run-a-file-on-save
return {
  name = "run script",
  builder = function()
    local file = vim.fn.expand("%:p")
    local cmd = { file }
    if vim.bo.filetype == "go" then
      cmd = { "go", "run", file }
    elseif vim.bo.filetype == "cmake" then
      cmd = { "cmake", "-P", file}
    elseif vim.bo.filetype == "python" then
      cmd = { "python", file}
    elseif vim.bo.filetype == "lua" then
      cmd = { "lua", file}
    elseif vim.bo.filetype == "c" then
      cmd = "cc " .. file .. " && ./a.out"
    elseif vim.bo.filetype == "cpp" then
      cmd = "c++ -g -std=c++23 " .. file .. " && ./a.out"
    elseif vim.bo.filetype == "nix" then
      cmd = { "nix-instantiate", "--eval", "--strict", file }
    end
    return {
      cmd = cmd,
      components = {
        { "on_output_quickfix", set_diagnostics = true },
        "on_result_diagnostics",
        "default",
      },
    }
  end,
  condition = {
    filetype = { "sh", "python", "go", "cmake", "lua", "c", "cpp", "nix" },
  },
}
