return {
  -- Disable plugins
  { "folke/trouble.nvim", enabled = false },
  { "folke/todo-comments.nvim", enabled = false },

  -- Override plugin config
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "onedark",
    },
  },
}
