-- inlay hints for typescript
local inlay_hints = {
  parameterNames = { enabled = "all" },
  suppressWhenTypeMatchesName = false,
}

return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      vtsls = {
        settings = {
          typescript = { inlayHints = inlay_hints },
        },
      },
      cssls = {},
      emmet_language_server = {},
    },
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
}
