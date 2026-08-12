return {
  {
    "tamton-aquib/staline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    opts = {
      defaults = {
        true_colors = true,
        font_active = "bold",
        line_column = "[%l/%L] :%c %p%% ",
      },
      mode_colors = {
        n = "#2bbb4f",
        i = "#986fec",
        c = "#e27d60",
        v = "#4799eb",
        R = "#e27d60",
        t = "#4799eb",
      },
      sections = {
        left = { "- ", "-mode", "left_sep_double", " ", "branch", " ", "file_name" },
        mid = { "lsp", " ", "lsp_name" },
        right = { "right_sep_double", "-line_column" },
      },
      lsp_symbols = {
        Error = " E ",
        Info = " I ",
        Warn = " W ",
        Hint = " H ",
      },
    },
    config = function(_, opts)
      require("staline").setup(opts)
      vim.opt.statusline = "%!v:lua.require('staline').staline()"
    end,
  },
}