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
    -- Configure 'cspell', make sure to install 'cspell-lsp' globally
    vim.lsp.enable("cspell_ls"),
    vim.lsp.config("cspell_ls", {
      cmd = { "cspell-lsp", "--stdio" },
      root_markers = { ".git" },
    }),
    setup = {
      -- Configure Tailwind CSS LSP to recognize class names in variable assignments
      -- This enables IntelliSense for Tailwind classes stored in variables like:
      -- const classes = "bg-red-500 text-white"
      -- let class = "flex items-center"
      tailwindcss = function(_, opts)
        opts.settings = {
          tailwindCSS = {
            experimental = {
              classRegex = {
                { "[cC]lasses\\s*\\+?=\\s*([^;]*);", "['\"`]([^'\"`]*)['\"`]" },
                { "[cC]lass\\s*\\+?=\\s*([^;]*);", "['\"`]([^'\"`]*)['\"`]" },
              },
            },
          },
        }
      end,
    },
  },
}
