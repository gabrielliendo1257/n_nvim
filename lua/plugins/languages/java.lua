return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      vim.lsp.config("jdtls", {
        on_attach = function(client)
          client.server_capabilities.documentFormattingProvider = false
          vim.keymap.set("n", "<leader>co", function()
            vim.lsp.buf.code_action({ context = { only = { "source.organizeImports" } } })
          end, { buffer = true, desc = "Java: organize imports" })
        end,
      })
    end,
  },
}