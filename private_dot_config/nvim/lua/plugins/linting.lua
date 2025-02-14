return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      javascript = { "eslint_d" },
      typescript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      typescriptreact = { "eslint_d" },
    }

    local function find_nearest_node_modules_dir()
      local current_dir = vim.fn.expand("%:p:h") -- current buffer dir
      while current_dir ~= "/" do
        if vim.fn.isdirectory(current_dir .. "/node_modules") == 1 then
          return current_dir
        end
        current_dir = vim.fn.fnamemodify(current_dir, ":h")
      end
      return nil
    end

    local function get_root_dir()
      local original_cwd = vim.fn.getcwd()
      local node_modules_dir = find_nearest_node_modules_dir()
      return node_modules_dir or original_cwd
    end

    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = function()
        local root = get_root_dir()
        lint.try_lint(nil, { cwd = root })
      end,
    })

    vim.keymap.set("n", "<leader>l", function()
      local root = get_root_dir()
      lint.try_lint(nil, { cwd = root })
    end, { desc = "Trigger linting for current file" })
  end,
}
