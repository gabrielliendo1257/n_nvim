return {
  "saghen/blink.cmp",
  version = "1.*",
  event = "InsertEnter",
  dependencies = { "rafamadriz/friendly-snippets" },
  opts = {
    keymap = {
      preset = "enter"
    },
    appearance = {
      nerd_font_variant = "mono",
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
      providers = {
        lsp = {
          min_keyword_length = 0,
          score_offset = 3,
          name = "LSP",
          module = "blink.cmp.sources.lsp",
          fallbacks = {},
        },
        path = {
          min_keyword_length = 0,
          score_offset = 2,
        },
        buffer = {
          min_keyword_length = 0,
          score_offset = 1
        }
      },
    },
    completion = {
      accept = {
        auto_brackets = {
          enabled = true,
        },
      },
      menu = {
        border = "single",
        draw = {
          columns = {
            { "label", gap = 10 },
            { "kind_icon", gap = 1 },
            { "kind" },
            { "label_description" },
          },
          gap = 1,
          tressitter = { "lsp" },
        },
      },
      list = {
        selection = { preselect = false, auto_insert = false },
      },
    },
  },
  -- config = function(_, opts)
  --   require("blink.cmp").setup(opts)
  --
  --   local capabilities = vim.lsp.protocol.make_client_capabilities()
  --   capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)
  --   vim.lsp.config("*", { capabilities = capabilities })
  -- end,
}
