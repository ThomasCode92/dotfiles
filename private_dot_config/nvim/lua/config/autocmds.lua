local autocmd = vim.api.nvim_create_autocmd

-- Highlight on yank, this will highlight the text
-- that was yanked for a short duration
autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 1000 })
    end,
})
