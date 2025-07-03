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
      tailwindcss = {
        experimental = {
          classRegex = {
            { "[cC]lasses\\s*\\+?=\\s*([^;]*);", "['\"`]([^'\"`]*)['\"`]" },
          },
        },
      },
    },
  },
}
