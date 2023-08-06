-- https://github.com/ThePrimeagen/harpoon
return {
  "ThePrimeagen/harpoon",
  keys = {
    { "<leader>f0", function() require("harpoon.ui").toggle_quick_menu() end, desc = "Harpoon Find Marks" },
    { "<leader>mm", function() require("harpoon.mark").add_file() end, desc = "Harpoon Add File" },
    { "<leader>m1", function() require("harpoon.ui").nav_file(1) end, desc = "Harpoon Navigate to 1" },
    { "<leader>m2", function() require("harpoon.ui").nav_file(2) end, desc = "Harpoon Navigate to 2" },
    { "<leader>m3", function() require("harpoon.ui").nav_file(3) end, desc = "Harpoon Navigate to 3" },
    { "<leader>m4", function() require("harpoon.ui").nav_file(4) end, desc = "Harpoon Navigate to 4" },
    { "<leader>m5", function() require("harpoon.ui").nav_file(5) end, desc = "Harpoon Navigate to 5" },
    { "<leader>m6", function() require("harpoon.ui").nav_file(6) end, desc = "Harpoon Navigate to 6" },
    { "<leader>m7", function() require("harpoon.ui").nav_file(7) end, desc = "Harpoon Navigate to 7" },
    { "<leader>m8", function() require("harpoon.ui").nav_file(8) end, desc = "Harpoon Navigate to 8" },
    { "<leader>m9", function() require("harpoon.ui").nav_file(9) end, desc = "Harpoon Navigate to 9" },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("harpoon").setup({
      tabline = false,
    })
  end,
}
