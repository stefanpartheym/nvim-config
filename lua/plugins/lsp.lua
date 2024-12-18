local function intelephense_get_storage_path()
  return os.getenv("HOME") .. "/.config/intelephense"
end

local function intelephense_get_license_key()
  local f = io.open(intelephense_get_storage_path() .. "/license.txt", "rb")
  local content = ""
  if f ~= nil then
    content = f:read("*all")
    f:close()
  end
  return string.gsub(content, "%s+", "")
end

return {
  -- LSP Configuration & Plugins
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      {
        "williamboman/mason.nvim",
        config = true,
        keys = {
          {
            "<leader>cm",
            function()
              require("mason.ui").open()
            end,
            desc = "Open Mason",
          },
        },
      }, -- NOTE: Must be loaded before dependants
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",

      -- Useful status updates for LSP.
      { "j-hui/fidget.nvim", opts = {} },

      -- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
      -- used for completion, annotations and signatures of Neovim apis
      { "folke/neodev.nvim", opts = {} },
    },
    config = function()
      --  This function gets run when an LSP attaches to a particular buffer.
      --    That is to say, every time a new file is opened that is associated with
      --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
      --    function will be executed to configure the current buffer
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp_attach", { clear = true }),
        callback = function(event)
          -- NOTE: Remember that Lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself.
          --
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          map("gd", require("telescope.builtin").lsp_definitions, "Goto definition")

          -- NOTE: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map("gD", vim.lsp.buf.declaration, "Goto declaration")

          -- Find references for the word under your cursor.
          map("gr", require("telescope.builtin").lsp_references, "Goto references")

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map("gI", require("telescope.builtin").lsp_implementations, "Goto implementation")

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map("<leader>ssd", require("telescope.builtin").lsp_document_symbols, "Search document symbols")

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          map("<leader>ssw", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Search workspace symbols")

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          map("<leader>cr", vim.lsp.buf.rename, "Rename symbol")

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map("<leader>ca", vim.lsp.buf.code_action, "Code action")

          -- Show LspInfo
          map("<leader>cl", "<Cmd>LspInfo<Cr>", "Show LspInfo")

          -- Show diagnostics in current line
          map("<leader>cd", vim.diagnostic.open_float, "Line diagnostics")

          -- TODO:
          -- Add futher LSP keymaps from:
          -- [LazyVim](https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/lsp/keymaps.lua#L24)

          -- Show signature help
          vim.keymap.set(
            "i",
            "<C-k>",
            vim.lsp.buf.signature_help,
            { buffer = event.buf, desc = "LSP: Show signature help" }
          )

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.documentHighlightProvider then
            local highlight_augroup = vim.api.nvim_create_augroup("lsp_highlight", { clear = false })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd("LspDetach", {
              group = vim.api.nvim_create_augroup("lsp_detach", { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds({ group = "lsp_highlight", buffer = event2.buf })
              end,
            })
          end

          -- The following autocommand is used to enable inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
            map("<leader>th", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({}))
            end, "Toggle inlay hints")
          end
        end,
      })

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

      --- List of manually managed servers (that is, servers not managed by Mason).
      --- @type table<string, lspconfig.Config>
      local servers = {
        -- NOTE:
        -- Setup `zls` manually to always use current version from `.zigversion`.
        -- See [ziege](https://github.com/photex/ziege) for more information.
        zls = {},
        -- NOTE:
        -- Setup `kotlin_language_server` manually to use forked version from
        -- [github.com/kotlin-community-tools](https://github.com/kotlin-community-tools/kotlin-language-server).
        -- This fork contains fixes, that prevent the language server from raising
        -- annoying internal errors.
        kotlin_language_server = {
          cmd = {
            os.getenv("HOME") .. "/.lsp/kotlin-language-server/server/build/install/server/bin/kotlin-language-server",
          },
        },
      }

      -- Setup manually managed language servers.
      for server_name, server in pairs(servers) do
        server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
        require("lspconfig")[server_name].setup(server)
      end

      --- List of configs for language servers managed by Mason.
      --- @type table<string, lspconfig.Config>
      local mason_managed_servers = {
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = "Replace",
              },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              -- diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },

        intelephense = {
          init_options = {
            globalStoragePath = intelephense_get_storage_path(),
            licenceKey = intelephense_get_license_key(),
          },
        },

        -- TODO: Consider also using [typescript-tools.nvim](https://github.com/pmizio/typescript-tools.nvim)
        ts_ls = {
          init_options = {
            preferences = {
              quotePreference = "single",
              importModuleSpecifierPreference = "project-relative",
            },
          },
        },
      }

      -- Setup Mason.
      require("mason").setup()
      -- Ensure the following servers and tools are installed via Mason.
      require("mason-tool-installer").setup({
        ensure_installed = {
          -- Language servers
          "lua-language-server",
          "bash-language-server",
          "clangd",
          "json-lsp",
          "yaml-language-server",
          "lemminx", -- XML language server
          "css-lsp",
          "html-lsp",
          "emmet-ls",
          "typescript-language-server",
          "vue-language-server",
          "intelephense",
          -- Formatters/linters/etc.
          "stylua",
          "shfmt",
          "prettier",
          "clang-format",
          "xmlformatter",
          "pretty-php",
          "twigcs",
          "djlint",
        },
      })

      -- Setup language servers managed by Mason.
      require("mason-lspconfig").setup({
        handlers = {
          function(server_name)
            local server = mason_managed_servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for ts_ls)
            server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
            require("lspconfig")[server_name].setup(server)
          end,
        },
      })
    end,
  },

  -- Autoformat
  {
    "stevearc/conform.nvim",
    lazy = false,
    keys = function()
      local format = require("util.format")
      return {
        {
          "<leader>cf",
          function()
            if format.autoformat_enabled() then
              require("conform").format({ async = true, lsp_fallback = true })
            end
          end,
          mode = "",
          desc = "Format buffer",
        },
        {
          "<leader>tf",
          function()
            format.autoformat_toggle()
          end,
          desc = "Toggle auto format",
        },
      }
    end,
    opts = function()
      local format = require("util.format")
      local opts = {
        notify_on_error = false,
        format_on_save = function()
          if format.autoformat_enabled() then
            return { timeout_ms = 1000 }
          else
            return nil
          end
        end,
        formatters_by_ft = {
          lua = { "stylua" },
          xml = { "xmlformat" },
          php = { "pretty-php" },
          twig = { "djlint" },
          zig = { "zigfmt" },
          kotlin = { "ktfmt" },
          -- Conform can also run multiple formatters sequentially
          -- python = { "isort", "black" },
          --
          -- You can use a sub-list to tell conform to run *until* a formatter
          -- is found.
          -- javascript = { { "prettierd", "prettier" } },
        },
        formatters = {
          zigfmt = {
            command = "zig",
            args = { "fmt", "--stdin" },
            stdin = true,
          },
          ktfmt = {
            command = "ktfmt",
            args = { "--kotlinlang-style", "-" },
          },
        },
      }

      local prettier_fts = {
        "css",
        "graphql",
        "handlebars",
        "html",
        "javascript",
        "javascriptreact",
        "json",
        "jsonc",
        "json5",
        "less",
        "markdown",
        "markdown.mdx",
        "scss",
        "typescript",
        "typescriptreact",
        "vue",
        "yaml",
      }
      for _, ft in ipairs(prettier_fts) do
        opts.formatters_by_ft[ft] = { "prettier" }
      end
      return opts
    end,
  },

  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      {
        "L3MON4D3/LuaSnip",
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
            return
          end
          return "make install_jsregexp"
        end)(),
        dependencies = {
          -- `friendly-snippets` contains a variety of premade snippets.
          --    See the README about individual language/framework/plugin snippets:
          --    https://github.com/rafamadriz/friendly-snippets
          {
            "rafamadriz/friendly-snippets",
            config = function()
              require("luasnip.loaders.from_vscode").lazy_load()
            end,
          },
        },
      },
      "saadparwaiz1/cmp_luasnip",
      "onsails/lspkind.nvim",

      -- Adds other completion capabilities.
      --  nvim-cmp does not ship with all sources by default. They are split
      --  into multiple repos for maintenance purposes.
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
    },
    config = function()
      -- See `:help cmp`
      local cmp = require("cmp")
      local lspkind = require("lspkind")
      local luasnip = require("luasnip")
      luasnip.config.setup({})

      cmp.setup({
        formatting = {
          fields = { "abbr", "kind", "menu" },
          expandable_indicator = true,
          format = lspkind.cmp_format({
            mode = "symbol_text",
            maxwidth = 50,
            ellipsis_char = "…",
          }),
        },

        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },

        completion = { completeopt = "menu,menuone,noinsert" },

        -- For an understanding of why these mappings were
        -- chosen, you will need to read `:help ins-completion`
        --
        -- No, but seriously. Please read `:help ins-completion`, it is really good!
        mapping = cmp.mapping.preset.insert({
          -- Select the [n]ext item
          ["<C-n>"] = cmp.mapping.select_next_item(),
          -- Select the [p]revious item
          ["<C-p>"] = cmp.mapping.select_prev_item(),

          -- Scroll the documentation window [b]ack / [f]orward
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),

          -- Accept ([y]es) the completion.
          --  This will auto-import if your LSP supports it.
          --  This will expand snippets if the LSP sent a snippet.
          ["<C-y>"] = cmp.mapping.confirm({ select = true }),

          -- If you prefer more traditional completion keymaps,
          -- you can uncomment the following lines
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          --['<Tab>'] = cmp.mapping.select_next_item(),
          --['<S-Tab>'] = cmp.mapping.select_prev_item(),

          -- Manually trigger a completion from nvim-cmp.
          --  Generally you don't need this, because nvim-cmp will display
          --  completions whenever it has completion options available.
          ["<C-Space>"] = cmp.mapping.complete({}),

          -- Think of <c-l> as moving to the right of your snippet expansion.
          --  So if you have a snippet that's like:
          --  function $name($args)
          --    $body
          --  end
          --
          -- <c-l> will move you to the right of each of the expansion locations.
          -- <c-h> is similar, except moving you backwards.
          ["<C-l>"] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { "i", "s" }),
          ["<C-h>"] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { "i", "s" }),

          -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
          --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
        },
      })
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et
