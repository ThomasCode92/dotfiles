return {
  {
    -- configure catppuccin colorscheme
    "catppuccin/nvim",
    opts = {
      color_overrides = {
        -- make 'mocha' colorscheme more dark
        mocha = { base = "#000000", mantle = "#010101", crust = "#020202" },
      },
    },
  },
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
  },
  { "m4xshen/hardtime.nvim", event = "BufReadPre", opts = {} }, -- break bad habits, enforce vim motions
  { "xvzc/chezmoi.nvim", init = function() end }, -- don't run chezmoi edit on file enter, see docs: https://www.lazyvim.org/extras/util/chezmoi#chezmoinvim
  { "LazyVim/LazyVim", opts = { colorscheme = "catppuccin" } },
}
