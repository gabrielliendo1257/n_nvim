local function listed_bufs()
  return vim.fn.getbufinfo({ buflisted = 1 })
end

local function switch_away(current)
  local switched = false
  for _, b in ipairs(listed_bufs()) do
    if b.bufnr ~= current then
      switched = pcall(vim.cmd, "buffer " .. b.bufnr)
      if switched then
        break
      end
    end
  end
  if not switched then
    pcall(vim.cmd, "enew")
  end
end

local function close_current()
  local current = vim.api.nvim_get_current_buf()
  switch_away(current)
  pcall(vim.cmd, "bdelete " .. current)
end

local function close_all()
  local current = vim.api.nvim_get_current_buf()
  for _, b in ipairs(listed_bufs()) do
    if b.bufnr ~= current then
      pcall(vim.cmd, "bdelete " .. b.bufnr)
    end
  end
  switch_away(current)
  pcall(vim.cmd, "bdelete " .. current)
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