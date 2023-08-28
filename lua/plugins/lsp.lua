return {
  {
    "neovim/nvim-lspconfig",
    init = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      -- Diable keymap "Signature help"
      keys[#keys + 1] = { "<C-k>", false, mode = "i" }
    end,
    opts = {
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
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      table.insert(
        opts.sources,
        nls.builtins.formatting.prettier.with({
          extra_filetypes = { "twig" },
        })
      )
      table.insert(
        opts.sources,
        nls.builtins.formatting.pint.with({
          command = "pint",
        })
      )
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
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
        "prettier",

        -- shell
        "bash-language-server",
        "shfmt",

        -- c/cpp
        "clangd",
        "clang-format",

        -- json
        "fixjson",

        -- dockerfile
        "hadolint",

        -- zig
        "zls",

        -- php/shopware
        "phpactor", -- requires composer to be installed
        "pint",
        "twigcs",
      },
    },
  },
}
