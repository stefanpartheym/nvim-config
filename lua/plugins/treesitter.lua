return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = false,
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
        "superhtml",
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

      -- Map .shtml files to the superhtml filetype
      vim.filetype.add({
        extension = {
          shtml = "superhtml",
        },
      })

      -- Start treesitter highlighting/indent for installed parsers
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("treesitter_start", { clear = true }),
        callback = function(args)
          local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
          if not lang then
            return
          end
          local ok, has_parser = pcall(vim.treesitter.language.add, lang)
          if not ok or not has_parser then
            return
          end
          if pcall(vim.treesitter.start, args.buf, lang) then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et
