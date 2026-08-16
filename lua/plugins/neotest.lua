return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-nio/nvim-nio",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "rcasia/neotest-java",
    },
    keys = {
      { "<leader>tr", function() require("neotest").run.run() end, desc = "Run test" },
      { "<leader>tR", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run tests file" },
      { "<leader>ts", function() require("neotest").run.stop() end, desc = "Stop tests" },
      { "<leader>to", function() require("neotest").output.open() end, desc = "Test output" },
      { "<leader>tx", function() require("neotest").summary.toggle() end, desc = "Test summary" },
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-java")({}),
        },
      })
    end,
  },
}