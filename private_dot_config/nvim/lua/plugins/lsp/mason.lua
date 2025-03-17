return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    local mason = require("mason")
    local mason_lspconfig = require("mason-lspconfig")
    local mason_tool_installer = require("mason-tool-installer")

    -- enable mason and configure icons
    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    ---@diagnostic disable-next-line: missing-fields
    mason_lspconfig.setup({
      -- list of servers for mason to install
      ensure_installed = {
        "astro",
        -- "ts_ls",
        "vtsls",
        "html",
        "cssls",
        "tailwindcss",
        "lua_ls",
        "emmet_ls",
        "dockerls",
        "docker_compose_language_service",
      },
    })

    mason_tool_installer.setup({
      ensure_installed = {
        "prettier", -- prettier formatter
        "stylua", -- lua formatter
        "eslint_d", -- eslint language server
        "js-debug-adapter", -- js debug adapter
        "hadolint", -- haskell docker linter
      },
    })
  end,
}
