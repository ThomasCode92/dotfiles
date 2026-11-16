return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
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
