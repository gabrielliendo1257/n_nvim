return {
  {
    "saghen/blink.cmp",
    version = "1.*",
    event = "VeryLazy",
    dependencies = { "rafamadriz/friendly-snippets" },
    opts = {
      keymap = { preset = "default" },
      appearance = {
        nerd_font_variant = "mono",
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
    },
    config = function(_, opts)
      require("blink.cmp").setup(opts)

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)
      vim.lsp.config("*", { capabilities = capabilities })
    end,
  },
}