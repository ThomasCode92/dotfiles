return {
  "CopilotC-Nvim/CopilotChat.nvim",
  dependencies = {
    { "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
    { "nvim-lua/plenary.nvim", branch = "master" },
  },
  build = "make tiktoken",
  opts = {
    -- See Configuration section for options
  },
  keys = {
    { "<leader>zc", ":CopilotChat<CR>", mode = "n", desc = "Chat with Copilot" }, -- Open Copilot Chat
    { "<leader>ze", ":CopilotChatExplain<CR>", mode = "v", desc = "Explain code" }, -- Explain code with Copilot
    { "<leader>zr", ":CopilotChatReview<CR>", mode = "v", desc = "Review code" }, -- Review code with Copilot
    { "<leader>zf", ":CopilotChatFix<CR>", mode = "v", desc = "Fix code issues" }, -- Fix code with Copilot
    { "<leader>zo", ":CopilotChatOptimize<CR>", mode = "v", desc = "Optimize code" }, -- Optimize code with Copilot
    { "<leader>zd", ":CopilotChatDocs<CR>", mode = "v", desc = "Generate docs" }, -- Generate docs with Copilot
    { "<leader>zt", ":CopilotChatTests<CR>", mode = "v", desc = "Generate tests" }, -- Generate tests with Copilot
    { "<leader>zm", ":CopilotChatCommit<CR>", mode = "n", desc = "Generate Commit Message" }, -- Generate commit message with Copilot
  },
}
