return {
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
      },
    },
  },
  { 'Bilal2453/luvit-meta', lazy = true },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      'saghen/blink.cmp',
      -- Useful status updates for LSP.
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', opts = {} },
    },
    -- LSP servers and clients communicate which features they support through "capabilities".
    --  By default, Neovim supports a subset of the LSP specification.
    --  With blink.cmp, Neovim has *more* capabilities which are communicated to the LSP servers.
    --  Explanation from TJ: https://youtu.be/m8C0Cq9Uv9o?t=1275
    --
    -- This can vary by config, but in general for nvim-lspconfig:
    config = function()
      local lspconfig = require("lspconfig")
      local blink = require("blink.cmp")

      lspconfig.lua_ls.setup { capabilities = blink.get_lsp_capabilities() }

      lspconfig.clangd.setup {
        cmd = {
          "clangd",
          "--enable-config",
          "--background-index",
          "--all-scopes-completion",
          "--log=error",
        },
        filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
        capabilities = blink.get_lsp_capabilities()
      }


      --Enable (broadcasting) snippet capability for completion
      local neocmake_capabilities = vim.lsp.protocol.make_client_capabilities()
      neocmake_capabilities.textDocument.completion.completionItem.snippetSupport = true
      lspconfig.neocmake.setup {
        capabilities = blink.get_lsp_capabilities(neocmake_capabilities),
      }

      -- auto-cmd on every 'LspAttach' command,
      -- because there's no `buffer` argument.
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          -- NOTE: Remember that Lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself.
          --
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = args.buf, desc = 'LSP: ' .. desc })
          end

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
          --
          -- Find references for the word under your cursor.
          map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          local client = assert(vim.lsp.get_client_by_id(args.data.client_id), "Failed to get LSP client")
          ---@diagnostic disable-next-line: missing-parameter, param-type-mismatch
          if client:supports_method('textdocument/formatting') then
            -- format the current buffer on save
            vim.api.nvim_create_autocmd('bufwritepre', {
              -- Since there's a buffer argument,
              -- this event is listened for only inside of the current buffer
              buffer = args.buf,
              callback = function()
                vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
              end,
            })
          end
        end,
      })
    end,
  },
}
