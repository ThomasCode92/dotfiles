return {
  {
    "catgoose/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = {
      user_default_options = {
        tailwind = "both",
        tailwind_opts = { update_names = true },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      setup = {
        tailwindcss = function(_, opts)
          opts.settings = {
            tailwindCSS = {
              experimental = {
                classRegex = {
                  { "[cC]lasses\\s*\\+?=\\s*([^;]*);", "['\"`]([^'\"`]*)['\"`]" },
                },
              },
            },
          }
        end,
      },
    },
  },
}
