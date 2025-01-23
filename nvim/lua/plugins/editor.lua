return {
  -- search/replace in multiple files
  {
    "MagicDuck/grug-far.nvim",
    opts = { headerMaxWidth = 80 },
    cmd = "GrugFar",
    keys = {
      {
        "<leader>sr",
        function()
          local grug = require("grug-far")
          local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
          grug.open({
            transient = true,
            prefills = {
              filesFilter = ext and ext ~= "" and "*." .. ext or nil,
            },
          })
        end,
        mode = { "n", "v" },
        desc = "Search and Replace",
      },
    },
  },

  -- Flash enhances the built-in search functionality by showing labels
  -- at the end of each match, letting you quickly jump to a specific
  -- location.
  -- {
  --   "folke/flash.nvim",
  --   event = "VeryLazy",
  --   vscode = true,
  --   ---@type Flash.Config
  --   opts = {},
  --   -- stylua: ignore
  --   keys = {
  --     { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
  --     { "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
  --     { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
  --     { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
  --     { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
  --   },
  -- },

  -- which-key helps you remember key bindings by showing a popup
  -- with the active keybindings of the command you started typing.
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts_extend = { "spec" },
    opts = {
      preset = "helix",
      defaults = {},
      spec = {
        {
          mode = { "n", "v" },
          { "<leader>c", group = "code" },
          { "<leader>d", group = "debug" },
          { "<leader>dp", group = "profiler" },
          { "<leader>f", group = "file/find" },
          { "<leader>g", group = "git" },
          { "<leader>gh", group = "hunks" },
          { "<leader>q", group = "quit/session" },
          { "<leader>s", group = "search" },
          { "<leader>u", group = "ui", icon = { icon = "󰙵 ", color = "cyan" } },
          { "<leader>x", group = "diagnostics/quickfix", icon = { icon = "󱖫 ", color = "green" } },
          { "[", group = "prev" },
          { "]", group = "next" },
          { "g", group = "goto" },
          { "gs", group = "surround" },
          { "z", group = "fold" },
          {
            "<leader>b",
            group = "buffer",
            expand = function()
              return require("which-key.extras").expand.buf()
            end,
          },
          {
            "<leader>w",
            group = "windows",
            proxy = "<c-w>",
            expand = function()
              return require("which-key.extras").expand.win()
            end,
          },
          -- better descriptions
          { "gx", desc = "Open with system app" },
        },
      },
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Keymaps (which-key)",
      },
      {
        "<c-w><space>",
        function()
          require("which-key").show({ keys = "<c-w>", loop = true })
        end,
        desc = "Window Hydra Mode (which-key)",
      },
    },
    -- config = function(_, opts)
    --   local wk = require("which-key")
    --   wk.setup(opts)
    -- end,
  },

  -- git signs highlights text that has changed since the list
  -- git commit, and also lets you interactively stage & unstage
  -- hunks in a commit.
  -- {
  --   "lewis6991/gitsigns.nvim",
  --   event = "LazyFile",
  --   opts = {
  --     signs = {
  --       add = { text = "▎" },
  --       change = { text = "▎" },
  --       delete = { text = "" },
  --       topdelete = { text = "" },
  --       changedelete = { text = "▎" },
  --       untracked = { text = "▎" },
  --     },
  --     signs_staged = {
  --       add = { text = "▎" },
  --       change = { text = "▎" },
  --       delete = { text = "" },
  --       topdelete = { text = "" },
  --       changedelete = { text = "▎" },
  --     },
  --     on_attach = function(buffer)
  --       local gs = package.loaded.gitsigns

  --       local function map(mode, l, r, desc)
  --         vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
  --       end

  --       -- stylua: ignore start
  --       map("n", "]h", function()
  --         if vim.wo.diff then
  --           vim.cmd.normal({ "]c", bang = true })
  --         else
  --           gs.nav_hunk("next")
  --         end
  --       end, "Next Hunk")
  --       map("n", "[h", function()
  --         if vim.wo.diff then
  --           vim.cmd.normal({ "[c", bang = true })
  --         else
  --           gs.nav_hunk("prev")
  --         end
  --       end, "Prev Hunk")
  --       map("n", "]H", function() gs.nav_hunk("last") end, "Last Hunk")
  --       map("n", "[H", function() gs.nav_hunk("first") end, "First Hunk")
  --       map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
  --       map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
  --       map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
  --       map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
  --       map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
  --       map("n", "<leader>ghp", gs.preview_hunk_inline, "Preview Hunk Inline")
  --       map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
  --       map("n", "<leader>ghB", function() gs.blame() end, "Blame Buffer")
  --       map("n", "<leader>ghd", gs.diffthis, "Diff This")
  --       map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
  --       map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
  --     end,
  --   },
  -- },
  -- {
  --   "gitsigns.nvim",
  --   opts = function()
  --     Snacks.toggle({
  --       name = "Git Signs",
  --       get = function()
  --         return require("gitsigns.config").config.signcolumn
  --       end,
  --       set = function(state)
  --         require("gitsigns").toggle_signs(state)
  --       end,
  --     }):map("<leader>uG")
  --   end,
  -- },

  -- better diagnostics list and others
  -- TODO(jm): Enable folke/trouble
  -- {
  --   "folke/trouble.nvim",
  --   cmd = { "Trouble" },
  --   opts = {
  --     modes = {
  --       lsp = {
  --         win = { position = "right" },
  --       },
  --     },
  --   },
  --   keys = {
  --     { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
  --     { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
  --     { "<leader>cs", "<cmd>Trouble symbols toggle<cr>", desc = "Symbols (Trouble)" },
  --     { "<leader>cS", "<cmd>Trouble lsp toggle<cr>", desc = "LSP references/definitions/... (Trouble)" },
  --     { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
  --     { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
  --     {
  --       "[q",
  --       function()
  --         if require("trouble").is_open() then
  --           require("trouble").prev({ skip_groups = true, jump = true })
  --         else
  --           local ok, err = pcall(vim.cmd.cprev)
  --           if not ok then
  --             vim.notify(err, vim.log.levels.ERROR)
  --           end
  --         end
  --       end,
  --       desc = "Previous Trouble/Quickfix Item",
  --     },
  --     {
  --       "]q",
  --       function()
  --         if require("trouble").is_open() then
  --           require("trouble").next({ skip_groups = true, jump = true })
  --         else
  --           local ok, err = pcall(vim.cmd.cnext)
  --           if not ok then
  --             vim.notify(err, vim.log.levels.ERROR)
  --           end
  --         end
  --       end,
  --       desc = "Next Trouble/Quickfix Item",
  --     },
  --   },
  -- },

  -- Finds and lists all of the TODO, HACK, BUG, etc comment
  -- in your project and loads them into a browsable list.
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    -- event = "VimEnter",
    opts = {
      -- signs = false
      highlight = {
        multiline = false, -- enable multine todo comments
        before = "",       -- "fg" or "bg" or empty
        keyword = "bg",    -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty. (wide and wide_bg is the same as bg, but will also highlight surrounding characters, wide_fg acts accordingly but with fg)
        after = "",        -- "fg" or "bg" or empty
        -- TODO(jm): Just testing the pattern
        -- TODO: Testing testing
        pattern = { -- pattern or table of patterns, used for highlighting (vim regex)
          [[.*<(KEYWORDS)\s*:]],
          [[.*<(KEYWORDS)\(.*\)\s*:]]
        },
        comments_only = true,      -- uses treesitter to match keywords in comments only
        max_line_len = 160,        -- ignore lines longer than this
        exclude = {},              -- list of file types to exclude highlighting
      },
      pattern = [[\b(KEYWORDS):]], -- ripgrep regex
      -- pattern = [[\b(KEYWORDS)(?:\(.*\))?:]],
      -- pattern = [[\b(KEYWORDS).*?:]],
    },
    -- stylua: ignore
    keys = {
      { "]t",         function() require("todo-comments").jump_next() end, desc = "Next Todo Comment" },
      { "[t",         function() require("todo-comments").jump_prev() end, desc = "Previous Todo Comment" },
      -- { "<leader>xt", "<cmd>Trouble todo toggle<cr>",                                   desc = "Todo (Trouble)" },
      -- { "<leader>xT", "<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
      { "<leader>st", "<cmd>TodoTelescope<cr>",                            desc = "Todo" },
      { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>",    desc = "Todo/Fix/Fixme" },

      {
        "<leader>tt",
        function()
          JVim.toggle_global("todo_highlights", "Todo-Comments Highlights")
          if vim.g.todo_highlights then
            require("todo-comments").enable()
          else
            require("todo-comments").disable()
          end
        end,
        desc = "Toggle Todo-Comments"
      },
    },
    init = function()
      vim.g.todo_highlights = false -- NOTE(jm): Make sure to sync this with lazy initialization - if lazy-init -> false else true
    end,
  },
}
