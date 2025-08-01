return {
  "saghen/blink.cmp",
  dependencies = { "Kaiser-Yang/blink-cmp-avante" },
  event = "InsertEnter",

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    completion = {
      -- nvim-cmp style menu
      menu = { draw = { columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } } } },
    },
    sources = {
      default = { "avante" }, -- add avante to the default sources
      providers = { avante = { module = "blink-cmp-avante", name = "Avante", opts = {} } },
    },
  },
}
