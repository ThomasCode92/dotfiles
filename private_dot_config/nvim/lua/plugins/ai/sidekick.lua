return {
  "folke/sidekick.nvim",
  opts = {
    cli = {
      ---@class sidekick.cli.Mux
      ---@field backend? "tmux"|"zellij" Multiplexer backend to persist CLI sessions
      mux = { backend = "tmux", enabled = true },
    },
  },
  -- stylua: ignore
  keys = {
    {
      "<leader>ac",
      function() require("sidekick.cli").toggle({ name = "opencode", focus = true }) end,
      desc = "Sidekick Opencode Toggle",
    },
  },
}
