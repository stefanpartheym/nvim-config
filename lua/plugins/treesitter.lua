return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- Preinstalled languages, that do not need to be listed explicitly:
      -- * bash
      -- * c
      -- * html
      -- * javascript
      -- * json
      -- * lua
      -- * luadoc
      -- * luap
      -- * markdown
      -- * markdown_inline
      -- * python
      -- * query
      -- * regex
      -- * vim
      -- * vimdoc
      --
      -- Installed via "lazyvim.plugins.extras.lang.typescript"
      -- * typescript
      -- * tsx
      --
      -- Installed via "lazyvim.plugins.extras.lang.yaml"
      -- * yaml
      --
      -- Installed via "lazyvim.plugins.extras.lang.json"
      -- * json
      -- * json5
      -- * jsonc
      --
      -- Installed via "lazyvim.plugins.extras.lang.docker"
      -- * dockerfile
      vim.list_extend(opts.ensure_installed, {
        "css",
        "vue",
        "zig",
        "php",
        "twig",
        "glimmer",
      })
    end,
  },
}
