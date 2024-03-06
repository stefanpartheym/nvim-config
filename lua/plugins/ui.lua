return {
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        always_show_bufferline = true,
      },
    },
  },
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
            { action = "Telescope find_files",                                     desc = " Find file",       icon = " ", key = "f" },
            { action = "ene | startinsert",                                        desc = " New file",        icon = " ", key = "n" },
            { action = "Telescope oldfiles",                                       desc = " Recent files",    icon = " ", key = "r" },
            { action = "Telescope live_grep",                                      desc = " Find text",       icon = " ", key = "g" },
            { action = [[lua require("lazyvim.util").telescope.config_files()()]], desc = " Config",          icon = " ", key = "c" },
            { action = 'lua require("persistence").load()',                        desc = " Restore Session", icon = " ", key = "s" },
            { action = "LazyExtras",                                               desc = " Lazy Extras",     icon = " ", key = "x" },
            { action = "Lazy",                                                     desc = " Lazy",            icon = "󰒲 ", key = "l" },
            { action = "qa",                                                       desc = " Quit",            icon = " ", key = "q" },
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
  {
    "nvim-lualine/lualine.nvim",
    config = function(_, opts)
      local extended_opts = vim.tbl_deep_extend("force", opts, {
        options = {
          section_separators = { left = "", right = "" },
          component_separators = { left = "", right = "" },
        },
      })
      require("lualine").setup(extended_opts)
    end,
  },
}
