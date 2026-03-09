local keymap = vim.keymap.set
local vscode = require('vscode')

keymap({ "n", "v" }, "<leader>h", function() vscode.action('workbench.action.focusLeftGroup') end)
keymap({ "n", "v" }, "<leader>j", function() vscode.action('workbench.action.focusBelowGroup') end)
keymap({ "n", "v" }, "<leader>k", function() vscode.action('workbench.action.focusAboveGroup') end)
keymap({ "n", "v" }, "<leader>l", function() vscode.action('workbench.action.focusRightGroup') end)

keymap({ "n", "v" }, "[b", function() vscode.action('workbench.action.previousEditor') end)
keymap({ "n", "v" }, "]b", function() vscode.action('workbench.action.nextEditor') end)

keymap({ "n", "v" }, "[e", function() vscode.action('editor.action.marker.prev') end)
keymap({ "n", "v" }, "]e", function() vscode.action('editor.action.marker.next') end)

keymap('n', '<leader>ca', function() vscode.action('editor.action.quickFix') end)
keymap('n', '<leader>ff', function() vscode.action('workbench.action.quickOpen') end)

keymap('n', '<leader>e', function() vscode.action('workbench.files.action.focusFilesExplorer') end)
