return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      tailwindcss = {
        settings = {
          tailwindCSS = {
            experimental = {
              -- This enables IntelliSense for Tailwind classes stored in variables like:
              -- const classes = "bg-red-500 text-white"
              -- let class = "flex items-center"
              classRegex = {
                { "[cC]lasses\\s*\\+?=\\s*([^;]*);", "['\"`]([^'\"`]*)['\"`]" },
                { "[cC]lass\\s*\\+?=\\s*([^;]*);", "['\"`]([^'\"`]*)['\"`]" },
              },
            },
          },
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
  },
}
