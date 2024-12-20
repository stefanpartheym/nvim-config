--- @type LazyPluginSpec
return {
  "folke/snacks.nvim",
  dependencies = {
    "MaximilianLloyd/ascii.nvim",
    "navarasu/onedark.nvim",
  },
  priority = 1000,
  lazy = false,
  --- @type snacks.Config
  opts = {
    bigfile = { enabled = true },
    quickfile = { enabled = true },
    dashboard = { enabled = true },
    words = { enabled = true },
    notifier = { enabled = true },
    input = { enabled = true },
    indent = {
      indent = { char = "▏", hl = "SnacksIndent" },
      scope = { char = "▏", hl = "SnacksIndentScope" },
    },
    zen = {
      win = {
        backdrop = { transparent = false },
      },
    },
    styles = {
      notification = {
        -- Wrap notifications
        wo = { wrap = true },
      },
    },
  },
  config = function(_, opts)
    local logo = require("ascii.text.neovim").sharp
    opts.dashboard.preset = { header = table.concat(logo, "\n") }
    require("snacks").setup(opts)
  end,
  -- stylua: ignore
  keys = {
    { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete buffer" },
    { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
    { "<leader>gb", function() Snacks.git.blame_line() end, desc = "Git blame line" },
    { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git browse" },
    { "<leader>gf", function() Snacks.lazygit.log_file() end, desc = "Lazygit current file history" },
    { "<leader>gl", function() Snacks.lazygit.log() end, desc = "Lazygit log" },
    { "<leader>cR", function() Snacks.rename() end, desc = "Rename file" },
    { "<c-/>", function() Snacks.terminal() end, desc = "Toggle terminal" },
    { "<c-_>", function() Snacks.terminal() end, desc = "which_key_ignore" },
  },
  init = function()
    --- Create a toggle keymap
    --- @param key string
    --- @return string
    local tk = function(key)
      return "<leader>t" .. key
    end

    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        -- Setup toggles
        Snacks.toggle.option("spell", { name = "spell check" }):map(tk("s"))
        Snacks.toggle.option("wrap", { name = "word wrap" }):map(tk("w"))
        Snacks.toggle.option("relativenumber", { name = "relative line numbers" }):map(tk("r"))
        Snacks.toggle.inlay_hints():map(tk("h"))
        Snacks.toggle.diagnostics():map(tk("d"))
        Snacks.toggle
          .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
          :map(tk("c"))
        Snacks.toggle.zen():map(tk("z"))

        -- Setup indent colors
        local palette = require("onedark.palette")[vim.g.onedark_config.style]
        Snacks.util.set_hl({
          ["SnacksIndent"] = {
            fg = palette.bg1,
          },
          ["SnacksIndentScope"] = {
            fg = palette.grey,
          },
        })
      end,
    })
  end,
}
