return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    -- Disabled features
    bigfile = { enabled = false },
    quickfile = { enabled = false },
    statuscolumn = { enabled = false },
    words = { enabled = false },
    -- Enabled features
    notifier = { enabled = true },
    styles = {
      notification = {
        -- Wrap notifications
        wo = { wrap = true },
      },
    },
  },
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
        Snacks.toggle.option("spell", { name = "spell check" }):map(tk("s"))
        Snacks.toggle.option("wrap", { name = "word wrap" }):map(tk("w"))
        Snacks.toggle.option("relativenumber", { name = "relative line numbers" }):map(tk("r"))
        Snacks.toggle.diagnostics():map(tk("d"))
        Snacks.toggle
          .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
          :map(tk("c"))
        Snacks.toggle.inlay_hints():map(tk("h"))
      end,
    })
  end,
}
