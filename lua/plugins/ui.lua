return {
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        always_show_bufferline = true,
      },
    },
  },
  {
    "goolord/alpha-nvim",
    dependencies = {
      {
        "MaximilianLloyd/ascii.nvim",
        dependencies = {
          "MunifTanjim/nui.nvim",
        },
      },
    },
    opts = function()
      local dashboard = require("alpha.themes.dashboard")
      local neovim = require("ascii.text.neovim")
      dashboard.section.header.val = neovim.sharp
    end,
  },
}
