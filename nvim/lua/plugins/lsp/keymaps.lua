local M = {}
-- local CoreDiagnosticsConfig = vim.diagnostic.config()
-- local MinDiagnosticsConfig = {
--   underline = { severity = { min = vim.diagnostic.severity.ERROR } },
--   update_in_insert = false,
--   virtual_text = {
--     spacing = 4,
--     source = "if_many",
--     -- this will set set the prefix to a function that returns the diagnostics icon based on the severity
--     prefix = function(diagnostic)
--       local icons = JVim.config.icons.diagnostics
--       for d, icon in pairs(icons) do
--         if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
--           return icon
--         end
--       end
--       return "●"
--     end,
--     severity = { min = vim.diagnostic.severity.ERROR },
--   },
--   severity_sort = true,
--   signs = {
--     text = {
--       [vim.diagnostic.severity.ERROR] = JVim.config.icons.diagnostics.Error,
--     },
--     severity = { min = vim.diagnostic.severity.ERROR },
--   },
-- }
-- local ActiveDiagnostics = {
--   [CoreDiagnosticsConfig] = MinDiagnosticsConfig,
--   [MinDiagnosticsConfig] = CoreDiagnosticsConfig,
--   active = CoreDiagnosticsConfig,
-- }
-- ---@param buffer
local has_sighelp_cond = function(client, _)
  -- for _, client in ipairs(clients) do
  if client:supports_method('textDocument/signatureHelp') then
    return function() return vim.lsp.buf.signature_help() end
  end
  -- end
  return function()
    vim.api.nvim_echo({ { "Signature Help unavailable for current LSP client" } }, true, {})
  end
end

local make_cond = function(client_method, fn)
  return function(client, _)
    -- for _, client in ipairs(clients) do
    if client:supports_method(client_method) then
      return fn
    end
    -- end
    return function()
      vim.api.nvim_echo({ { client_method .. " unavailable for current LSP client" } }, true, {})
    end
  end
end

