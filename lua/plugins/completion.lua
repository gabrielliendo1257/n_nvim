return {
  "saghen/blink.cmp",
  version = "1.*",
  event = "InsertEnter",
  dependencies = { "rafamadriz/friendly-snippets" },
  opts = function()
    return {
      keymap = {
        preset = "enter"
      },
      appearance = {
        nerd_font_variant = "mono",
        kind_icons = (function()
          local kinds = {
            "Text", "Method", "Function", "Constructor", "Field", "Variable",
            "Class", "Interface", "Module", "Property", "Unit", "Value", "Enum",
            "Keyword", "Snippet", "Color", "File", "Reference", "Folder",
            "EnumMember", "Constant", "Struct", "Event", "Operator", "TypeParameter",
          }
          local res = {}
          for _, kind in ipairs(kinds) do
            res[kind] = require("mini.icons").get("lsp", kind)
          end
          return res
        end)(),
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
    }
  end,
  -- config = function(_, opts)
  --   require("blink.cmp").setup(opts)
  --
  --   local capabilities = vim.lsp.protocol.make_client_capabilities()
  --   capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)
  --   vim.lsp.config("*", { capabilities = capabilities })
  -- end,
}
