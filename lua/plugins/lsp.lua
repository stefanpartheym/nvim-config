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
      },
      setup = {
        emmet_ls = function(_, opts)
          opts.filetypes = {
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
          }
        end,
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
        "intelephense",
        "twigcs",
      })
    end,
  },
}
