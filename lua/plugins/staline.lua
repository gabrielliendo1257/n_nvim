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
    -- config = function(_, opts)
    --   require("staline").setup(opts)
    --   vim.opt.statusline = "%!v:lua.require('staline').staline()"
    -- end,
    config = {

	sections = {
		left = {
			' ', 'right_sep_double', '-mode', 'left_sep_double', ' ',
			'right_sep', '-file_name', 'left_sep', ' ',
			'right_sep_double', '-branch', 'left_sep_double', ' ',
		},
		mid  = {'lsp'},
		right= {
			'right_sep', '-cool_symbol', 'left_sep', ' ',
			'right_sep', '- ', '-lsp_name', '- ', 'left_sep',
			'right_sep_double', '-line_column', 'left_sep_double', ' ',
		}
	},

	defaults={
		fg = "#986fec",
		cool_symbol = "  ",
		left_separator = "",
		right_separator = "",
		-- line_column = "%l:%c [%L]",
		true_colors = true,
		line_column = "[%l:%c] 並%p%% "
		-- font_active = "bold"
	},
	mode_colors = {
		n  = "#181a23",
		i  = "#181a23",
		ic = "#181a23",
		c  = "#181a23",
		v  = "#181a23"       -- etc
	}
}
  },
}
