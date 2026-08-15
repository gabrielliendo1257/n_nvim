return {
  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    config = function()
      local dap = require("dap")
      local map = vim.keymap.set
      map("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
      map("n", "<leader>dB", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end, { desc = "Conditional breakpoint" })
      map("n", "<leader>dc", dap.continue, { desc = "Continue" })
      map("n", "<leader>do", dap.step_over, { desc = "Step over" })
      map("n", "<leader>di", dap.step_into, { desc = "Step into" })
      map("n", "<leader>du", dap.step_out, { desc = "Step out" })
      map("n", "<leader>dp", dap.pause, { desc = "Pause" })
      map("n", "<leader>dr", function()
        dap.repl.toggle()
      end, { desc = "Toggle REPL" })
      map("n", "<leader>dl", dap.run_last, { desc = "Run last" })
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    event = "VeryLazy",
    config = function()
      local dap, dapui = require("dap"), require("dapui")
      dapui.setup()
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
      vim.keymap.set("n", "<leader>dt", function()
        dapui.toggle()
      end, { desc = "Toggle DAP UI" })
    end,
  },
  {
    "mfussenegger/nvim-dap-python",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      local debugpy = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
      require("dap-python").setup(debugpy)
    end,
  },
}