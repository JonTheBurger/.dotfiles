-- https://github.com/vimwiki/vimwiki
return {
  "vimwiki/vimwiki",
  version = "*",
  keys = {
    { "<leader>ww", "<cmd>VimwikiIndex<CR>", desc = "Vim Wiki Diary Index" },
    { "<leader>wi", "<cmd>VimwikiDiaryIndex<CR>", desc = "Vim Wiki Diary Index" },
    { "<leader>wd", "<cmd>VimwikiMakeDiaryNote<CR>", desc = "Vim Wiki Diary Today" },
  },
  init = function()
    vim.g.vimwiki_autochdir = 1
    vim.g.vimwiki_folding = "expr"
    vim.g.vimwiki_global_ext = 0
    vim.g.vimwiki_hl_headers = 1
    vim.g.vimwiki_markdown_link_ext = 1
    vim.g.vimwiki_list = {
      {
        path = "~/Documents/wiki",
        syntax = "markdown",
        ext = "md",
        nested_syntaxes = {
          bash = "sh",
          cpp = "cpp",
          python = "python",
        },
      },
    }
  end,
}
-- Replace VimWiki?
-- wiki = vim.fn.expand("~/Documents/wiki/")
-- diary = vim.fn.expand(wiki .. "diary/")
-- vim.keymap.set("n", "<leader>0ww", function() vim.cmd(":edit " .. wiki .. "index.md") end)
-- vim.keymap.set("n", "<leader>0wi", function() vim.cmd(":edit " .. diary .. "diary.md") end)
-- vim.keymap.set("n", "<leader>0wd", function() vim.cmd(":edit " .. diary .. os.date("%Y-%m-%d") .. ".md") end)
