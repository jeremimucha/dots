-- DISABLED(jm)
if true then return {} end

return {
  {
    'Mofiqul/vscode.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    init = function()
      -- Load the colorscheme here.
      vim.cmd.colorscheme 'vscode'
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
