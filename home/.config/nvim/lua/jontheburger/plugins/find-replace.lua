-- https://github.com/MagicDuck/grug-far.nvim
-- ALTERNATIVE: https://github.com/nvim-pack/nvim-spectre
return {
  "MagicDuck/grug-far.nvim",
  keys = {
    {
      "<C-M-h>",
      function()
        require("grug-far").open({ transient = true })
      end,
      desc = "Find/Replace",
    }
  },
  config = function()
    require("grug-far").setup({
      -- options, see Configuration section below
      -- there are no required options atm
      -- engine = "ripgrep" is default, but "astgrep" can be specified
    });
  end
}
