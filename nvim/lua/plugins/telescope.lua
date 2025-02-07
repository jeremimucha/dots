return {
  {
    "nvim-telescope/telescope.nvim",
    event = "VimEnter",
    -- branch = "0.1.x",
    version = false, -- telescope did only one release, so use HEAD for now
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "cmake -G Ninja -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release"
      }
    },
    keys = {
      -- local builtin = require("telescope.builtin")
      { "<leader>,",  "<cmd>Telescope buffers sort_mru=true sort_lastused=true<CR>",                                                                desc = "Switch Buffer" },
      { "<leader>s:", "<cmd>Telescope command_history<CR>",                                                                                         desc = "Command History" },
      -- find,
      { "<leader>fb", "<cmd>Telescope buffers sort_mru=true sort_lastused=true ignore_current_buffer=true<CR>",                                     desc = "Buffers" },
      { "<leader>fc", function() require("telescope.builtin").find_files { cwd = vim.fn.stdpath("config") } end,                                    desc = "Find Config File" },
      { "<leader>ff", require("telescope.builtin").find_files,                                                                                      desc = "Find Files (Root Dir)" },
      { "<leader>fc", function() require("telescope.builtin").find_files { cwd = require("telescope.utils").buffer_dir() } end,                     desc = "Find Files (cwd)" },
      { "<leader>fg", "<cmd>Telescope git_files<cr>",                                                                                               desc = "[F]ind Files ([g]it-files)" },
      { "<leader>f.", require("telescope.builtin").oldfiles,                                                                                        desc = "Recent" },
      { "<leader>fr", require("telescope.builtin").oldfiles,                                                                                        desc = "Recent" },
      { "<leader>fR", function() require("telescope.builtin").oldfiles { cwd = vim.uv.cwd() } end,                                                  desc = "Recent (cwd)" },
      -- git,
      { "<leader>gc", "<cmd>Telescope git_commits<CR>",                                                                                             desc = "Commits" },
      { "<leader>gs", "<cmd>Telescope git_status<CR>",                                                                                              desc = "Status" },
      -- search,
      { '<leader>s"', require("telescope.builtin").registers,                                                                                       desc = "Registers" },
      { "<leader>sa", require("telescope.builtin").autocommands,                                                                                    desc = "Auto Commands" },
      { "<leader>sb", require("telescope.builtin").current_buffer_fuzzy_find,                                                                       desc = "Buffer" },
      { "<leader>sc", require("telescope.builtin").command_history,                                                                                 desc = "Command History" },
      { "<leader>sC", require("telescope.builtin").commands,                                                                                        desc = "Commands" },
      { "<leader>sd", function() require("telescope.builtin").diagnostics({ bufnr = 0 }) end,                                                       desc = "Document Diagnostics" },
      { "<leader>sD", require("telescope.builtin").diagnostics,                                                                                     desc = "Workspace Diagnostics" },
      { "<leader>sg", require("telescope.builtin").live_grep,                                                                                       desc = "Grep (Root Dir)" },
      { "<leader>sG", function() require("telescope.builtin").live_grep { cwd = require("telescope.utils").buffer_dir() } end,                      desc = "Grep (cwd)" },
      { "<leader>sh", require("telescope.builtin").help_tags,                                                                                       desc = "Help Pages" },
      { "<leader>sH", require("telescope.builtin").highlights,                                                                                      desc = "Search Highlight Groups" },
      { "<leader>sj", require("telescope.builtin").jumplist,                                                                                        desc = "Jumplist" },
      { "<leader>sk", require("telescope.builtin").keymaps,                                                                                         desc = "Key Maps" },
      { "<leader>sl", require("telescope.builtin").loclist,                                                                                         desc = "Location List" },
      { "<leader>sM", require("telescope.builtin").man_pages,                                                                                       desc = "Man Pages" },
      { "<leader>sm", require("telescope.builtin").marks,                                                                                           desc = "Jump to Mark" },
      { "<leader>so", require("telescope.builtin").vim_options,                                                                                     desc = "Options" },
      { "<leader>sR", require("telescope.builtin").resume,                                                                                          desc = "Resume" },
      { "<leader>sq", require("telescope.builtin").quickfix,                                                                                        desc = "Quickfix List" },
      { "<leader>sw", function() require("telescope.builtin").grep_string { word_match = "-w" } end,                                                desc = "Word (Root Dir)" },
      { "<leader>sW", function() require("telescope.builtin").grep_string { cwd = require("telescope.utils").buffer_dir(), word_match = "-w" } end, desc = "Word (cwd)" },
      { "<leader>sw", require("telescope.builtin").grep_string,                                                                                     mode = "v",                         desc = "Selection (Root Dir)" },
      { "<leader>sW", function() require("telescope.builtin").grep_string { cwd = require("telescope.utils").buffer_dir } end,                      mode = "v",                         desc = "Selection (cwd)" },
      {
        "<leader>ss",
        function()
          require("telescope.builtin").lsp_document_symbols({
            symbols = JVim.config.get_kind_filter(),
          })
        end,
        desc = "Goto Symbol"
      },
      {
        "<leader>sS",
        function()
          require("telescope.builtin").lsp_dynamic_workspace_symbols({
            symbols = JVim.config.get_kind_filter(),
          })
        end,
        desc = "Goto Symbol (Workspace)"
      },

      -- Edit packages
      {
        "<leader>sp",
        function()
          require("telescope.builtin").find_files {
            cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy")
          }
        end,
        desc = "Search Lazy Packages"
      },

      -- Slightly advanced example of overriding default behavior and theme
      {
        "<leader>/",
        function()
          -- You can pass additional configuration to Telescope to change the theme, layout, etc.
          require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown {
            winblend = 20,
            previewer = false,
          })
        end,
        desc = "[/] Fuzzily search in current buffer"
      },

      -- It"s also possible to pass additional configuration options.
      --  See `:help telescope.require("telescope.builtin").live_grep()` for information about particular keys
      {
        "<leader>s/",
        function()
          require("telescope.builtin").live_grep {
            grep_open_files = true,
            prompt_title = "Live Grep in Open Files",
          }
        end,
        desc = "Search [/] in Open Files"
      },
    },

    config = function()
      -- NOTE(jm):
      --  - The following are different ways of setting up how
      --    find results are displayed.
      --  - One way is to configure a picker,
      --  - Alternatively options can be set for a specific finder.

      -- The configured picker will apply to all finders
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      -- local trouble = require("trouble.sources.telescope")
      -- local icons = JVim.config.icons

      telescope.setup {
        -- Enable fzf-native
        extensions = {
          fzf = {}
        },
        file_ignore_patterns = { "%.git/." },
        defaults = {
          path_display = {
            "filename_first",
          },
          -- previewer = false,
          -- prompt_prefix = " " .. icons.ui.Telescope .. " ",
          -- selection_caret = icons.ui.BoldArrowRight .. " ",
          initial_mode = "insert",
          -- select_strategy = "reset",
          sorting_strategy = "ascending",
          color_devicons = true,
          set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
          layout_config = {
            prompt_position = "top",
            -- preview_cutoff = 120,
          },
        },
        pickers = {
          -- find_files = { theme = "ivy" },
          -- help_tags = { theme = "ivy" },
          -- live_grep = { theme = "dropdown" },
          -- find_files = {
          --   previewer = false,
          --   -- path_display = formattedName,
          --   layout_config = {
          --     height = 0.4,
          --     prompt_position = "top",
          --     preview_cutoff = 120,
          --   },
          -- },
          -- git_files = {
          --   previewer = false,
          --   -- path_display = formattedName,
          --   layout_config = {
          --     height = 0.4,
          --     prompt_position = "top",
          --     preview_cutoff = 120,
          --   },
          -- },
          buffers = {
            mappings = {
              i = {
                ["<c-d>"] = actions.delete_buffer,
              },
              n = {
                ["<c-d>"] = actions.delete_buffer,
              },
            },
            previewer = false,
            initial_mode = "normal",
            theme = "dropdown",
            -- layout_config = {
            --   -- height = 0.4,
            --   -- width = 0.6,
            --   prompt_position = "top",
            --   -- preview_cutoff = 120,
            -- },
          },
          -- current_buffer_fuzzy_find = {
          --   previewer = true,
          --   layout_config = {
          --     prompt_position = "top",
          --     preview_cutoff = 120,
          --   },
          -- },
          -- live_grep = {
          --   only_sort_text = true,
          --   previewer = true,
          -- },
          -- grep_string = {
          --   only_sort_text = true,
          --   previewer = true,
          -- },
          -- lsp_references = {
          --   show_line = false,
          --   previewer = true,
          -- },
          -- treesitter = {
          --   show_line = false,
          --   previewer = true,
          -- },
          -- colorscheme = {
          --   enable_preview = true,
          -- },
        },
      }

      -- Enable fzf-native - load the extension
      telescope.load_extension("fzf")


      require("plugins.telescope.multigrep").setup()

      -- - Set the `dropdown` or `ivy` picker for `find_files` explicitly
      -- vim.keymap.set("n", "<space>en", function()
      --   -- local opts = require("telescope.themes").get_dropdown({
      --   --   cwd = vim.fn.stdpath("config")
      --   -- })
      --   local opts = require("telescope.themes").get_ivy({
      --     cwd = vim.fn.stdpath("config")
      --   })
      --   require("telescope.builtin").find_files(opts)
      --   -- require("telescope.builtin").find_files {
      --   --   cwd = vim.fn.stdpath("config")
      --   -- }
      -- end)
    end
  },
}
