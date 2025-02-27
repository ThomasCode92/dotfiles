-- More information about classRegex:
-- https://github.com/luckasRanarison/tailwind-tools.nvim/issues/58#issuecomment-2480253763

return {
  "luckasRanarison/tailwind-tools.nvim",
  name = "tailwind-tools",
  build = ":UpdateRemotePlugins",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-telescope/telescope.nvim", -- optional
    "neovim/nvim-lspconfig", -- optional
  },
  opts = {
    server = {
      settings = {
        experimental = {
          classRegex = {
            { "[cC]lasses\\s*\\+?=\\s*([^;]*);", "['\"`]([^'\"`]*)['\"`]" },
          },
        },
      },
    },
  },
}
