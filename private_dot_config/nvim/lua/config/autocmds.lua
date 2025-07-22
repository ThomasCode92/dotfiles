-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.api.nvim_create_autocmd("User", {
  pattern = "BlinkCmpAccept",
  callback = function(args)
    local item = args.data.item
    local new_text = item.textEdit and item.textEdit.newText or item.label

    if item.source_name ~= "copilot" or new_text:find("\n") then
      return -- Only handle single-line Copilot suggestions
    end

    -- Replace current line & place cursor at end of new line
    local row = args.data.context.cursor[1] - 1 -- 0-based index
    vim.api.nvim_buf_set_lines(0, row, row + 1, false, {})
    vim.api.nvim_buf_set_lines(0, row, row, false, { new_text })
    vim.api.nvim_win_set_cursor(0, { row + 1, #new_text })
  end,
})
