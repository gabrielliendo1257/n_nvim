return {
  {
    "saghen/blink.indent",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
    keys = {
      {
        "<leader>ti",
        function()
          local indent = require("blink.indent")
          indent.enable(not indent.is_enabled())
        end,
        desc = "Toggle indent guides",
      },
    },
  },
}