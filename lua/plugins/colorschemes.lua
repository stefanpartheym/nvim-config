return {
  { "folke/tokyonight.nvim" },
  { "navarasu/onedark.nvim", opts = { style = "warmer" } },

  -- Gruvbox
  -- {
  --   "ellisonleao/gruvbox.nvim",
  --   config = function()
  --     local gruvbox = require("gruvbox")
  --     local current_word_hl = { bg = gruvbox.palette.dark2, bold = false }
  --     gruvbox.setup({
  --       contrast = "hard",
  --       overrides = {
  --         IlluminatedWordText = current_word_hl,
  --         IlluminatedWordRead = current_word_hl,
  --         IlluminatedWordWrite = current_word_hl,
  --         LspReferenceText = current_word_hl,
  --         LspReferenceRead = current_word_hl,
  --         LspReferenceWrite = current_word_hl,
  --       },
  --     })
  --   end,
  -- },

  -- Everforest
  -- {
  --   "neanias/everforest-nvim",
  --   version = false,
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require("everforest").setup({
  --       background = "hard",
  --
  --       on_highlights = function(hl, palette)
  --         hl.DiagnosticError = { fg = palette.none, bg = palette.none, sp = palette.red }
  --         hl.DiagnosticWarn = { fg = palette.none, bg = palette.none, sp = palette.yellow }
  --         hl.DiagnosticInfo = { fg = palette.none, bg = palette.none, sp = palette.blue }
  --         hl.DiagnosticHint = { fg = palette.none, bg = palette.none, sp = palette.green }
  --         hl.CurrentWord = { fg = palette.none, bg = palette.bg2, bold = false }
  --       end,
  --     })
  --   end,
  -- },
}
