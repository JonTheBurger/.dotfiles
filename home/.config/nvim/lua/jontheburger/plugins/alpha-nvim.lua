-- https://github.com/goolord/alpha-nvim
return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    local header = {
      type = "text",
      val = {
[[   _  __   ____  ____   _   __   ____   __  ___]],
[[  / |/ /  / __/ / __ \ | | / /  /  _/  /  |/  /]],
[[ /    /  / _/  / /_/ / | |/ /  _/ /   / /|_/ / ]],
[[/_/|_/  /___/  \____/  |___/  /___/  /_/  /_/  ]],
[[                                               ]],
      },
      opts = {
        position = "center",
        hl = "Keyword",
      }
    }
    -- https://www.nerdfonts.com/cheat-sheet

    local buttons = {
      type = "group",
      val = {
        {
          type = "text",
          val = "Actions",
          opts = {
            position = "center",
            hl = "Todo",
          },
        },
        {
          type = "padding",
          val = 1,
        },
        dashboard.button("N", "  New File", ":enew<CR>"),
        dashboard.button("O", "  Old Files", ":Telescope oldfiles<CR>"),
        dashboard.button("F", "󰈞  Find File", ":Telescope find_files<CR>"),
        dashboard.button("G", "  Live Grep", ":Telescope live_grep<CR>"),
        dashboard.button("K", "󰥻  Keymaps", ":Telescope keymaps<CR>"),
        dashboard.button("L", "  Lazy", ":Lazy<CR>"),
        dashboard.button("S", "  Sessions", ':lua require("auto-session.session-lens").search_session()<CR>'),
        dashboard.button("q", "  Quit", ":q<CR>"),
      }
    }

    local sessions = {
      type = "group",
      val = function ()
        local autosession = require("auto-session")
        local sessions_root = autosession.get_root_dir()
        local sessions = autosession.get_session_files()
        local val = {
          {
            type = "text",
            val = "Sessions",
            opts = {
              position = "center",
              hl = "Todo",
            }
          },
          {
            type = "padding",
            val = 1,
          },
        }
        table.sort(sessions, function (a, b)
          local a_time = vim.fn.getftime(sessions_root .. a.path)
          local b_time = vim.fn.getftime(sessions_root .. b.path)
          return a_time > b_time
        end)
        for i, session in ipairs(sessions) do
          if i > 5 then
            break
          end
          local sc = tostring(i)
          local session_path = sessions_root .. session.path
          table.insert(val, {
            type = "button",
            val = tostring(i) .. "\t" .. session.display_name,
            on_press = function ()
              autosession.RestoreSession(session_path)
            end,
            opts = {
              keymap = {
                "n",
                sc,
                "<CMD>lua require('auto-session').RestoreSession('".. session_path .."')<CR>",
                {}
              },
              position = "center",
              width = 80,
              shortcut = sc,
              align_shortcut = "right",
              hl = "String",
              hl_shortcut = "Keyword",
            }
          })
        end
        return val
      end,
    }

    local footer = {
      type = "text",
      val = require("alpha.fortune"),
      opts = {
        position = "center",
      }
    }

    alpha.setup {
      layout = {
        {
          type = "padding",
          val = 2,
        },
        header,
        {
          type = "padding",
          val = 2,
        },
        buttons,
        {
          type = "padding",
          val = 2,
        },
        sessions,
        footer,
      },
    }
  end
}
