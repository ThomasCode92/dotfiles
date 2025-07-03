--- This is taken from a PR of the LazyVim Project, this can be used to add Avante to the LazyVim setup
--- it can be removed when the PR is merged. It uses Copilot as the default provider, instead of Claude.
--- PR: https://github.com/LazyVim/LazyVim/pull/4440

return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    opts = {
      -- Default configuration
      hints = { enabled = false },

      ---@alias AvanteProvider "claude" | "openai" | "azure" | "gemini" | "cohere" | "copilot" | string
      provider = "copilot", -- Recommend using Claude
      auto_suggestions_provider = "copilot", -- Since auto-suggestions are a high-frequency operation and therefore expensive, it is recommended to specify an inexpensive provider or even a free provider: copilot

      -- File selector configuration
      --- @alias FileSelectorProvider "native" | "fzf" | "mini.pick" | "snacks" | "telescope" | string
      file_selector = {
        provider = "snacks",
        provider_opts = {},
      },
    },
    build = LazyVim.is_win() and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" or "make",
  },
  -- {
  --   "MeanderingProgrammer/render-markdown.nvim",
  --   lazy = true,
  --   optional = true,
  --   ft = function(_, ft)
  --     vim.list_extend(ft, { "Avante" })
  --   end,
  --   opts = function(_, opts)
  --     opts.file_types = vim.list_extend(opts.file_types or {}, { "Avante" })
  --   end,
  -- },
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<leader>a", group = "ai" },
      },
    },
  },
}
