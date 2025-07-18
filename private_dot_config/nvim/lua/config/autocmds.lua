-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- This autocmd listens for the user event 'BlinkCmpAccept', triggered when a completion item is accepted.
-- It ensures that the accepted item comes from the 'copilot' source before processing.
-- The autocmd clears the current line and replaces it with the new text from the completion item.
-- If the new text spans multiple lines, it adjusts the cursor position to the end of the last line.
vim.api.nvim_create_autocmd("User", {
  pattern = "BlinkCmpAccept",
  callback = function(args)
    if args.data.item.source_name ~= "copilot" then
      return
    end

    local item = args.data.item
    local new_text = item.textEdit and item.textEdit.newText or item.label

    local cursor_pos = args.data.context.cursor
    local row = cursor_pos[1] - 1 -- convert to 0-based index

    vim.api.nvim_buf_set_lines(0, row, row + 1, false, {})

    if new_text then
      vim.api.nvim_buf_set_lines(0, row, row, false, vim.split(new_text, "\n"))
    end

    local new_lines = vim.split(new_text, "\n")
    local last_line = new_lines[#new_lines] or ""
    vim.api.nvim_win_set_cursor(0, { row + #new_lines, math.max(0, #last_line - 1) })
  end,
})
