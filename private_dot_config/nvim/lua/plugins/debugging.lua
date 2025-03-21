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
    -- virtual text for the debugger
    { "theHamsta/nvim-dap-virtual-text", opts = {} },
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    local adapters = { "pwa-node", "pwa-chrome" }
    local js_based_languages = { "typescript", "javascript", "typescriptreact" }
    local debugger_path = get_pkg_path("js-debug-adapter", "/js-debug/src/dapDebugServer.js")

    local dap_icons = {
      Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
      Breakpoint = " ",
      BreakpointCondition = " ",
      BreakpointRejected = { " ", "DiagnosticError" },
      LogPoint = ".>",
    }

    -- Setup DAP config by VS Code launch.json file
    local dap_vscode = require("dap.ext.vscode")
    local json = require("plenary.json")
    ---@diagnostic disable-next-line: duplicate-set-field
    dap_vscode.json_decode = function(str)
      -- replace chrome with pwa-chrome
      str = str:gsub('"type": "chrome"', '"type": "pwa-chrome"')
      return vim.json.decode(json.json_strip_comments(str, {}))
    end

    vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

    -- Set icons for DAP
    for name, sign in pairs(dap_icons) do
      sign = type(sign) == "table" and sign or { sign }
      vim.fn.sign_define(
        "Dap" .. name,
        { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
      )
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

    -- stylua: ignore start
    dap.listeners.before.attach.dapui_config = function() dapui.open() end
    dap.listeners.before.launch.dapui_config = function() dapui.open() end
    dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
    dap.listeners.before.event_exited.dapui_config = function() dapui.close() end
    -- stylua: ignore end

    local keymap = vim.keymap

    keymap.set("n", "<Leader>dc", dap.continue, { desc = "Continue" })
    keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
    keymap.set("n", "<leader>dc", dap.continue, { desc = "Run/Continue" })
    keymap.set("n", "<leader>dC", dap.run_to_cursor, { desc = "Run to Cursor" })
    keymap.set("n", "<leader>dg", dap.goto_, { desc = "Go to Line (No Execute)" })
    keymap.set("n", "<leader>di", dap.step_into, { desc = "Step Into" })
    keymap.set("n", "<leader>dj", dap.down, { desc = "Down" })
    keymap.set("n", "<leader>dk", dap.up, { desc = "Up" })
    keymap.set("n", "<leader>dl", dap.run_last, { desc = "Run Last" })
    keymap.set("n", "<leader>do", dap.step_out, { desc = "Step Out" })
    keymap.set("n", "<leader>dO", dap.step_over, { desc = "Step Over" })
    keymap.set("n", "<leader>dP", dap.pause, { desc = "Pause" })
    keymap.set("n", "<leader>dr", dap.repl.toggle, { desc = "Toggle REPL" })
    keymap.set("n", "<leader>ds", dap.session, { desc = "Session" })
    keymap.set("n", "<leader>dt", dap.terminate, { desc = "Terminate" })
    keymap.set("n", "<leader>du", dapui.toggle, { desc = "Toggle DAP UI" })
    -- stylua: ignore
    keymap.set("n", "<leader>dw", function() require("dap.ui.widgets").hover() end, { desc = "Widgets" })
  end,
}
