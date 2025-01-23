return {
  -- lspconfig
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "mason.nvim",
      "mason-lspconfig.nvim",
      "fidget.nvim",
    },
    opts = function()
      ---@class PluginLspOpts
      local ret = {
        -- options for vim.diagnostic.config()
        ---@type vim.diagnostic.Opts
        diagnostics = {
          underline = true,
          update_in_insert = false,
          virtual_text = {
            spacing = 4,
            source = "if_many",
            -- this will set set the prefix to a function that returns the diagnostics icon based on the severity
            -- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
            prefix = function(diagnostic)
              local icons = JVim.config.icons.diagnostics
              for d, icon in pairs(icons) do
                if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
                  return icon
                end
              end
              return "●"
            end,
          },
          severity_sort = true,
          signs = {
            text = {
              [vim.diagnostic.severity.ERROR] = JVim.config.icons.diagnostics.Error,
              [vim.diagnostic.severity.WARN] = JVim.config.icons.diagnostics.Warn,
              [vim.diagnostic.severity.HINT] = JVim.config.icons.diagnostics.Hint,
              [vim.diagnostic.severity.INFO] = JVim.config.icons.diagnostics.Info,
            },
          },
        },
        document_highlight = {
          enabled = true,
        },
        -- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
        -- Be aware that you also will need to properly configure your LSP server to
        -- provide the inlay hints.
        inlay_hints = {
          enabled = true,
          exclude = { "vue" }, -- filetypes for which you don't want to enable inlay hints
        },
        -- Enable this to enable the builtin LSP code lenses on Neovim >= 0.10.0
        -- Be aware that you also will need to properly configure your LSP server to
        -- provide the code lenses.
        codelens = {
          enabled = false,
        },
        -- add any global capabilities here
        capabilities = {
          workspace = {
            fileOperations = {
              didRename = true,
              willRename = true,
            },
          },
        },
        -- options for vim.lsp.buf.format
        -- `bufnr` and `filter` is handled by the JVim formatter,
        -- but can be also overridden when specified
        format = {
          formatting_options = nil,
          timeout_ms = nil,
        },
        -- LSP Server Settings
        ---@type lspconfig.options
        servers = {
          -- [[ c, cpp, clangd ]]
          clangd = {
            mason = not JVim.is_win(),
            keys = {
              { "<leader>ch", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)" },
            },
            root_dir = function(fname)
              return require("lspconfig.util").root_pattern(
                ".clangd",
                "CMakePresets.json",
                "compile_commands.json",
                "compile_flags.txt"
              )(fname) or require("lspconfig.util").root_pattern(
                "Makefile",
                "configure.ac",
                "configure.in",
                "config.h.in",
                "meson.build",
                "meson_options.txt",
                "build.ninja"
              )(fname) or vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
            end,
            cmd = {
              "clangd",
              "--background-index",
              "--clang-tidy",
              "--header-insertion=iwyu",
              "--completion-style=detailed",
              "--function-arg-placeholders",
              "--fallback-style=llvm",
              "--enable-config",
              "--all-scopes-completion",
              "--log=error",
            },
            init_options = {
              usePlaceholders = true,
              completeUnimported = true,
              clangdFileStatus = true,
            },
            filetypes = { "c", "cpp", "cppm", "objc", "objcpp", "cuda", "proto" },
          },
          -- [[ cmake ]]
          neocmake = {
            mason = false,
            capabilities = {
              textDocument = { completion = { completionItem = { snippetSupport = true }, }, },
            },
          },
          -- [[ lua ]]
          lua_ls = {
            -- NOTE: set to false if you don't want this server to be installed with mason
            -- mason = false,
            --
            -- Use this to add any additional keymaps
            -- for specific lsp servers
            -- ---@type LazyKeysSpec[]
            -- keys = {},
            settings = {
              Lua = {
                workspace = {
                  checkThirdParty = false,
                },
                codeLens = {
                  enable = true,
                },
                completion = {
                  callSnippet = "Replace",
                },
                doc = {
                  privateName = { "^_" },
                },
                hint = {
                  enable = true,
                  setType = false,
                  paramType = true,
                  paramName = "Disable",
                  semicolon = "Disable",
                  arrayIndex = "Disable",
                },
              },
            },
          },
          -- [[ python ]]
          ruff = {
            cmd_env = { RUFF_TRACE = "messages" },
            init_options = {
              settings = {
                logLevel = "error",
              },
            },
            keys = {
              {
                "<leader>co",
                JVim.lsp_action["source.organizeImports"],
                desc = "Organize Imports",
              },
            },
          },
          pyright = {
            mason = false,
          },
        },
        -- you can do any additional lsp server setup here
        -- return true if you don't want this server to be setup with lspconfig
        ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
        setup = {
          -- example to setup with typescript.nvim
          -- tsserver = function(_, opts)
          --   require("typescript").setup({ server = opts })
          --   return true
          -- end,
          -- [[ python ]]
          ruff = function()
            JVim.on_lsp_attach(function(client, _)
              -- Disable hover in favor of Pyright
              client.server_capabilities.hoverProvider = false
            end, "ruff")
          end,
          -- Specify * to use this function as a fallback for any server
          -- ["*"] = function(server, opts) end,
        },
      }
      return ret
    end,
    ---@param opts PluginLspOpts
    config = function(_, opts)
      -- NOTE(jm): Diagnostic config needs to be setup before loading keymaps
      JVim.lsp = {
        diagnostics_core = vim.deepcopy(opts.diagnostics),
        diagnostics_min = vim.deepcopy(opts.diagnostics),
      }
      -- JVim.lsp.diagnostics_core = vim.deepcopy(opts.diagnostics)
      -- JVim.lsp.diagnostics_min = vim.deepcopy(opts.diagnostics)
      JVim.lsp.diagnostics_min.underline = { severity = { min = vim.diagnostic.severity.ERROR } }
      JVim.lsp.diagnostics_min.virtual_text["severity"] = { min = vim.diagnostic.severity.ERROR }
      JVim.lsp.diagnostics_min.signs["severity"] = { min = vim.diagnostic.severity.ERROR }
      JVim.lsp.diagnostics = {
        [JVim.lsp.diagnostics_core] = JVim.lsp.diagnostics_min,
        [JVim.lsp.diagnostics_min] = JVim.lsp.diagnostics_core,
        active = JVim.lsp.diagnostics_core,
      }
      vim.diagnostic.config(JVim.lsp.diagnostics.active)
      -- vim.diagnostic.config(vim.deepcopy(opts.diagnostics))
      -- setup keymaps
      -- JVim.lsp.on_attach(function(client, buffer)
      --   require("plugins.lsp.keymaps").on_attach(client, buffer)
      -- end)
      --  This function gets run when an LSP attaches to a particular buffer.
      --    That is to say, every time a new file is opened that is associated with
      --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
      --    function will be executed to configure the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('jvim-lsp-attach', { clear = true }),
        callback = function(event)
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          -- setup keymaps
          require("plugins.lsp.keymaps").on_attach(client, event.buf)
          -- TODO(jm): Pass in the entire envent to the autocmds?
          -- TO be able to filter on file type, etc.
          --
          -- setup autocmds
          require("plugins.lsp.autocmds").on_attach(client, event.buf)
        end,
      })

      local servers = opts.servers
      local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      local has_blink, blink = pcall(require, "blink.cmp")
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        has_cmp and cmp_nvim_lsp.default_capabilities() or {},
        has_blink and blink.get_lsp_capabilities() or {},
        opts.capabilities or {}
      )

      local function setup(server)
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
        }, servers[server] or {})
        if server_opts.enabled == false then
          return
        end

        if opts.setup[server] then
          if opts.setup[server](server, server_opts) then
            return
          end
        elseif opts.setup["*"] then
          if opts.setup["*"](server, server_opts) then
            return
          end
        end
        require("lspconfig")[server].setup(server_opts)
      end

      -- get all the servers that are available through mason-lspconfig
      local have_mason, mason_lsp = pcall(require, "mason-lspconfig")
      local all_mslp_servers = {}
      if have_mason then
        all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
      end

      local ensure_installed = {} ---@type string[]
      for server, server_opts in pairs(servers) do
        if server_opts then
          server_opts = server_opts == true and {} or server_opts
          if server_opts.enabled ~= false then
            -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
            if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
              setup(server)
            else
              ensure_installed[#ensure_installed + 1] = server
            end
          end
        end
      end

      if have_mason then
        mason_lsp.setup({
          ensure_installed = vim.tbl_deep_extend(
            "force",
            ensure_installed,
            JVim.opts("mason-lspconfig.nvim").ensure_installed or {}
          ),
          handlers = { setup },
        })
      end
    end,
  },

  -- Useful status updates for LSP.
  -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
  {
    'j-hui/fidget.nvim',
    opts = {},
    lazy = true,
  },

  -- cmdline tools and lsp servers
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    -- build = ":MasonUpdate",
    -- opts_extend = { "ensure_installed" },
    opts = {
      ensure_installed = {
        "stylua",
        "shfmt",
        "debugpy",
      },
      lazy = true,
    },
    -- ---@param opts MasonSettings | {ensure_installed: string[]}
    -- config = function(_, opts)
    --   require("mason").setup(opts)
    --   local mr = require("mason-registry")
    --   mr:on("package:install:success", function()
    --     vim.defer_fn(function()
    --       -- trigger FileType event to possibly load this newly installed LSP server
    --       require("lazy.core.handler.event").trigger({
    --         event = "FileType",
    --         buf = vim.api.nvim_get_current_buf(),
    --       })
    --     end, 100)
    --   end)

    --   mr.refresh(function()
    --     for _, tool in ipairs(opts.ensure_installed) do
    --       local p = mr.get_package(tool)
    --       if not p:is_installed() then
    --         p:install()
    --       end
    --     end
    --   end)
    -- end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    -- config disable here, and handled explicitly in nvim-lspconfig setup
    -- to allow for optionally installed tools - the `mason = false` option
    config = function() end,
    lazy = true,
  },
}
