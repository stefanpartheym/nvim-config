return {
  {
    "neovim/nvim-lspconfig",
    init = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      -- Diable keymap "Signature help"
      keys[#keys + 1] = { "<C-k>", false, mode = "i" }
    end,
    opts = {
      servers = {
        tsserver = {
          init_options = {
            preferences = {
              quotePreference = "single",
              importModuleSpecifierPreference = "project-relative",
            },
          },
        },
        emmet_ls = {
          filetypes = {
            "css",
            "eruby",
            "html",
            "javascriptreact",
            "less",
            "sass",
            "scss",
            "svelte",
            "pug",
            "typescriptreact",
            "vue",
            "twig",
          },
        },
      },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        -- lua
        "lua-language-server",
        "stylua",

        -- webdev
        "css-lsp",
        "html-lsp",
        "emmet-ls",
        "typescript-language-server",
        "vue-language-server",
        "deno",
        "xmlformatter",

        -- shell
        "bash-language-server",
        "shfmt",

        -- c/cpp
        "clangd",
        "clang-format",

        -- json
        "fixjson",

        -- zig
        "zls",

        -- php
        "phpactor",
        "intelephense",
        "twigcs",
        "djlint",
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        twig = { "djlint" },
      },
    },
  },
}
