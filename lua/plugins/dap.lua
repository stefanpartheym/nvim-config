return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
      "williamboman/mason.nvim",
      "stevearc/overseer.nvim",
    },
    config = function()
      local dap = require("dap")
      local ui = require("dapui")
      local overseer = require("overseer")

      require("dapui").setup()
      require("nvim-dap-virtual-text").setup({})
      overseer.enable_dap()

      -- TODO: Consider using the following default config for zig, to be able
      -- to select an executable from the current directory to debug.
      --
      -- ```lua
      -- dap.configurations.zig = {
      --   {
      --     name = "Zig debug",
      --     type = "lldb",
      --     request = "launch",
      --     program = function()
      --       local co = coroutine.running()
      --       local cb = nil
      --       if co then
      --         cb = function(item)
      --           coroutine.resume(co, item)
      --         end
      --       end
      --       if cb then
      --         cb = vim.schedule_wrap(cb)
      --         vim.ui.select(vim.fn.glob(vim.fn.getcwd() .. "/zig-out/**/*", false, true), {
      --           prompt = "Select executable",
      --           kind = "file",
      --           format_item = function(item)
      --             return vim.fn.fnamemodify(item, ":t")
      --           end,
      --         }, cb)
      --       end
      --       return coroutine.yield()
      --     end,
      --     cwd = "${workspaceFolder}",
      --     stopOnEntry = false,
      --     args = {},
      --   },
      -- }
      -- ```

      dap.adapters.lldb = {
        type = "executable",
        command = vim.fn.exepath("codelldb"),
        name = "lldb",
      }

      vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticError", numhl = "DiagnosticError" })
      vim.fn.sign_define(
        "DapBreakpointCondition",
        { text = "", texthl = "DiagnosticError", numhl = "DiagnosticError" }
      )
      vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "DiagnosticWarn", numhl = "DiagnosticWarn" })
      vim.fn.sign_define("DapLogPoint", { text = "", texthl = "DiagnosticInfo", numhl = "DiagnosticInfo" })
      vim.fn.sign_define(
        "DapStopped",
        { text = "", texthl = "DiagnosticOk", linehl = "DiagnosticOk", numhl = "DiagnosticOk" }
      )

      dap.listeners.before.attach.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        ui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        ui.close()
      end
    end,
    keys = function()
      local dap = require("dap")
      return {
        { "<leader>db", dap.toggle_breakpoint, desc = "Toggle breakpoint" },
        {
          "<leader>dB",
          function()
            dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
          end,
          desc = "Set conditional breakpoint",
        },
        { "<leader>dc", dap.run_to_cursor, desc = "Run to cursor" },
        { "<leader>dP", dap.pause, desc = "Pause" },
        { "<leader>dt", dap.terminate, desc = "Terminate" },
        {
          "<leader>d?",
          function()
            require("dapui").eval(nil, { enter = true })
          end,
          mode = { "n", "v" },
          desc = "Eval expression",
        },
        { "<F9>", dap.continue, desc = "Start/Continue" },
        { "<F7>", dap.step_into, desc = "Step into" },
        { "<F8>", dap.step_over, desc = "Step over" },
        { "<S-F7>", dap.step_out, desc = "Step out" },
        { "<S-F8>", dap.step_back, desc = "Step back" },
      }
    end,
  },
}
