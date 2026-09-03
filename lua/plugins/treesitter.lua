return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("nvim-treesitter").setup()
      local wanted = {
        "lua",
        "vim",
        "vimdoc",
        "bash",
        "python",
        "rust",
        "java",
        "yaml",
        "javascript",
        "css",
        "html",
        "json",
      }
      local installed = require("nvim-treesitter").get_installed "parsers"
      local missing = vim.tbl_filter(function(p)
        return not vim.list_contains(installed, p)
      end, wanted)
      if #missing > 0 then
        require("nvim-treesitter").install(missing)
      end

      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          local ok, lang = pcall(vim.treesitter.language.get_lang, vim.bo[args.buf].filetype)
          if ok and lang and #vim.api.nvim_get_runtime_file("parser/" .. lang .. ".so", false) > 0 then
            pcall(vim.treesitter.start, args.buf, lang)
          end
        end,
      })
    end,
  },
}
