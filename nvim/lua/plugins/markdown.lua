return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = "markdown",
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  }
  -- TODO(jm): When integrating obsidian.nvim remember to disable the UI component
  -- require('obsidian').setup({
  --     ui = { enable = false },
  -- })
}
