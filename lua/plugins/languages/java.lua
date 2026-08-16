return {
  {
    "neovim/nvim-lspconfig",
    opts = function()
      local lombok = vim.fn.expand("~/.local/share/java/lombok.jar")
      if vim.fn.filereadable(lombok) == 1 then
        vim.env.JDTLS_JVM_ARGS = (vim.env.JDTLS_JVM_ARGS or "") .. " -javaagent:" .. lombok
      end

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