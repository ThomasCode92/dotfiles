return {
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
      "TmuxNavigatorProcessList",
    },
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
    {
      "catgoose/nvim-colorizer.lua",
      event = "BufReadPre",
      config = function()
        require("colorizer").setup({
          filetypes = { "css", "typescriptreact", html = { mode = "foreground" } },
          user_default_options = {
            tailwind = "both",
            tailwind_opts = { update_names = true },
          },
        })
      end,
    },
  },
  { "m4xshen/hardtime.nvim", event = "BufReadPre", opts = {} }, -- break bad habits, enforce vim motions
  { "xvzc/chezmoi.nvim", init = function() end }, -- don't run chezmoi edit on file enter, see docs: https://www.lazyvim.org/extras/util/chezmoi#chezmoinvim
  { "LazyVim/LazyVim", opts = { colorscheme = "catppuccin" } },
}
