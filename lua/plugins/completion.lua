return {
  {
    "saghen/blink.cmp",
    dependencies = {
      "rafamadriz/friendly-snippets",
      { "L3MON4D3/LuaSnip", version = "v2.*" },
    },
    version = "v0.*",

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = { preset = "default" },

      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "mono",
      },

      -- default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        default = { "lsp", "path", "luasnip", "snippets", "buffer" },
        -- optionally disable cmdline completions
        -- cmdline = {},
      },

      signature = { enabled = true },

      completion = {
        menu = {
          draw = {
            columns = { { "label", "label_description", gap = 1 }, { "kind_icon" } },
            treesitter = { "lsp" },
          },
        },
      },
    },
    -- allows extending the providers array elsewhere in your config
    -- without having to redefine it
    opts_extend = { "sources.default" },
  },
}
