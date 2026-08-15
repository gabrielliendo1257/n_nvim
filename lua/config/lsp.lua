local M = {}

local function has_client()
  return #vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() }) > 0
end

local function lsp_action(fn)
  return function(...)
    if not has_client() then
      vim.notify("No hay servidor LSP conectado a este buffer", vim.log.levels.WARN)
      return
    end
    fn(...)
  end
end

function M.setup()
  local map = vim.keymap.set

  map("n", "K", lsp_action(vim.lsp.buf.hover), { desc = "LSP hover" })
  map("n", "gd", lsp_action(vim.lsp.buf.definition), { desc = "Go to definition" })
  map("n", "gD", lsp_action(vim.lsp.buf.declaration), { desc = "Go to declaration" })
  map("n", "gy", lsp_action(vim.lsp.buf.type_definition), { desc = "Go to type definition" })
  map("n", "<leader>ca", lsp_action(vim.lsp.buf.code_action), { desc = "Code action" })

  map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Diagnostic float" })
  map("n", "<leader>cx", function()
    vim.diagnostic.setqflist({ open = true })
  end, { desc = "Diagnostics en quickfix" })
  map("n", "<leader>cX", function()
    vim.diagnostic.setloclist({ open = true })
  end, { desc = "Diagnostics del buffer en loclist" })

  map("n", "<leader>cs", "<cmd>LspStart<CR>", { desc = "Iniciar servidor LSP" })
  map("n", "<leader>cS", "<cmd>LspRestart<CR>", { desc = "Reiniciar servidor LSP" })
  map("n", "<leader>ci", "<cmd>LspInfo<CR>", { desc = "Informacion LSP" })
end

return M