return {
  {
    "mfussenegger/nvim-dap",
    opts = function()
      local dap = require("dap")
      local mason_registry = require("mason-registry")

      local projectFolder = ""
      local file = vim.fn.expand("%:p")
      local cwd = vim.fn.getcwd():gsub([[-]], "%%-")

      if string.find(file, cwd .. "/apps/") then
        projectFolder = string.match(file, cwd .. "(.-/[^/]+)/src")
      end

      if not dap.adapters["pwa-chrome"] then
        dap.adapters["pwa-chrome"] = {
          type = "server",
          host = "localhost",
          port = "${port}",
          executable = {
            command = "node",
            args = {
              mason_registry.get_package("js-debug-adapter"):get_install_path() .. "/js-debug/src/dapDebugServer.js",
              "${port}",
            },
          },
        }
      end

      for _, language in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
        dap.configurations[language] = {
          {
            type = "pwa-node",
            request = "Launch",
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
