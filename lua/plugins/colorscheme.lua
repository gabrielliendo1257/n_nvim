return {
  {
    "Kopihue/one-dark-pro-max",
    name = "one-dark-pro-max",
    lazy = false,
    priority = 1000,
    opts = {
      transparency = false,
      bold = true,
      italic = true,
    },
    config = function(_, opts)
      require("one-dark-pro-max").setup(opts)
      require("config.theme").apply()
    end,
  },
}