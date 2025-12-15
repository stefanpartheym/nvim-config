return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local default_languages = {
        -- Basics
        "query",
        "regex",
        "vim",
        "vimdoc",
        "lua",
        "luadoc",
        "luap",
        "bash",
        "c",
        "markdown",
        "markdown_inline",

        -- Webdev
        "html",
        "css",
        "javascript",
        "typescript",

        -- other
        "xml",
        "yaml",
        "json",
        "toml",
      }
      local ts = require("nvim-treesitter")
      ts.setup()
      ts.install(default_languages)
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et
