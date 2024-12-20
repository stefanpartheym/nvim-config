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
        kind_icons = {
          Text = "󰉿",
          Method = "󰆧",
          Function = "󰊕",
          Constructor = "",

          Field = "󰜢",
          Variable = "󰀫",
          Property = "󰜢",

          Class = "󰠱",
          Interface = "",
          Struct = "󰙅",
          Module = "",

          Unit = "󰑭",
          Value = "󰎠",
          Enum = "",
          EnumMember = "",

          Keyword = "󰌋",
          Constant = "󰏿",

          Snippet = "",
          Color = "󰏘",
          File = "󰈙",
          Reference = "󰈇",
          Folder = "󰉋",
          Event = "",
          Operator = "󰆕",
          TypeParameter = "󰬛",
        },
      },

      -- default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        default = { "lsp", "path", "luasnip", "snippets", "buffer", "lazydev" },
        providers = {
          lsp = { fallback_for = { "lazydev" } },
          lazydev = { name = "LazyDev", module = "lazydev.integrations.blink" },
        },
      },

      signature = { enabled = true },

      completion = {
        menu = {
          draw = {
            columns = { { "label", "label_description", gap = 1 }, { "kind_icon" } },
            treesitter = true,
          },
        },
      },
    },
    -- allows extending the providers array elsewhere in your config
    -- without having to redefine it
    opts_extend = { "sources.default" },
  },
}
