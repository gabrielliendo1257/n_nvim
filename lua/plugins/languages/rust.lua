return {
  {
    "neovim/nvim-lspconfig",
    opts = function()
      vim.lsp.config("rust_analyzer", {
        settings = {
          ["rust-analyzer"] = {
            checkOnSave = true,
            procMacro = {
              enable = true,
            },
            imports = {
              granularity = {
                group = "module",
              },
              prefix = "self",
            },
            inlayHints = {
              typeHints = {
                enable = true,
                hideClosureInitialization = false,
              },
              parameterHints = {
                enable = true,
              },
              renderColons = true,
            },
          },
        },
      })
    end,
  },
}