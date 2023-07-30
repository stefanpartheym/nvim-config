return {
  {
    "neovim/nvim-lspconfig",
    init = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      -- Diable keymap "Signature help"
      keys[#keys + 1] = { "<C-k>", false, mode = "i" }
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

        -- c/cpp
        "clangd",
        "clang-format",

        -- json
        "fixjson",

        -- zig
        "zls",

        -- php/shopware
        -- "phpactor", -- requires composer to be installed
        "twigcs",
      },
    },
  },
}
