--- The setup is based on the following YouTube video by Sam Natale: https://www.youtube.com/watch?v=AUgbOckKxzw&t=15s
--- See GitHub for full configuration: https://github.com/smnatale/neovim-for-web-devs/blob/EP5/lua/plugins/ai.lua
--- Official documentation: https://github.com/olimorris/codecompanion.nvim

return {
  {
    "olimorris/codecompanion.nvim",
    event = "VeryLazy",
    opts = {},
    dependencies = {
      "j-hui/fidget.nvim",
    },
    config = function(_, opts)
      require("codecompanion").setup(opts)

      local progress = require("fidget.progress")
      local handles = {}
      local group = vim.api.nvim_create_augroup("CodeCompanionFidget", {})

      vim.api.nvim_create_autocmd("User", {
        pattern = "CodeCompanionRequestStarted",
        group = group,
        callback = function(e)
          handles[e.data.id] = progress.handle.create({
            title = "CodeCompanion",
            message = "Thinking...",
            lsp_client = { name = e.data.adapter.formatted_name },
          })
        end,
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "CodeCompanionRequestFinished",
        group = group,
        callback = function(e)
          local h = handles[e.data.id]
          if h then
            h.message = e.data.status == "success" and "Done" or "Failed"
            h:finish()
            handles[e.data.id] = nil
          end
        end,
      })
    end,
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    lazy = true,
    optional = true,
    ft = function(_, ft)
      vim.list_extend(ft, { "codecompanion" })
    end,
    opts = function(_, opts)
      opts.file_types = vim.list_extend(opts.file_types or {}, { "codecompanion" })
    end,
  },
}
