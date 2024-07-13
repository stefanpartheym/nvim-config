return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      -- Do not preinstall any parsers.
      ensure_installed = {
        -- Basics
        "query",
        "regex",
        "vim",
        "vimdoc",
        "lua",
        "luadoc",
        "luap",
        "bash",
        "markdown",
        "markdown_inline",

        -- Programming languages
        "c",
        "zig",

        -- Webdev
        "html",
        "css",
        "javascript",
        "typescript",
        "tsx",
        "vue",
        "php",
        "twig",

        -- other
        "xml",
        "json",
        "jsonc",
        "json5",
        "yaml",
        "toml",
        "kdl",
        "dockerfile",
      },
      -- Automatically install missing parsers when entering buffer.
      auto_install = false,
      sync_install = false,
      highlight = { enable = true },
      indent = { enable = true },
      -- Enable incremental selection
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    },
    config = function(_, opts)
      -- [[ Configure Treesitter ]] See `:help nvim-treesitter`

      -- Prefer git instead of curl in order to improve connectivity in some environments
      require("nvim-treesitter.install").prefer_git = true
      require("nvim-treesitter.configs").setup(opts)

      -- There are additional nvim-treesitter modules that you can use to interact
      -- with nvim-treesitter. You should go explore a few and see what interests you:
      --
      --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
      --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
      --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et
