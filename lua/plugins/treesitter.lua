return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "html",
        "css",
        "javascript",
        "typescript",
        "vue",
        "tsx",
        "c",
        "zig",
        "markdown",
        "markdown_inline",

        -- php/shopware
        "php",
        "twig",
      },
    },
  },
}
