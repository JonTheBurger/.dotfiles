-- https://github.com/stevearc/dressing.nvim
return {
  "stevearc/dressing.nvim",
  opts = {},
  config = function()
    require("dressing").setup()
    -- Enable Spell Support
    vim.keymap.set("n", "z=", function()
      local word = vim.fn.expand("<cword>")
      local suggestions = vim.fn.spellsuggest(word)
      vim.ui.select(
        suggestions,
        {},
        vim.schedule_wrap(function(selected)
          if selected then
            vim.api.nvim_feedkeys("ciw" .. selected, "n", true)
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, true, true), "n", true)
          end
        end)
      )
    end)
  end,
}
