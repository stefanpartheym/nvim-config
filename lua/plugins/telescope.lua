return {
  -- Fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    event = "VimEnter",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { -- If encountering errors, see telescope-fzf-native README for install instructions
        "nvim-telescope/telescope-fzf-native.nvim",

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = "make",

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
      { "nvim-telescope/telescope-ui-select.nvim" },

      -- Useful for getting pretty icons, but requires special font.
      --  If you already have a Nerd Font, or terminal set up with fallback fonts
      --  you can enable this
      { "nvim-tree/nvim-web-devicons" },
    },
    config = function()
      -- Telescope is a fuzzy finder that comes with a lot of different things that
      -- it can fuzzy find! It"s more than just a "file finder", it can search
      -- many different aspects of Neovim, your workspace, LSP, and more!
      --
      -- The easiest way to use telescope, is to start by doing something like:
      --  :Telescope help_tags
      --
      -- After running this command, a window will open up and you"re able to
      -- type in the prompt window. You"ll see a list of help_tags options and
      -- a corresponding preview of the help.
      --
      -- Two important keymaps to use while in telescope are:
      --  - Insert mode: <c-/>
      --  - Normal mode: ?
      --
      -- This opens a window that shows you all of the keymaps for the current
      -- telescope picker. This is really useful to discover what Telescope can
      -- do as well as how to actually do it!

      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      require("telescope").setup({
        -- You can put your default mappings / updates / etc. in here
        --  All the info you"re looking for is in `:help telescope.setup()`
        --
        -- defaults = {
        --   mappings = {
        --     i = { ["<c-enter>"] = "to_fuzzy_refine" },
        --   },
        -- },
        -- pickers = {}
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown(),
          },
        },
        defaults = {
          prompt_prefix = " ",
          selection_caret = " ",
        },
      })

      -- Enable telescope extensions, if they are installed
      pcall(require("telescope").load_extension, "fzf")
      pcall(require("telescope").load_extension, "ui-select")
    end,
    keys = function()
      local builtin = require("telescope.builtin")
      return {
        { "<leader>,", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>", desc = "Switch Buffer" },
        { "<leader>sh", builtin.help_tags, desc = "Search help" },
        { "<leader>sk", builtin.keymaps, desc = "Search keymaps" },
        { "<leader>sm", builtin.marks, desc = "Search marks" },
        { "<leader>sM", builtin.man_pages, desc = "Search man pages" },
        { "<leader>sf", builtin.find_files, desc = "Search files" },
        { "<leader>sg", builtin.live_grep, desc = "Grep search" },
        { "<leader>sw", builtin.grep_string, desc = "Search current word" },
        { "<leader>sd", builtin.diagnostics, desc = "Search diagnostics" },
        { "<leader>sr", builtin.resume, desc = "Resume search" },
        { "<leader>s.", builtin.oldfiles, desc = "Search recent files" },
        { "<leader><leader>", builtin.buffers, desc = "Search existing buffers" },
      }
    end,
  },
}
