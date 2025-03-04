return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")
    local TIMEOUT_MS = 5000

    -- Add commands to enable/disable autoformat-on-save
    vim.api.nvim_create_user_command("FormatDisable", function(args)
      if args.bang then
        vim.b.disable_autoformat = true -- FormatDisable! will disable formatting just for this buffer
      else
        vim.g.disable_autoformat = true
      end
    end, { desc = "Disable autoformat-on-save", bang = true })
    vim.api.nvim_create_user_command("FormatEnable", function()
      vim.b.disable_autoformat = false
      vim.g.disable_autoformat = false
    end, { desc = "Re-enable autoformat-on-save" })

    conform.setup({
      formatters_by_ft = {
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        markdown = { "prettier" },
        lua = { "stylua" },
      },
      format_on_save = function(bufnr)
        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          print("format on save disabled")
          return
        end

        -- Sort imports before formatting
        vim.lsp.buf.code_action({
          context = { only = { "source.organizeImports" } },
          apply = true,
        })
        vim.wait(100) -- NOTE: wait for the code action to finish

        return { lsp_fallback = true, async = false, timeout_ms = TIMEOUT_MS }
      end,
    })

    -- set keymaps
    local keymap = vim.keymap -- for consiseness

    keymap.set({ "n", "v" }, "<leader>mp", function()
      conform.format({ lsp_fallback = true, async = false, timeout_ms = TIMEOUT_MS })
    end, { desc = "Format file or range (in visual mode)" })
    keymap.set("n", "<leader>md", "<cmd>FormatDisable<cr>", { desc = "Disable autoformat-on-save" })
    keymap.set("n", "<leader>me", "<cmd>FormatEnable<cr>", { desc = "Re-enable autoformat-on-save" })
  end,
}
