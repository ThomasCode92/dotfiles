return {
  -- configure catppuccin colorscheme
  {
    "catppuccin/nvim",
    opts = {
      color_overrides = {
        -- make 'mocha' colorscheme more dark
        mocha = {
          base = "#000000", -- background color
          mantle = "#010101", -- file explorer background
          crust = "#020202", -- top bar background
        },
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "catppuccin" },
  },
}
