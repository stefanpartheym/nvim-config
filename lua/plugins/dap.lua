return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
      "williamboman/mason.nvim",
    },
    config = function()
      local dap = require("dap")
      local ui = require("dapui")

      require("dapui").setup()
      require("nvim-dap-virtual-text").setup({})

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
        { "<leader>dc", dap.run_to_cursor, desc = "Run to cursor" },
        {
          "<leader>d?",
          function()
            require("dapui").eval(nil, { enter = true })
          end,
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
