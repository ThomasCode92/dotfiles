return {
  "nvim-mini/mini.icons",
  opts = function()
    require("mini.icons").setup({})

    local html_icon, html_hl = MiniIcons.get("extension", "html")
    local tsx_icon, _ = MiniIcons.get("extension", "tsx")

    return {
      extension = {
        ["gohtml"] = { glyph = html_icon, hl = html_hl }, -- use html icon with orange color for *.gohtml files
        ["test.tsx"] = { glyph = tsx_icon, hl = "MiniIconsAzure" }, -- use tsx icon with azure color for *.test.tsx files
      },
    }
  end,
}
