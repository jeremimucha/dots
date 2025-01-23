-- lua/config/plugins/mini.lua
-- Each imported plugin returns a list of specifications
return {
  {
    "echasnovski/mini.nvim",
    enabled = true,
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci"  - [C]hange [I]nside ["]quote
      -- require("mini.ai").setup { n_lines = 500 }


    -- auto pairs
    local pairs = require('mini.pairs')
    pairs.setup {
      -- JVim.mini.pairs()
        modes = { insert = true, command = true, terminal = false },
        -- skip autopair when next character is one of these
        skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
        -- skip autopair when the cursor is inside these treesitter nodes
        skip_ts = { "string" },
        -- skip autopair when next character is closing pair
        -- and there are more closing pairs than opening pairs
        skip_unbalanced = true,
        -- better deal with markdown code blocks
        markdown = true,
    }
  -- Better text-objects
      local ai = require("mini.ai")
      local mini_ai_opts = {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({ -- code block
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }), -- function
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }), -- class
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- tags
          d = { "%f[%d]%d+" }, -- digits
          e = { -- Word with case
            { "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
            "^().*()$",
          },
          -- g = JVim.mini.ai_buffer, -- buffer
          u = ai.gen_spec.function_call(), -- u for "Usage"
          U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
        },
      }
      ai.setup(mini_ai_opts)
      JVim.on_load("which", function ()
        vim.schedule(function ()
          JVim.mini.ai_whichkey(mini_ai_opts)
        end)
      end)

      local statusline = require("mini.statusline")
      statusline.setup { use_icons = vim.g.have_nerd_font }

      local icons = require("mini.icons")
      icons.setup()

      local cursorword = require("mini.cursorword")
      cursorword.setup({
        -- underline = false
      })

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd"   - [S]urround [D]elete ["]quotes
      -- - sr)"  - [S]urround [R]eplace [)] ["]
      require("mini.surround").setup()

      local files = require("mini.files")
      files.setup({
        -- General options
        options = {
          --   -- Whether to delete permanently or move into module-specific trash
          --   permanent_delete = true,
          --   -- Whether to use for editing directories
          use_as_default_explorer = true,
        },
        mappings = {
          close       = 'q',
          go_in       = 'l',
          go_in_plus  = 'L',
          go_out      = 'h',
          go_out_plus = 'H',
          mark_goto   = "'",
          mark_set    = 'm',
          reset       = '<BS>',
          reveal_cwd  = '@',
          show_help   = 'g?',
          synchronize = '=',
          trim_left   = '<',
          trim_right  = '>',
        },
      })

      -- [[ MiniFiles keymaps ]]
      vim.keymap.set("n", "<leader>fe", "<cmd>lua MiniFiles.open()<CR>")                             -- "explorer root"
      vim.keymap.set("n", "<leader>fE", "<cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>") -- "explorer current buffer"
    end
  }
}
