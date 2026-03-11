return {
  "stevearc/conform.nvim",
  opts = {
    formatters = {
      prettier = {
        prepend_args = function(_, ctx)
          -- Use the Angular parser for .gohtml files
          -- This is the same parser as VS Code uses for .gohtml files
          if vim.fn.fnamemodify(ctx.filename, ":e") == "gohtml" then
            return { "--parser", "angular" }
          end
        end,
      },
    },
  },
}
