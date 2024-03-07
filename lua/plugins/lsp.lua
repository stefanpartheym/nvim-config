local function intelephense_get_storage_path()
  return os.getenv("HOME") .. "/.config/intelephense"
end

local function intelephense_get_license_key()
  local f = io.open(intelephense_get_storage_path() .. "/license.txt", "rb")
  local content = ""
  if f ~= nil then
    content = f:read("*all")
    f:close()
  end
  return string.gsub(content, "%s+", "")
end

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
        intelephense = {
          init_options = {
            globalStoragePath = intelephense_get_storage_path(),
            licenceKey = intelephense_get_license_key(),
          },
        },
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
            "handlebars",
          },
        },
        zls = {
          cmd = { vim.fn.expand("$HOME/.zvm/bin/zls") },
        },
      },
    },
  },
  {
    "NoahTheDuke/vim-just",
    ft = { "just" },
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
        "pretty-php",
        "twigcs",
        "djlint",
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        php = { "pretty-php" },
        twig = { "djlint" },
        xml = { "xmlformat" },
      },
    },
  },
}
