return {
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "s", function() require("flash").jump() end, mode = { "n", "x", "o" }, desc = "Flash jump" },
      { "S", function() require("flash").treesitter_search() end, mode = { "n", "x", "o" }, desc = "Flash treesitter search" },
      { "r", function() require("flash").remote() end, mode = "o", desc = "Flash remote" },
      { "R", function() require("flash").treesitter() end, mode = { "o", "x" }, desc = "Flash treesitter" },
      { "<c-s>", function() require("flash").toggle() end, mode = { "i", "c" }, desc = "Toggle flash search" },
    },
  },
}