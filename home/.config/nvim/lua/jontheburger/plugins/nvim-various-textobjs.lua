return {
  {
    -- https://github.com/chrisgrieser/nvim-various-textobjs?tab=readme-ov-file
    "chrisgrieser/nvim-various-textobjs",
    lazy = false,
    opts = {
      keymaps = {
        useDefaults = true,
        disabledDefaults = {
          "r",
          "gc",
        },
      },
    },
  },
}
