return {
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff_format" },
        java = { "google-java-format" },
        javascript = { "biome" },
        typescript = { "biome" },
        json = { "biome" },
        jsonc = { "biome" },
        css = { "biome" },
        html = { "biome" },
      },
      formatters = {
        ["google-java-format"] = {
          command = "google-java-format",
          args = { "-" },
        },
      },
      format_on_save = false,
    },
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({ async = true, lsp_format = "fallback" })
        end,
        desc = "Format buffer (conform)",
      },
    },
  },
}