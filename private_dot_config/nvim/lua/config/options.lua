-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Native inline completions don't support being shown as regular completions
vim.g.ai_cmp = false

local shell = vim.fn.exepath("fish")
if shell == "" then
  shell = vim.fn.exepath("bash")
end

if shell ~= "" then
  vim.opt.shell = shell
end
