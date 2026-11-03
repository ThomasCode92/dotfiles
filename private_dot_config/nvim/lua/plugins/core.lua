return {
  {
    "christoomey/vim-tmux-navigator",
    init = function()
      vim.g.tmux_navigator_no_mappings = 1
    end,
    keys = {
      { "<c-h>", "<cmd>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd>TmuxNavigatePrevious<cr>" },
    },
  },
  {
    "catgoose/nvim-colorizer.lua",
    event = "BufReadPre",
    config = function()
      require("colorizer").setup({
        filetypes = { "css", "typescriptreact", html = { mode = "foreground" } },
        user_default_options = { tailwind = "both", tailwind_opts = { update_names = true } },
      })
    end,
  },
  { "m4xshen/hardtime.nvim", event = "BufReadPre", opts = {} }, -- break bad habits, enforce vim motions
  { "xvzc/chezmoi.nvim", init = function() end }, -- don't run chezmoi edit on file enter, see docs: https://www.lazyvim.org/extras/util/chezmoi#chezmoinvim
  { "LazyVim/LazyVim", opts = { colorscheme = "catppuccin-mocha" } },
}
