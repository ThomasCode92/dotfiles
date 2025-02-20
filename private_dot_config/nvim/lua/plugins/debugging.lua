--- Gets a path to a package in the Mason registry.
--- Prefer this to `get_package`, since the package might not always be
--- available yet and trigger errors.
---@param pkg string
---@param path? string
local function get_pkg_path(pkg, path)
  pcall(require, "mason")
  local root = vim.env.MASON or (vim.fn.stdpath("data") .. "/mason")
  path = path or ""
  local ret = root .. "/packages/" .. pkg .. "/" .. path
  return ret
end

return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    {
      "microsoft/vscode-js-debug",
      opt = true,
      run = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
    },
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    local adapters = { "pwa-node", "pwa-chrome" }
    local js_based_languages = { "typescript", "javascript", "typescriptreact" }
    local debugger_path = get_pkg_path("js-debug-adapter", "/js-debug/src/dapDebugServer.js")

    -- Setup DAP config by VS Code launch.json file
    local dap_vscode = require("dap.ext.vscode")
    local json = require("plenary.json")
    ---@diagnostic disable-next-line: duplicate-set-field
    dap_vscode.json_decode = function(str)
      return vim.json.decode(json.json_strip_comments(str, {}))
    end

    -- Configure JS/TS adapters
    for _, adapter in ipairs(adapters) do
      dap.adapters[adapter] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "node",
          args = { debugger_path, "${port}" },
        },
      }
    end

    -- DAP configuration for JS-based languages
    for _, language in ipairs(js_based_languages) do
      dap.configurations[language] = {
        -- Debug single nodejs files
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          cwd = vim.fn.getcwd(),
          sourceMaps = true,
        },
        -- Debug nodejs processes (make sure to add --inspect when you run the process)
        {
          type = "pwa-node",
          request = "attach",
          name = "Attach",
          processId = require("dap.utils").pick_process,
          cwd = vim.fn.getcwd(),
          sourceMaps = true,
        },
        -- Debug web applications (client side)
        {
          type = "pwa-chrome",
          request = "launch",
          name = "Launch & Debug Chrome",
          url = function()
            local co = coroutine.running()
            return coroutine.create(function()
              vim.ui.input({
                prompt = "Enter URL: ",
                default = "http://localhost:3000",
              }, function(url)
                if url == nil or url == "" then
                  return
                else
                  coroutine.resume(co, url)
                end
              end)
            end)
          end,
          webRoot = vim.fn.getcwd(),
          protocol = "inspector",
          sourceMaps = true,
          userDataDir = false,
        },
        -- Divider for the launch.json derived configs
        {
          name = "----- ↓ launch.json configs ↓ -----",
          type = "",
          request = "launch",
        },
      }
    end

    dapui.setup()

    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end

    local keymap = vim.keymap

    keymap.set("n", "<Leader>dt", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
    keymap.set("n", "<Leader>dc", dap.continue, { desc = "Continue" })
  end,
}
