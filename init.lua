local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"


vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

if not vim.uv.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  }
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { import = "plugins" },
  { import = "plugins.languages" },
}, require "config.lazy")

require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.diagnostics")
