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
}
