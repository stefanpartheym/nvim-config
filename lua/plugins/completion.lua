return {
  {
    "saghen/blink.cmp",
    version = "1.*",
    dependencies = {
      {
        "L3MON4D3/LuaSnip",
        -- TODO: Currently pinned to v2.3 due to https://github.com/Saghen/blink.cmp/issues/517
        version = "2.3",
      },
      { "rafamadriz/friendly-snippets" },
    },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        preset = "default",
        ["<CR>"] = { "accept", "fallback" },
        ["<C-l>"] = { "snippet_forward", "fallback" },
        ["<C-h>"] = { "snippet_backward", "fallback" },
        ["<Tab>"] = { "fallback" },
        ["<S-Tab>"] = { "fallback" },
      },
      appearance = { nerd_font_variant = "mono" },
      snippets = { preset = "luasnip" },
      signature = { enabled = false },
      fuzzy = { implementation = "lua" },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        per_filetype = {
          lua = { inherit_defaults = true, "lazydev" },
        },
        providers = {
          lazydev = { module = "lazydev.integrations.blink" },
        },
      },
      completion = {
        documentation = { auto_show = true },
        ghost_text = {
          -- Disable ghost text to avoid conflicts with windsurf virtual text.
          enabled = false,
        },
      },
    },
  },
}
