return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  flavour = "macchiato",
  config = function()
    require("catppuccin").setup({
      custom_highlights = function(colors)
        return {
          LineNr = { fg = colors.overlay1 }, -- Normal line numbers
          CursorLineNr = { fg = colors.green }, -- Highlighted line number (current line)
        }
      end,
    })

    vim.cmd.colorscheme("catppuccin")
  end,
}
