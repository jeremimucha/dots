return {
  {
    "hrsh7th/nvim-cmp",
    optional = true,
    enabled = false,
  },
  {
    "saghen/blink.cmp",
    version = not vim.g.jvim_blink_main and "*",
    build = vim.g.jvim_blink_main and "cargo build --release",
    dependencies = {
      "rafamadriz/friendly-snippets",
      -- add blink.compat to dependencies
      {
        "saghen/blink.compat",
        optional = true, -- make optional so it's only enabled if any extras need it
        opts = {},
        version = not vim.g.jvim_blink_main and "*",
      },
    },
    -- event = "InsertEnter",
    opts_extend = {
      "sources.completion.enabled_providers",
      "sources.compat",
      "sources.default",
    },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- 'default' for mappings similar to built-in completion
      -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
      -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
      -- See the full "keymap" documentation for information on defining your own keymap.
      keymap = {
        -- preset = 'default',
        preset = 'none',
        ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
        ['<C-e>'] = { 'cancel', 'fallback' },
        ['<C-y>'] = { 'select_and_accept' },
        ['<C-l>'] = { 'select_and_accept' },
        ['<Tab>'] = {
          function(cmp)
            if cmp.snippet_active() then
              return cmp.accept()
            else
              return cmp.select_and_accept()
            end
          end,
          'snippet_forward',
          'fallback',
        },
        ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
        ['<C-p>'] = { 'select_prev', 'fallback' },
        ['<C-n>'] = { 'select_next', 'fallback' },
        ['<M-k>'] = { 'select_prev', 'fallback' },
        ['<M-j>'] = { 'select_next', 'fallback' },

        ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
      },
      -- snippets = {
      --     expand = function(snippet, _)
      --     return JVim.cmp.expand(snippet)
      --     end,
      -- },
      appearance = {
        -- sets the fallback highlight groups to nvim-cmp's highlight groups
        -- useful for when your theme doesn't support blink.cmp
        -- will be removed in a future release, assuming themes add support
        use_nvim_cmp_as_default = false,
        -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- adjusts spacing to ensure icons are aligned
        nerd_font_variant = "mono",
      },
      completion = {
        accept = {
          -- experimental auto-brackets support
          auto_brackets = {
            enabled = true,
          },
        },
        menu = {
          draw = {
            treesitter = { "lsp" },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          treesitter_highlighting = false,
        },
        -- ghost_text = {
        -- enabled = vim.g.ai_cmp,
        -- },
      },

      -- experimental signature help support
      signature = {
        enabled = true,
        window = {
          -- Disable if you run into performance issues
          treesitter_highlighting = false,
        },
      },

      sources = {
        -- adding any nvim-cmp sources here will enable them
        -- with blink.compat
        compat = {},
        default = { "lsp", "path", "snippets", "buffer" },
        cmdline = {},
      },

    },
    ---@param opts blink.cmp.Config | { sources: { compat: string[] } }
    config = function(_, opts)
      -- setup compat sources
      local enabled = opts.sources.default
      for _, source in ipairs(opts.sources.compat or {}) do
        opts.sources.providers[source] = vim.tbl_deep_extend(
          "force",
          { name = source, module = "blink.compat.source" },
          opts.sources.providers[source] or {}
        )
        if type(enabled) == "table" and not vim.tbl_contains(enabled, source) then
          table.insert(enabled, source)
        end
      end

      -- Unset custom prop to pass blink.cmp validation
      opts.sources.compat = nil

      -- check if we need to override symbol kinds
      -- for _, provider in pairs(opts.sources.providers or {}) do
      --     ---@cast provider blink.cmp.SourceProviderConfig|{kind?:string}
      --     if provider.kind then
      --     local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
      --     local kind_idx = #CompletionItemKind + 1

      --     CompletionItemKind[kind_idx] = provider.kind
      --     ---@diagnostic disable-next-line: no-unknown
      --     CompletionItemKind[provider.kind] = kind_idx

      --     ---@type fun(ctx: blink.cmp.Context, items: blink.cmp.CompletionItem[]): blink.cmp.CompletionItem[]
      --     local transform_items = provider.transform_items
      --     ---@param ctx blink.cmp.Context
      --     ---@param items blink.cmp.CompletionItem[]
      --     provider.transform_items = function(ctx, items)
      --         items = transform_items and transform_items(ctx, items) or items
      --         for _, item in ipairs(items) do
      --         item.kind = kind_idx or item.kind
      --         end
      --         return items
      --     end

      --     -- Unset custom prop to pass blink.cmp validation
      --     provider.kind = nil
      --     end
      -- end

      require("blink.cmp").setup(opts)
    end,
  },

  -- add icons
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      opts.appearance = opts.appearance or {}
      opts.appearance.kind_icons = vim.tbl_extend("keep", {
        Color = "██", -- Use block instead of icon for color items to make swatches more usable
      }, JVim.config.icons.kinds)
    end,
  },

  -- -- lazydev
  -- {
  --     "saghen/blink.cmp",
  --     opts = {
  --     sources = {
  --         -- add lazydev to your completion providers
  --         default = { "lazydev" },
  --         providers = {
  --         lazydev = {
  --             name = "LazyDev",
  --             module = "lazydev.integrations.blink",
  --             score_offset = 100, -- show at a higher priority than lsp
  --         },
  --         },
  --     },
  --     },
  -- },
  -- catppuccin support
  {
    "catppuccin",
    optional = true,
    opts = {
      integrations = { blink_cmp = true },
    },
  },
}
