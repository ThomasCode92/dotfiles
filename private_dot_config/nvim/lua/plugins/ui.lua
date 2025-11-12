return {
  "nvim-mini/mini.icons",
  opts = function()
    require("mini.icons").setup({})

    local tsx_icon, tsx_hl = MiniIcons.get("extension", "tsx")

    return {
      extension = {
        ["test.tsx"] = { glyph = tsx_icon, hl = "MiniIconsAzure" }, -- use tsx icon with azure color for *.test.tsx files
      },
    }
  end,
}
