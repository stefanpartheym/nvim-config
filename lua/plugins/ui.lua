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

    opts = {
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
    },
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
      { "<leader>sn", "", desc = "+noice"},
      { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect cmdline" },
      { "<leader>snl", function() require("noice").cmd("last") end, desc = "Noice last message" },
      { "<leader>snh", function() require("noice").cmd("history") end, desc = "Noice history" },
      { "<leader>sna", function() require("noice").cmd("all") end, desc = "Noice all" },
      { "<leader>snd", function() require("noice").cmd("dismiss") end, desc = "Dismiss all" },
      { "<leader>snt", function() require("noice").cmd("pick") end, desc = "Noice picker (Telescope)" },
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

  -- Better `vim.notify()`
  {
    "rcarriga/nvim-notify",
    opts = {
      stages = "static",
      timeout = 3000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
      on_open = function(win)
        vim.api.nvim_win_set_config(win, { zindex = 100 })
      end,
    },
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

  -- Dashboard
  {
    "nvimdev/dashboard-nvim",
    dependencies = {
      {
        "MaximilianLloyd/ascii.nvim",
        dependencies = {
          "MunifTanjim/nui.nvim",
        },
      },
      { "nvim-tree/nvim-web-devicons" },
    },
    event = "VimEnter",
    config = function()
      local logo = require("ascii.text.neovim")
      require("dashboard").setup({
        theme = "doom",
        hide = {
          statusline = false,
        },
        config = {
          header = logo.sharp,
          -- stylua: ignore
          center = {
            { action = "Telescope find_files",              desc = " Find file",       icon = " ", key = "f" },
            { action = "ene | startinsert",                 desc = " New file",        icon = " ", key = "n" },
            { action = "Telescope oldfiles",                desc = " Recent files",    icon = " ", key = "r" },
            { action = "Telescope live_grep",               desc = " Find text",       icon = " ", key = "g" },
            { action = 'lua require("persistence").load()', desc = " Restore session", icon = " ", key = "s" },
            { action = "Lazy",                              desc = " Lazy",            icon = "󰒲 ", key = "l" },
            { action = "qa",                                desc = " Quit",            icon = " ", key = "q" },
          },
          footer = function()
            local stats = require("lazy").stats()
            local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
            return { "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms" }
          end,
        },
      })
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et
