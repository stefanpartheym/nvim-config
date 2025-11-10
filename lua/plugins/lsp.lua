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
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      -- Mason must be loaded before its dependents so we need to set it up here.
      {
        "mason-org/mason.nvim",
        opts = {},
        keys = {
          {
            "<leader>cm",
            function()
              require("mason.ui").open()
            end,
            desc = "Open Mason",
          },
        },
      },
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      -- Useful status updates for LSP.
      "j-hui/fidget.nvim",
      -- Allows extra capabilities provided by blink.cmp
      "saghen/blink.cmp",
      -- Neovim configuration support for lua_ls.
      {
        "folke/lazydev.nvim",
        dependencies = { "folke/snacks.nvim" },
        ft = "lua",
        opts = {
          library = {
            -- See the configuration section for more details
            -- Load luvit types when the `vim.uv` word is found
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            { path = "lazy.nvim" },
            { path = "snacks.nvim", words = { "Snacks" } },
          },
          integrations = {
            -- Fixes lspconfig's workspace management for LuaLS
            -- Only create a new workspace if the buffer is not part
            -- of an existing workspace or one of its libraries
            lspconfig = true,
          },
        },
      },
      "b0o/schemastore.nvim",
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
        end,
      })

      -- Diagnostic Config
      -- See :help vim.diagnostic.Opts
      vim.diagnostic.config({
        severity_sort = true,
        float = { border = "rounded", source = "if_many" },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "󰅚 ",
            [vim.diagnostic.severity.WARN] = "󰀪 ",
            [vim.diagnostic.severity.INFO] = "󰋽 ",
            [vim.diagnostic.severity.HINT] = "󰌶 ",
          },
        },
        virtual_text = {
          source = "if_many",
          spacing = 2,
          format = function(diagnostic)
            local diagnostic_message = {
              [vim.diagnostic.severity.ERROR] = diagnostic.message,
              [vim.diagnostic.severity.WARN] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
      })

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add blink.cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with blink.cmp, and then broadcast that to the servers.
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      --- List of manually managed servers (that is, servers not managed by Mason).
      --- @type table<string, vim.lsp.Config>
      local servers = {
        -- NOTE:
        -- Setup `zls` manually to always use current version from `.minimum_zig_version` from the `build.zig.zon`.
        -- See [anyzig](https://github.com/marler8997/anyzig) for more information.
        zls = {},
      }

      -- Setup manually managed language servers.
      for server_name, server in pairs(servers) do
        server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
        vim.lsp.config[server_name] = server
        vim.lsp.enable(server_name)
      end

      --- List of configs for language servers managed by Mason.
      --- @type table<string, vim.lsp.Config>
      local mason_managed_servers = {
        -- Lua
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = "Replace",
              },
              diagnostics = { disable = { "missing-fields" } },
            },
          },
        },

        -- PHP
        intelephense = {
          init_options = {
            globalStoragePath = intelephense_get_storage_path(),
            licenceKey = intelephense_get_license_key(),
          },
        },

        -- TypeScript

        -- TODO: Consider using [typescript-tools.nvim](https://github.com/pmizio/typescript-tools.nvim)

        -- Alternative TypeScript LSP:
        -- ts_ls = {
        --   init_options = {
        --     preferences = {
        --       quotePreference = "single",
        --       importModuleSpecifierPreference = "project-relative",
        --     },
        --   },
        -- },

        -- vscode TypeScript LSP:
        vtsls = {
          filetypes = {
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
          },
          settings = {
            complete_function_calls = true,
            vtsls = {
              -- tsserver = {
              --   globalPlugins = {
              --     {
              --       name = "@vue/typescript-plugin",
              --       location = mason_get_package_path("vue-language-server", "node_modules/@vue/language-server"),
              --       languages = { "vue" },
              --       configNamespace = "typescript",
              --       enableForWorkspaceTypeScriptVersions = true,
              --     },
              --   },
              -- },
              enableMoveToFileCodeAction = true,
              autoUseWorkspaceTsdk = true,
              experimental = {
                maxInlayHintLength = 30,
                completion = {
                  enableServerSideFuzzyMatch = true,
                },
              },
            },
            typescript = {
              updateImportsOnFileMove = { enabled = "always" },
              suggest = {
                completeFunctionCalls = true,
              },
              inlayHints = {
                enumMemberValues = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                parameterNames = { enabled = "literals" },
                parameterTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                variableTypes = { enabled = false },
              },
            },
          },
          init_options = {
            preferences = {
              quotePreference = "single",
              importModuleSpecifierPreference = "project-relative",
            },
          },
        },

        -- Vue
        vue_ls = {
          init_options = {
            vue = {
              -- Use vue_ls's builtin TypeScript language features.
              hybridMode = false,
            },
          },
        },

        -- JSON
        jsonls = {
          settings = {
            json = {
              schemas = require("schemastore").json.schemas(),
              validate = { enable = true },
            },
          },
        },

        -- YAML
        yamlls = {
          settings = {
            yaml = {
              schemaStore = {
                -- You must disable built-in schemaStore support if you want to use
                -- this plugin and its advanced options like `ignore`.
                enable = false,
                -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
                url = "",
              },
              schemas = require("schemastore").yaml.schemas(),
            },
          },
        },
      }

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
          "vtsls",
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
          -- DAP
          "codelldb",
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
            vim.lsp.config[server_name] = server
          end,
        },
      })
    end,
  },

  -- Formatter
  {
    "stevearc/conform.nvim",
    lazy = false,
    keys = function()
      return {
        {
          "<leader>cf",
          function()
            require("conform").format({ async = true, lsp_fallback = false })
          end,
          mode = "",
          desc = "Format buffer",
        },
      }
    end,
    opts = function()
      local format = require("util.format")
      local opts = {
        notify_on_error = true,
        notify_no_formatters = true,
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
}

-- vim: ts=2 sts=2 sw=2 et
