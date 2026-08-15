return {
  {
    "kdheepak/lazygit.nvim",
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterRef",
    },
    keys = {
      { "<leader>gg", "<cmd>LazyGit<CR>", desc = "Lazygit" },
      { "<leader>gl", "<cmd>LazyGitFilter<CR>", desc = "Lazygit (files changed)" },
      { "<leader>gf", "<cmd>LazyGitCurrentFile<CR>", desc = "Lazygit (current file)" },
    },
  },
}