return {
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonUpdate", "MasonInstall", "MasonUninstall" },
    opts = {},
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    event = "VeryLazy",
    opts = {
      ensure_installed = { "basedpyright", "ruff" },
      automatic_enable = true,
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("lspconfig")
      vim.diagnostic.config {
        virtual_text = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = { border = "rounded", source = true },
      }

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      pcall(function()
        capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)
      end)
      vim.lsp.config("*", { capabilities = capabilities })

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = args.buf, desc = "LSP hover" })
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = args.buf, desc = "Go to definition" })
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = args.buf, desc = "Go to declaration" })
          vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = args.buf, desc = "Go to references" })
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = args.buf, desc = "Go to implementation" })
          vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, { buffer = args.buf, desc = "Go to type definition" })
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = args.buf, desc = "Code action" })
          vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { buffer = args.buf, desc = "Rename symbol" })
          vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { buffer = args.buf, desc = "Previous diagnostic" })
          vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { buffer = args.buf, desc = "Next diagnostic" })
          vim.keymap.set("n", "<leader>cF", vim.diagnostic.open_float, { buffer = args.buf, desc = "Diagnostic float" })
        end,
      })
    end,
  },
}