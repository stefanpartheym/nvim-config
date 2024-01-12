local Util = require("lazyvim.util")
local MiniBufremove = require("mini.bufremove")

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
        },
        window = {
          mappings = {
            ["<Bs>"] = "close_node",
          },
        },
      },
    },
  },
  {
    "echasnovski/mini.bufremove",
    keys = {
      {
        "<leader>x",
        function()
          MiniBufremove.delete(0, false)
        end,
        desc = "Delete buffer",
      },
    },
  },
  {
    "NvChad/nvterm",
    config = function()
      require("nvterm").setup()
    end,
  },
  {
    "mg979/vim-visual-multi",
  },
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      { "<leader>fF", Util.telescope("files"), desc = "Find Files (root dir)" },
      { "<leader>ff", Util.telescope("files", { cwd = false }), desc = "Find Files (cwd)" },
    },
  },
}
