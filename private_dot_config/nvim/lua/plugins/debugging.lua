-- Debug adapter configuration inspired by StevanFreeborn's Neovim setup
-- Source: https://github.com/StevanFreeborn/nvim-config/blob/main/lua/plugins/debugging.lua

return {
  {
    "mfussenegger/nvim-dap",
    opts = function()
      local dap = require("dap")

      local projectFolder = ""
      local file = vim.fn.expand("%:p")
      local cwd = vim.fn.getcwd():gsub([[-]], "%%-")

      -- Path setup for JavaScript debug adapter installed via Mason
      local dataPath = vim.fn.stdpath("data") -- Neovim's standard data directory (e.g., ~/.local/share/nvim on Linux)
      local debugServerPath = dataPath .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js"

      if string.find(file, cwd .. "/apps/") then
        projectFolder = string.match(file, cwd .. "(.-/[^/]+)/src")
      end

      for _, adapterType in ipairs({ "node", "chrome" }) do
        local pwaAdapter = "pwa-" .. adapterType

        if not dap.adapters[pwaAdapter] then
          dap.adapters[pwaAdapter] = {
            type = "server",
            host = "localhost",
            port = "${port}",
            executable = {
              command = "node",
              args = { debugServerPath, "${port}" },
            },
          }
        end

        -- this allow us to handle launch.json configurations
        -- which specify type as "node" or "chrome"
        dap.adapters[adapterType] = function(cb, config)
          local nativeAdapter = dap.adapters[pwaAdapter]

          config.type = pwaAdapter

          if type(nativeAdapter) == "function" then
            nativeAdapter(cb, config)
          else
            cb(nativeAdapter)
          end
        end
      end

      for _, language in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
        dap.configurations[language] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "launch file",
            program = "${file}",
            cwd = "${workspacefolder}",
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "attach by process",
            processid = require("dap.utils").pick_process,
            cwd = "${workspacefolder}" .. projectFolder,
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "attach by port",
            port = 9229,
            cwd = "${workspacefolder}" .. projectFolder,
          },
          {
            type = "pwa-chrome",
            request = "launch",
            name = "Launch Chrome",
            url = "http://localhost:3000",
            webRoot = vim.fn.getcwd() .. projectFolder,
          },
        }
      end
    end,
  },
}
