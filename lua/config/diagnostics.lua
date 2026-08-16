local severity = vim.diagnostic.severity

vim.diagnostic.config {
  virtual_text = {
    prefix = "●",
    spacing = 1,
    source = "if_available",
  },
  signs = {
    text = {
      [severity.ERROR] = "󰅙",
      [severity.WARN] = "󰀪",
      [severity.INFO] = "󰋼",
      [severity.HINT] = "󰌵",
    },
  },
  float = {
    border = "rounded",
    source = true,
    header = "",
  },
  underline = true,
  severity_sort = true,
  update_in_insert = false,
}