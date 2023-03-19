local default_colors = require("kanagawa.colors").setup({ theme = "wave" })
local overrides = {
  IndentBlanklineChar = { fg = default_colors.sumiInk2 },
  PmenuSel = { blend = 0 },
}
require("kanagawa").setup({
  compile = true,
  dimInactive = true,
  overrides = function(colors)
    return overrides
  end,
  colors = {
    theme = {
      all = {
        ui = {
          bg_gutter = "none",
        },
      },
    },
  },
})

require("kanagawa").load("wave")