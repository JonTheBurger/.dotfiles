-- Format hacks
local format = function()
  if vim.bo.filetype == "python" then
    -- pyright does not support formatting
    vim.cmd([[!black %]])
  elseif vim.bo.filetype == "sh" then
    -- bash-language-server does not support formatting
    vim.cmd([[!shfmt -i 2 -s -w %]])
  elseif vim.bo.filetype == "yaml" then
    -- yaml-language-server does not support formatting
    vim.cmd([[!yamlfix %]])
  else
    vim.lsp.buf.format()
  end
end

local kind_icons = {
  Text = "",
  Method = "󰆧",
  Function = "󰊕",
  Constructor = "",
  Field = "󰇽",
  Variable = "󰂡",
  Class = "󰠱",
  Interface = "",
  Module = "",
  Property = "󰜢",
  Unit = "",
  Value = "󰎠",
  Enum = "",
  Keyword = "󰌋",
  Snippet = "",
  Color = "󰏘",
  File = "󰈙",
  Reference = "",
  Folder = "󰉋",
  EnumMember = "",
  Constant = "󰏿",
  Struct = "",
  Event = "",
  Operator = "󰆕",
  TypeParameter = "󰅲",
}

return {
  -- https://github.com/VonHeikemen/lsp-zero.nvim
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v2.x",
    lazy = true,
    config = function()
      require("lsp-zero.settings").preset({})
    end
  },

  -- https://github.com/hrsh7th/nvim-cmp
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      -- https://github.com/L3MON4D3/LuaSnip
      { "L3MON4D3/LuaSnip" },
    },
    -- https://github.com/VonHeikemen/lsp-zero.nvim/blob/v2.x/doc/md/api-reference.md#manage_nvim_cmp
    config = function()
      require("lsp-zero.cmp").extend()
      local cmp = require("cmp")
      local cmp_action = require("lsp-zero.cmp").action()
      cmp.setup({
        mapping = {
          ["<CR>"] = cmp.mapping.confirm({select = true}),
          ["<TAB>"] = cmp.mapping.confirm({select = true}),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-u>"] = function()
            for _=1,8 do
              cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
            end
          end,
          ["<C-d>"] = function()
            for _=1,8 do
              cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
            end
          end,
        },
        formatting = {
          format = function(entry, vim_item)
            -- Kind icons
            vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
            -- Source
            vim_item.menu = ({
              buffer = "[Buffer]",
              nvim_lsp = "[LSP]",
              luasnip = "[LuaSnip]",
              nvim_lua = "[Lua]",
              latex_symbols = "[LaTeX]",
            })[entry.source.name]
            return vim_item
          end
        },
      })
    end
  },

  -- https://github.com/folke/neodev.nvim
  { "folke/neodev.nvim", opts = {} },

  -- https://github.com/neovim/nvim-lspconfig
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enable = true },
    },
    cmd = "LspInfo",
    event = {"BufReadPre", "BufNewFile"},
    dependencies = {
      { "hrsh7th/cmp-nvim-lsp" },
      { "williamboman/mason-lspconfig.nvim" },
      { "williamboman/mason.nvim" },
      { "nvim-telescope/telescope.nvim" },
    },
    config = function()
      -- Formatting
      vim.api.nvim_create_user_command("Fmt", format, {})

      -- Keybindings ":h lsp-zero-keybindings"
      local lsp = require("lsp-zero")
      local telescope = require("telescope.builtin")
      lsp.on_attach(function(client, bufnr)
        local opts = { buffer = bufnr }
        local function opt(desc)
          return { desc = "LSP: " .. desc, buffer = bufnr }
        end
        vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, opt("Rename"))
        vim.keymap.set("n", "<F4>", vim.lsp.buf.code_action, opt("Code Action"))
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opt("Show Docs"))
        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opt("Prev Diagnostic"))
        vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opt("Next Diagnostic"))
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opt("Goto Declaration"))
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opt("Goto Definition"))
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opt("Goto Implementation"))
        vim.keymap.set("n", "gl", vim.diagnostic.open_float, opt("Line Diagnostic"))
        vim.keymap.set("n", "go", vim.lsp.buf.type_definition, opt("Goto Type Definition"))
        vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, opt("Signature Help"))
        -- Custom
        vim.keymap.set("n", "?", vim.diagnostic.open_float, opt("Line Diagnostic"))
        vim.keymap.set("n", "gD", vim.diagnostic.open_float, opts)
        -- vim.keymap.set("n", "?", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "gr", telescope.lsp_references, {buffer = true})
        vim.keymap.set("n", "<leader>fr", telescope.lsp_references, {buffer = true})
        vim.keymap.set({"n", "i"}, "<C-S-SPACE>", vim.lsp.buf.signature_help, opts)
        vim.keymap.set("i", "<S-F1>", vim.lsp.buf.signature_help, opts)
        vim.keymap.set("n", "gf", vim.lsp.buf.code_action, opts)
      end)

      -- Language Server Config: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      lspconfig.ansiblels.setup({capabilities = capabilities})
      lspconfig.bashls.setup({capabilities = capabilities})
      lspconfig.lemminx.setup({capabilities = capabilities})
      lspconfig.lua_ls.setup(lsp.nvim_lua_ls())
      lspconfig.neocmake.setup({capabilities = capabilities})
      lspconfig.omnisharp.setup({capabilities = capabilities})
      lspconfig.pyright.setup({capabilities = capabilities})
      lspconfig.ruff_lsp.setup({capabilities = capabilities})
      lspconfig.rust_analyzer.setup({capabilities = capabilities})
      lspconfig.yamlls.setup({capabilities = capabilities})

      -- Treat *.axaml files as XML
      vim.cmd([[autocmd BufNewFile,BufRead *.axaml setfiletype xml]])
      vim.filetype.add({
        pattern = {
          [ "*.axaml" ] = "xml"
        }
      })


      vim.filetype.add({
        pattern = {
          [ ".*ansible.*/.*.yml" ]  = "yaml.ansible",
          [ ".*ansible.*/.*.yaml" ] = "yaml.ansible",
        },
      })

      local lua = require("lspconfig").lua_ls
      lua.setup({
        settings = {
          Lua = {
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
            },
          },
        },
      })

      lsp.setup()
    end
  }
}
