local TelescopeBuiltin = require("telescope.builtin")

return {
  {
    "nvim-pack/nvim-spectre",
    enabled = false,
  },
  {
    "ahmedkhalf/project.nvim",
    enabled = false,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    keys = {
      { "<leader>fe", false },
      { "<leader>fE", false },
      { "<leader>e", false },
      { "<leader>E", false },
      {
        "<leader>f",
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
      { "<leader>fb", false },
      { "<leader>fc", false },
      { "<leader>ff", false },
      { "<leader>fF", false },
      { "<leader>fg", false },
      { "<leader>fr", false },
      { "<leader>fR", false },
      { "<leader>sG", false },
      { "<leader>sR", false },
      { "<leader>sD", false },
      { "<leader>sh", TelescopeBuiltin.help_tags, desc = "Search help" },
      { "<leader>sk", TelescopeBuiltin.keymaps, desc = "Search keymaps" },
      { "<leader>sm", TelescopeBuiltin.marks, desc = "Search marks" },
      { "<leader>sM", TelescopeBuiltin.man_pages, desc = "Search man pages" },
      { "<leader>sf", TelescopeBuiltin.find_files, desc = "Search files" },
      { "<leader>sg", TelescopeBuiltin.live_grep, desc = "Grep search" },
      { "<leader>sd", TelescopeBuiltin.diagnostics, desc = "Search diagnostics" },
      { "<leader>sr", TelescopeBuiltin.resume, desc = "Resume search" },
      { "<leader>s.", TelescopeBuiltin.oldfiles, desc = "Search recent files" },
      { "<leader> ", TelescopeBuiltin.buffers, desc = "Search existing buffers" },
    },
  },
  {
    "folke/todo-comments.nvim",
    keys = {
      { "<leader>xt", false },
      { "<leader>xT", false },
      { "<leader>lt", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
      { "<leader>lT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
    },
  },
  {
    "folke/trouble.nvim",
    keys = {
      { "<leader>xx", false },
      { "<leader>xX", false },
      { "<leader>xL", false },
      { "<leader>xl", false },
      { "<leader>xQ", false },
      { "<leader>xq", false },
      { "<leader>lx", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics (Trouble)" },
      { "<leader>lx", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics (Trouble)" },
      { "<leader>ll", "<cmd>TroubleToggle loclist<cr>", desc = "Location List (Trouble)" },
      { "<leader>lq", "<cmd>TroubleToggle quickfix<cr>", desc = "Quickfix List (Trouble)" },
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
}
