return {
  "ravitemer/mcphub.nvim",
  build = "npm install -g mcp-hub@latest", -- Installs `mcp-hub` node binary globally
  event = "VeryLazy",
  config = function()
    require("mcphub").setup({
      extensions = {
        avante = {
          make_slash_commands = true, -- make /slash commands from MCP server prompts
        },
      },
    })
  end,
}
