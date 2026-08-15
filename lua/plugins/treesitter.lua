return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("nvim-treesitter").setup()
      local wanted = { "lua", "vim", "vimdoc", "bash", "python", "rust" }
      local installed = require("nvim-treesitter").get_installed("parsers")
      local missing = vim.tbl_filter(function(p)
        return not vim.list_contains(installed, p)
      end, wanted)
      if #missing > 0 then
        require("nvim-treesitter").install(missing)
      end

      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          if pcall(vim.treesitter.get_parser, args.buf) then
            vim.treesitter.start(args.buf)
          end
        end,
      })
    end,
  },
}