return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      vim.lsp.config("basedpyright", {
        settings = {
          basedpyright = {
            venvPath = ".",
            venv = ".venv",
            analysis = {
              inlayHints = {
                variableTypes = true,
                callArgumentNames = true,
                functionReturnTypes = true,
                genericTypes = true,
              },
              autoImportCompletions = true,
              diagnosticMode = "openFilesOnly",
              typeCheckingMode = "strict",
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              indexing = false,
              logLevel = "Error",
            },
          },
        },
      })

      vim.lsp.config("ruff", {
        settings = {
          ruff = {
            lineLength = 120,
          },
        },
      })
    end,
  },
}