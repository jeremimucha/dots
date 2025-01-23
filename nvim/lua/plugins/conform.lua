return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      -- Customize or remove this keymap to your liking
      "<leader>cf",
      function()
        require("conform").format({ async = true })
      end,
      desc = "Format buffer",
    },
    {
      "<leader>ctf",
      function() JVim.toggle_global("autoformat", "Autoformat on Save") end,
      desc = "Toggle Autoformat on Save",
    },
  },
  -- This will provide type hinting with LuaLS
  ---@module "conform"
  ---@type conform.setupOpts
  opts = {
    -- Define your formatters
    formatters_by_ft = {
      lua = { "stylua" },
      -- python = { "isort", "black" },
      python = function(bufnr)
        if require("conform").get_formatter_info("ruff_format", bufnr).available then
          return { "ruff_format" }
        else
          return { "isort", "black" }
        end
      end,
      cpp = { "clang-format" },
      c = { "clang-format" },
      -- Use the "*" filetype to run formatters on all filetypes.
      -- ["*"] = { "codespell" },
      -- Use the "_" filetype to run formatters on filetypes that don't
      -- have other formatters configured.
      -- ["_"] = { "trim_whitespace" },
    },
    -- Set default options
    default_format_opts = {
      lsp_format = "fallback",
    },
    -- Set up format-on-save
    format_on_save = function(bufnr)
      -- Disable autoformat on certain filetypes
      -- local ignore_filetypes = { "sql", "java" }
      -- if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
      --   return
      -- end
      -- Disable with a global or buffer-local variable
      -- if not vim.g.autoformat or not vim.b[bufnr].autoformat then
      if not vim.g.autoformat then
        return
      end
      -- Disable autoformat for files in a certain path
      -- local bufname = vim.api.nvim_buf_get_name(bufnr)
      -- if bufname:match("/node_modules/") then
      --   return
      -- end
      -- ...additional logic...
      -- I recommend these options. See :help conform.format for details.
      return { timeout_ms = 500, lsp_format = "fallback" }
    end,
    -- Customize formatters
    formatters = {
      -- shfmt = {
      --   prepend_args = { "-i", "2" },
      -- },
      clang_format = {
        prepend_args = { "-style=file" }
      }
    },
    -- Set the log level. Use `:ConformInfo` to see the location of the log file.
    -- log_level = vim.log.levels.ERROR,
    -- Conform will notify you when a formatter errors
    -- notify_on_error = true,
    -- Conform will notify you when no formatters are available for the buffer
    -- notify_no_formatters = true,
  },
  init = function()
    -- If you want the formatexpr, here is the place to set it
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    vim.g.autoformat = true
  end,
}
