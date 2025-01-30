vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.g.mapleader = " "

require("config.lazy")

vim.cmd[[colorscheme tokyonight]]

-- telescoop
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })

-- treesitter
local config = require('nvim-treesitter.configs')
config.setup({
  ensure_installed = { "lua", "javascript" },
  highlight = { enable = true },
  indent = { enable = true },
})

-- neo tree
vim.keymap.set('n', '<leader>n', ':Neotree filesystem reveal right<CR>')

