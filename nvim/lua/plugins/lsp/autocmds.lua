local M = {}

function M.on_attach(client, buffer)
  --- NOTE(jm): Disabled in favor of conform.nvim
  ---@diagnostic disable-next-line: missing-parameter, param-type-mismatch
  -- if client and client:supports_method('textdocument/formatting') then
  --   -- format the current buffer on save
  --   vim.api.nvim_create_autocmd('bufwritepre', {
  --     -- Since there's a buffer argument,
  --     -- this event is listened for only inside of the current buffer
  --     buffer = buffer,
  --     callback = function()
  --       vim.lsp.buf.format({ bufnr = buffer, id = client.id })
  --     end,
  --   })
  -- end
  --   -- code lens
  --   if opts.codelens.enabled and vim.lsp.codelens then
  --     JVim.lsp.on_supports_method("textDocument/codeLens", function(client, buffer)
  --       vim.lsp.codelens.refresh()
  --       vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
  --         buffer = buffer,
  --         callback = vim.lsp.codelens.refresh,
  --       })
  --     end)
  --   end
  -- end
end

return M
