return {
  "saghen/blink.cmp",
  dependencies = { "Kaiser-Yang/blink-cmp-avante" },
  event = "InsertEnter",

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    completion = {
      menu = { -- nvim-cmp style menu
        draw = {
          columns = {
            { "label", "label_description", gap = 1 },
            { "kind_icon", "kind" },
            { "source_name" },
          },
          components = {
            source_name = {
              text = function(ctx)
                return ctx.item.client_name or ctx.item.source_name
              end,
            },
          },
        },
      },
    },
    sources = {
      default = { "lsp", "avante", "path", "snippets", "buffer" },
      providers = {
        avante = {
          module = "blink-cmp-avante",
          name = "Avante",
          opts = {
            -- options for blink-cmp-avante
          },
        },
      },
    },
  },
}
