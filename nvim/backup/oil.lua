-- DISABLED(jm)
if true then return {} end

return {
  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      view_options = {
        show_hidden = true,
      },
      float = {
        -- Padding around the floating window
        padding = 2,
        -- max_width and max_height can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
        max_width = 0.8,
        max_height = 0.8,
        border = "rounded",
        win_options = {
          winblend = 0,
        },
      },
    },
    -- Optional dependencies
    dependencies = { { "echasnovski/mini.icons", opts = {} } },
    -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
    keys = {
      -- local builtin = require("telescope.builtin")
      { "<leader>-", function() require("oil").toggle_float() end, desc = "Open Parent Directory" },
    },
  }
}
