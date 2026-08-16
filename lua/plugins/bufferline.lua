local function listed_bufs()
  return vim.fn.getbufinfo({ buflisted = 1 })
end

local function close_current()
  local current = vim.api.nvim_get_current_buf()
  if #listed_bufs() <= 1 then
    vim.cmd("enew")
  end
  pcall(vim.api.nvim_buf_delete, current, { force = false })
end

local function close_all()
  local current = vim.api.nvim_get_current_buf()
  for _, b in ipairs(listed_bufs()) do
    if b.bufnr ~= current then
      pcall(vim.api.nvim_buf_delete, b.bufnr, { force = false })
    end
  end
  vim.cmd("enew")
  pcall(vim.api.nvim_buf_delete, current, { force = false })
end

return {
  {
    "akinsho/bufferline.nvim",
    version = "*",
    event = "VeryLazy",
    opts = {
      options = {
        separator_style = "slant",
        show_buffer_close_icons = false,
        show_close_icon = false,
        diagnostics = "nvim_lsp",
        offsets = {
          {
            filetype = "neo-tree",
            text = "File Explorer",
            highlight = "Directory",
            separator = true,
          },
        },
      },
    },
    keys = {
      { "<Tab>", "<cmd>BufferLineCycleNext<CR>", desc = "Next buffer" },
      { "<S-Tab>", "<cmd>BufferLineCyclePrev<CR>", desc = "Previous buffer" },
      { "]b", "<cmd>BufferLineCycleNext<CR>", desc = "Next buffer" },
      { "[b", "<cmd>BufferLineCyclePrev<CR>", desc = "Previous buffer" },
      { "<leader>x", close_current, desc = "Close current buffer" },
      { "<leader>bo", "<cmd>BufferLineCloseOthers<CR>", desc = "Close other buffers" },
      { "<leader>ba", close_all, desc = "Close all buffers" },
      { "<leader>bc", "<cmd>BufferLinePickClose<CR>", desc = "Pick buffer to close" },
    },
  },
}