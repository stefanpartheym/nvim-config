local Util = require("lazyvim.util")

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    keys = {
      { "<leader>fe", false, mode = { "i", "n", "s" } },
      { "<leader>fE", false, mode = { "i", "n", "s" } },
      { "<leader>E", false, mode = { "i", "n", "s" } },
      {
        "<leader>e",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() })
        end,
        desc = "Open file tree",
      },
    },
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
    "mg979/vim-visual-multi",
  },
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      { "<leader>fF", false, mode = { "i", "n", "s" } },
      { "<leader>fR", false, mode = { "i", "n", "s" } },
      { "<leader>sG", false, mode = { "i", "n", "s" } },
      { "<leader>ff", Util.telescope("files", { cwd = false }), desc = "Find files" },
      { "<leader>fr", Util.telescope("oldfiles", { cwd = vim.loop.cwd() }), desc = "Recent" },
      { "<leader>sg", Util.telescope("live_grep", { cwd = false }), desc = "Grep" },
    },
  },
  {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = true,
    ft = "markdown",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      workspaces = {
        {
          name = "personal",
          path = "~/notes/personal",
        },
      },
    },
  },
  {
    "folke/todo-comments.nvim",
    keys = {
      { "<leader>xt", false, mode = { "i", "n", "s" } },
      { "<leader>xT", false, mode = { "i", "n", "s" } },
      { "<leader>lt", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
      { "<leader>lT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
    },
  },
  {
    "folke/trouble.nvim",
    keys = {
      { "<leader>xx", false, mode = { "i", "n", "s" } },
      { "<leader>xX", false, mode = { "i", "n", "s" } },
      { "<leader>xL", false, mode = { "i", "n", "s" } },
      { "<leader>xl", false, mode = { "i", "n", "s" } },
      { "<leader>xQ", false, mode = { "i", "n", "s" } },
      { "<leader>xq", false, mode = { "i", "n", "s" } },
      { "<leader>lx", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics (Trouble)" },
      { "<leader>lx", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics (Trouble)" },
      { "<leader>ll", "<cmd>TroubleToggle loclist<cr>", desc = "Location List (Trouble)" },
      { "<leader>lq", "<cmd>TroubleToggle quickfix<cr>", desc = "Quickfix List (Trouble)" },
    },
  },
}