local keymaps = {
  { "<leader>cl", "<cmd>LspInfo<cr>",                                desc = "Lsp Info" },
  -- Jump to the definition of the word under your cursor.
  --  This is where a variable was first declared, or where a function is defined, etc.
  --  To jump back, press <C-t>.
  { 'gd',         require('telescope.builtin').lsp_definitions,      desc = 'Goto Definition' },

  -- Find references for the word under your cursor.
  { 'gr',         require('telescope.builtin').lsp_references,       desc = 'Goto References' },

  -- Jump to the implementation of the word under your cursor.
  --  Useful when your language has ways of declaring types without an actual implementation.
  { 'gI',         require('telescope.builtin').lsp_implementations,  desc = 'Goto Implementation' },

  -- Jump to the type of the word under your cursor.
  --  Useful when you're not sure what type a variable is and you want to see
  --  the definition of its *type*, not where it was *defined*.
  { 'gy',         require('telescope.builtin').lsp_type_definitions, desc = 'Type Definition' },

  -- This is not Goto Definition, this is Goto Declaration.
  --  For example, in C this would take you to the header.
  { 'gD',         vim.lsp.buf.declaration,                           desc = 'Goto Declaration' },

  { "K",          function() return vim.lsp.buf.hover() end,         desc = "Hover" },
  {
    "gK",
    cond = has_sighelp_cond,
    desc = "Signature Help",
  },
  {
    "<c-k>",
    cond = has_sighelp_cond,
    mode = "i",
    desc = "Signature Help"
  },

  -- Fuzzy find all the symbols in your current document.
  --  Symbols are things like variables, functions, types, etc.
  { '<leader>ds', require('telescope.builtin').lsp_document_symbols,          desc = 'Document Symbols' },

  -- Fuzzy find all the symbols in your current workspace.
  --  Similar to document symbols, except searches over your entire project.
  { '<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, desc = 'Workspace Symbols' },

  -- Rename the variable under your cursor.
  --  Most Language Servers support renaming across files, etc.
  { '<leader>rn', vim.lsp.buf.rename,                                         desc = 'Rename' },

  -- Execute a code action, usually your cursor needs to be on top of an error
  -- or a suggestion from your LSP for this to activate.
  { '<leader>ca', vim.lsp.buf.code_action,                                    desc = 'Code Action',      mode = { 'n', 'x', 'v' } },

  -- The following code creates a keymap to toggle inlay hints in your
  -- code, if the language server you are using supports them
  --
  -- This may be unwanted, since they displace some of your code
  -- local client = vim.lsp.get_client_by_id(event.data.client_id)
  {
    '<leader>cth',
    desc = "Toggle Inlay Hints",
    cond = function(client, buffer)
      if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
        return function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = buffer })
        end
      end
      return function()
        vim.api.nvim_echo({ { "Unavailable for current LSP client" } }, true, {})
      end
    end
  },
  {
    "<leader>ctd",
    function()
      JVim.lsp.diagnostics.active = JVim.lsp.diagnostics[JVim.lsp.diagnostics.active]
      vim.diagnostic.config(JVim.lsp.diagnostics.active)
      -- ActiveDiagnostics.active = ActiveDiagnostics[ActiveDiagnostics.active]
      -- vim.diagnostic.config(ActiveDiagnostics.active)
      -- if not CoreDiagnosticsConfig then
      --   CoreDiagnosticsConfig = vim.diagnostic.config()
      -- end
      -- ShowDiagnostics = not ShowDiagnostics
      -- if ShowDiagnostics then
      --   -- vim.diagnostic.show()
      --   vim.diagnostic.config(CoreDiagnosticsConfig)
      -- else
      --   -- vim.diagnostic.hide()
      --   -- vim.diagnostic.config({
      --   --   virtual_text = { severity = { min = vim.diagnostic.severity.ERROR } },
      --   --   signs = { severity = { min = vim.diagnostic.severity.ERROR } },
      --   --   underline = { severity = { min = vim.diagnostic.severity.ERROR } },
      --   -- })
      --   vim.diagnostic.config(MinDiagnosticsConfig)
      -- end
    end,
    desc = "Toggle Diagnostics",
  },
  {
    "<leader>ca",
    cond = make_cond("textDocument/codeAction", vim.lsp.buf.code_action),
    desc = "Code Action",
    mode = { "n", "v" },
  },
  {
    "<leader>cc",
    cond = make_cond("textDocument/codeLens", vim.lsp.codelens.run),
    desc = "Run Codelens",
    mode = { "n", "v" },
  },
  {
    "<leader>cC",
    cond = make_cond("textDocument/codeLens", vim.lsp.codelens.refresh),
    desc = "Refresh & Display Codelens",
    mode = { "n" },
  },
  -- -- { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File", mode ={"n"}, has = { "workspace/didRenameFiles", "workspace/willRenameFiles" } },
  {
    "<leader>cr",
    cond = make_cond("textDocument/rename", vim.lsp.buf.rename),
    desc = "Rename",
  },
  -- { "<leader>cA", JVim.lsp.action.source, desc = "Source Action", has = "codeAction" },
}


function M.on_attach(client, buffer)
  -- NOTE: Remember that Lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local map = function(keys, func, desc, mode)
    -- mode = mode or 'n'
    vim.keymap.set(mode, keys, func, { buffer = buffer, desc = 'LSP: ' .. desc })
  end

  -- local keymaps = require("plugins.lsp.keymaps")
  -- local client = vim.lsp.get_client_by_id(event.data.client_id)
  for _, key in pairs(keymaps) do
    local mode = key.mode or "n"
    local keys = key[1]
    local desc = assert(key.desc)
    local func = key[2] or (key.cond and key.cond(client, buffer))
    map(keys, func, desc, mode)
  end
end

return M
