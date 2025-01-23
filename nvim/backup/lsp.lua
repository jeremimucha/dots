return {
  "neovim/nvim-lspconfig",
  dependencies = {
    'saghen/blink.cmp',
    {
      "folke/lazydev.nvim",
      ft = "lua", -- only load on lua files
      opts = {
        library = {
          -- See the configuration section for more details
          -- Load luvit types when the `vim.uv` word is found
          { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        },
      },
    },
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
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id), "Failed to get LSP client")
        -- if client:supports_method('textDocument/implementation') then
        --   -- Create a keymap for vim.lsp.buf.implementation
        -- end
        --
        -- if client:supports_method('textDocument/completion') then
        --   -- Enable auto-completion
        --   vim.lsp.completion.enable(true, client.id, args.buf, {autotrigger = true})
        -- end

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
}
