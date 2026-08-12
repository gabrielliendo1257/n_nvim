local augroup = vim.api.nvim_create_augroup("UserConfig", { clear = true })

vim.api.nvim_create_autocmd("VimResized", {
  group = augroup,
  pattern = "*",
  command = "tabdo wincmd =",
})

vim.api.nvim_create_user_command("PyPackage", function(opts)
  local name = opts.args

  vim.fn.mkdir("src/" .. name, "p")

  local file = "src/" .. name .. "/__init__.py"

  vim.fn.writefile({}, file)

  print("Python package created: " .. name)
end, { nargs = 1 })