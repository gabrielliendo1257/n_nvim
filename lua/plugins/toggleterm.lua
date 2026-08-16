return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
      { "<leader>t", "<cmd>ToggleTerm<CR>", desc = "Toggle terminal" },
      { "<leader>tf", "<cmd>ToggleTerm direction=float<CR>", desc = "Terminal flotante" },
      { "<leader>tl", "<cmd>lua _G._lazygit_toggle()<CR>", desc = "Lazygit (flotante)" },
    },
    opts = {
      size = 15,
      direction = "horizontal",
      shade_terminals = true,
      shading_factor = 2,
      open_mapping = false,
      float_ops = {
        border = "curved",
      },
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)

      local Terminal = require("toggleterm.terminal").Terminal
      local lazygit = Terminal:new({
        id = 2,
        cmd = "lazygit",
        direction = "float",
        hidden = true,
      })
      _G._lazygit_toggle = function()
        lazygit:toggle()
      end
    end,
  },
}