-- https://github.com/olimorris/onedarkpro.nvim
--[[
return {
  "olimorris/onedarkpro.nvim",
  priority = 1000, -- Ensure it loads first
  config = function()
    require("onedarkpro").setup({
      colors = {},             -- Override default colors or create your own
      highlights = {},         -- Override default highlight groups or create your own
      styles = {               -- For example, to apply bold and italic, use "bold,italic"
        types = "NONE",        -- Style that is applied to types
        methods = "NONE",      -- Style that is applied to methods
        numbers = "NONE",      -- Style that is applied to numbers
        strings = "NONE",      -- Style that is applied to strings
        comments = "NONE",     -- Style that is applied to comments
        keywords = "NONE",     -- Style that is applied to keywords
        constants = "NONE",    -- Style that is applied to constants
        functions = "NONE",    -- Style that is applied to functions
        operators = "NONE",    -- Style that is applied to operators
        variables = "NONE",    -- Style that is applied to variables
        parameters = "NONE",   -- Style that is applied to parameters
        conditionals = "NONE", -- Style that is applied to conditionals
        virtual_text = "NONE", -- Style that is applied to virtual text
      },
      filetypes = {            -- Override which filetype highlight groups are loaded
        c = true,
        comment = true,
        go = true,
        html = true,
        java = true,
        javascript = true,
        json = true,
        lua = true,
        markdown = true,
        php = true,
        python = true,
        ruby = true,
        rust = true,
        scss = true,
        toml = true,
        typescript = true,
        typescriptreact = true,
        vue = true,
        xml = true,
        yaml = true,
      },
      plugins = { -- Override which plugin highlight groups are loaded
        aerial = true,
        barbar = true,
        copilot = true,
        dashboard = true,
        flash_nvim = true,
        gitsigns = true,
        hop = true,
        indentline = true,
        leap = true,
        lsp_saga = true,
        lsp_semantic_tokens = true,
        marks = true,
        mini_indentscope = true,
        neotest = true,
        neo_tree = true,
        nvim_cmp = true,
        nvim_bqf = true,
        nvim_dap = true,
        nvim_dap_ui = true,
        nvim_hlslens = true,
        nvim_lsp = true,
        nvim_navic = true,
        nvim_notify = true,
        nvim_tree = true,
        nvim_ts_rainbow = true,
        op_nvim = true,
        packer = true,
        polygot = true,
        rainbow_delimiters = true,
        startify = true,
        telescope = true,
        toggleterm = true,
        treesitter = true,
        trouble = true,
        vim_ultest = true,
        which_key = true,
      },

      options = {
        cursorline = false,                 -- Use cursorline highlighting?
        transparency = false,               -- Use a transparent background?
        terminal_colors = true,             -- Use the theme's colors for Neovim's :terminal?
        lualine_transparency = false,       -- Center bar transparency?
        highlight_inactive_windows = false, -- When the window is out of focus, change the normal background?
      }
    })
    vim.cmd("colorscheme onedark_vivid")
  end,
}
]]--

-- https://github.com/navarasu/onedark.nvim
return {
  "navarasu/onedark.nvim",
  priority = 1000, -- Ensure it loads first
  config = function()
    require('onedark').setup {
      -- Main options --
      style = 'deep',               -- Default theme style. Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
      transparent = false,          -- Show/hide background
      term_colors = true,           -- Change terminal color as per the selected theme style
      ending_tildes = false,        -- Show the end-of-buffer tildes. By default they are hidden
      cmp_itemkind_reverse = false, -- reverse item kind highlights in cmp menu

      -- toggle theme style ---
      toggle_style_key = nil,                                                              -- keybind to toggle theme style. Leave it nil to disable it, or set it to a string, for example "<leader>ts"
      toggle_style_list = { 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer', 'light' }, -- List of styles to toggle between

      -- Change code style ---
      -- Options are italic, bold, underline, none
      -- You can configure multiple style with comma separated, For e.g., keywords = 'italic,bold'
      code_style = {
        comments = 'italic',
        keywords = 'none',
        functions = 'none',
        strings = 'none',
        variables = 'none'
      },

      -- Lualine options --
      lualine = {
        transparent = false, -- lualine center bar transparency
      },

      -- Custom Highlights --
      colors = {},     -- Override default colors
      highlights = {}, -- Override highlight groups

      -- Plugins Config --
      diagnostics = {
        darker = true,     -- darker colors for diagnostic
        undercurl = true,  -- use undercurl instead of underline for diagnostics
        background = true, -- use background color for virtual text
      },
    }
    require('onedark').load()
  end,
}
