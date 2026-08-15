return {
  {
    "echasnovski/mini.icons",
    lazy = false,
    priority = 1000,
    config = function()
      require("mini.icons").setup()
      require("mini.icons").mock_nvim_web_devicons()
      vim.schedule(function()
        require("mini.icons").tweak_lsp_kind()
      end)
    end,
  },
}