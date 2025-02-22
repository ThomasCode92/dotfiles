return {
  "vim-test/vim-test",
  dependencies = {
    "preservim/vimux",
  },
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    vim.keymap.set("n", "<leader>tt", ":TestNearest<CR>", { desc = "Run nearest test (vim-test)" })
    vim.keymap.set("n", "<leader>tT", ":TestFile<CR>", { desc = "Run all tests in file (vim-test)" })
    vim.keymap.set("n", "<leader>ta", ":TestSuite<CR>", { desc = "Run all tests (vim-test)" })
    vim.keymap.set("n", "<leader>tl", ":TestLast<CR>", { desc = "Run last test (vim-test)" })
    vim.keymap.set("n", "<leader>tg", ":TestVisit<CR>", { desc = "Visit test file (vim-test)" })

    vim.cmd("let test#strategy = 'vimux'")
  end,
}
