return {
  {
    "neovim/nvim-lspconfig",
    dependencies = { "JavaHello/spring-boot.nvim" },
    opts = function()
      local lombok = vim.fn.expand "~/.local/share/java/lombok.jar"
      local spring_boot = require "spring_boot"
      if vim.fn.filereadable(lombok) == 1 then
        vim.env.JDTLS_JVM_ARGS = (vim.env.JDTLS_JVM_ARGS or "") .. " -javaagent:" .. lombok
      end

      vim.lsp.config("jdtls", {
        init_options = {
          bundles = spring_boot.java_extensions(),
        },
        on_attach = function(client)
          client.server_capabilities.documentFormattingProvider = false
          vim.keymap.set("n", "<leader>co", function()
            vim.lsp.buf.code_action { context = { only = { "source.organizeImports" } } }
          end, { buffer = true, desc = "Java: organize imports" })
        end,
      })
    end,
  },
}
