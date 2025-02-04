local M = {}

M.buffer_quit_all_except_visible = function(opts)
  local buffers = vim.fn.getbufinfo({ buflisted = 1 })
  for _, buffer in ipairs(buffers) do
    local is_visible = vim.fn.bufwinnr(buffer.bufnr) > 0
    if not is_visible then
      if buffer ~= vim.api.nvim_get_current_buf() then
        vim.api.nvim_buf_delete(buffer.bufnr, { force = true })
      end
    end
  end
end

return M
