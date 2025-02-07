return {
  { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is.
    --
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
    'folke/tokyonight.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    -- opts = {
    --   on_highlights = function(hl, c)
    --     local prompt = "#2d3149"
    --     hl.TelescopeNormal = {
    --       bg = c.bg_dark,
    --       fg = c.fg_dark,
    --     }
    --     hl.TelescopeBorder = {
    --       bg = c.bg_dark,
    --       fg = c.fg_dark,
    --     }
    --     hl.TelescopePromptNormal = {
    --       bg = prompt,
    --     }
    --     hl.TelescopePromptBorder = {
    --       bg = prompt,
    --       fg = prompt,
    --     }
    --     hl.TelescopePromptTitle = {
    --       bg = prompt,
    --       fg = prompt,
    --     }
    --     hl.TelescopePreviewTitle = {
    --       bg = c.bg_dark,
    --       fg = c.bg_dark,
    --     }
    --     hl.TelescopeResultsTitle = {
    --       bg = c.bg_dark,
    --       fg = c.bg_dark,
    --     }
    --   end,
    -- },
    init = function()
      -- Load the colorscheme here.
      -- Like many other themes, this one has different styles, and you could load
      -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
      vim.cmd.colorscheme 'tokyonight-night'
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
