-- inlay hints for typescript
local inlay_hints = {
  parameterNames = { enabled = "all" },
  suppressWhenTypeMatchesName = false,
}

return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      astro = {
        settings = {
          typescript = { inlayHints = inlay_hints },
        },
      },
    },
  },
}
