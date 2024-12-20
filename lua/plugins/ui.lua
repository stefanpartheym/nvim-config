return {
  {
    "akinsho/bufferline.nvim",
    event = "VimEnter",
    opts = {
      options = {
        always_show_bufferline = true,
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(_, _, diag)
          local ret = (diag.error and " " .. diag.error .. " " or "")
            .. (diag.warning and " " .. diag.warning or "")
          return vim.trim(ret)
        end,
        offsets = {
          {
            filetype = "neo-tree",
            text = "",
            highlight = "Directory",
            text_align = "left",
          },
        },
      },
    },
    keys = {
      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle pin" },
      { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete non-pinned buffers" },
      { "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>", desc = "Delete other buffers" },
      { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete buffers to the right" },
      { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete buffers to the left" },
    },
  },

  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "auto",
          -- component_separators = "│",
          component_separators = "",
          section_separators = { left = "", right = "" },
          disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter" } },
        },
        sections = {
          lualine_a = {
            {
              "filetype",
              colored = false,
              icon_only = true,
              separator = "",
              padding = { left = 1, right = 0 },
            },
            {
              "filename",
              padding = { left = 0, right = 1 },
              symbols = {
                modified = "●",
                readonly = "",
                unnamed = "[unnamed]",
                newfile = "[new]",
              },
            },
          },
          lualine_b = {
            {
              "fileformat",
              padding = 2,
            },
          },
          lualine_c = { "encoding" },
          lualine_x = {
            {
              function()
                local reg = vim.fn.reg_recording()
                if reg == "" then
                  return "" -- not recording
                else
                  return "rec macro @" .. reg
                end
              end,
              padding = 2,
            },
            {
              "diagnostics",
              padding = 2,
            },
            {
              "diff",
              padding = 2,
              symbols = {
                added = " ",
                modified = " ",
                removed = " ",
              },
            },
            "location",
          },
          lualine_y = {
            "progress",
          },
          lualine_z = {
            "branch",
            -- function()
            --   return " " .. os.date("%R")
            -- end,
          },
        },
        extensions = { "neo-tree", "lazy" },
      })
    end,
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    version = "*",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      {
        "<leader>f",
        function()
          require("neo-tree.command").execute({ toggle = true })
        end,
        desc = "Toggle file tree",
      },
    },
    opts = function(_, opts)
      local function on_rename(data)
        Snacks.rename.on_rename_file(data.source, data.destination)
      end
      local events = require("neo-tree.events")
      local event_handlers = vim.list_extend(opts.event_handlers or {}, {
        { event = events.FILE_MOVED, handler = on_rename },
        { event = events.FILE_RENAMED, handler = on_rename },
      })

      return {
        filesystem = {
          use_libuv_file_watcher = true,
          follow_current_file = {
            enabled = true,
            leave_dirs_open = false,
          },
          filtered_items = {
            hide_dotfiles = false,
            hide_gitignored = false,
          },
        },
        window = {
          mappings = {
            ["<Bs>"] = "close_node",
            ["h"] = "close_node",
            ["l"] = "toggle_node",
            ["<Space>"] = "",
          },
        },
        event_handlers = event_handlers,
      }
    end,
  },

  -- Highly experimental plugin that completely replaces the UI for messages, cmdline and the popupmenu.
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+L, %d+B" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
            },
          },
          view = "mini",
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
      },
    },
    -- stylua: ignore
    keys = {
      { "<leader>n", "", desc = "+notifications"},
      { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect cmdline" },
      { "<leader>nl", function() require("noice").cmd("last") end, desc = "Last" },
      { "<leader>nh", function() require("noice").cmd("history") end, desc = "History" },
      { "<leader>nd", function() require("noice").cmd("dismiss") end, desc = "Dismiss all" },
      { "<leader>nt", function() require("noice").cmd("pick") end, desc = "Pick (Telescope)" },
      { "<c-f>", function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end, silent = true, expr = true, desc = "Scroll forward", mode = {"i", "n", "s"} },
      { "<c-b>", function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true, expr = true, desc = "Scroll backward", mode = {"i", "n", "s"}},
    },
    config = function(_, opts)
      -- HACK: noice shows messages from before it was enabled,
      -- but this is not ideal when Lazy is installing plugins,
      -- so clear the messages in this case.
      if vim.o.filetype == "lazy" then
        vim.cmd([[messages clear]])
      end
      require("noice").setup(opts)
    end,
  },

  -- Icons
  {
    "echasnovski/mini.icons",
    lazy = true,
    opts = {
      file = {
        [".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
        ["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
      },
      filetype = {
        dotenv = { glyph = "", hl = "MiniIconsYellow" },
      },
    },
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },

  -- UI Components
  { "MunifTanjim/nui.nvim", lazy = true },
}

-- vim: ts=2 sts=2 sw=2 et
