---@param config {type?:string, args?:string[]|fun():string[]?}
local function get_args(config)
  local args = type(config.args) == "function" and (config.args() or {}) or config.args or {}
  local args_str = type(args) == "table" and table.concat(args, " ") or args --[[@as string]]

  config = vim.deepcopy(config)
  ---@cast args string[]
  config.args = function()
    local new_args = vim.fn.expand(vim.fn.input("Run with args: ", args_str)) --[[@as string]]
    if config.type and config.type == "java" then
      ---@diagnostic disable-next-line: return-type-mismatch
      return new_args
    end
    return require("dap.utils").splitstr(new_args)
  end
  return config
end

return {
  {
    "mfussenegger/nvim-dap",
    desc = "Debugging support. Requires language specific adapters to be configured.",

    dependencies = {
      "rcarriga/nvim-dap-ui",
      -- virtual text for the debugger
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = {},
      },
      "nvim-telescope/telescope-dap.nvim",
      -- "one-small-step-for-vimkind",
      "nvim-dap-python",
    },

    -- stylua: ignore
    keys = {
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end,                                    desc = "Toggle Breakpoint" },
      { "<leader>dc", function() require("dap").continue() end,                                             desc = "Run/Continue" },
      { "<leader>da", function() require("dap").continue({ before = get_args }) end,                        desc = "Run with Args" },
      { "<leader>dC", function() require("dap").run_to_cursor() end,                                        desc = "Run to Cursor" },
      { "<leader>dg", function() require("dap").goto_() end,                                                desc = "Go to Line (No Execute)" },
      { "<leader>di", function() require("dap").step_into() end,                                            desc = "Step Into" },
      { "<leader>dj", function() require("dap").down() end,                                                 desc = "Down" },
      { "<leader>dk", function() require("dap").up() end,                                                   desc = "Up" },
      { "<leader>dl", function() require("dap").run_last() end,                                             desc = "Run Last" },
      { "<leader>do", function() require("dap").step_out() end,                                             desc = "Step Out" },
      { "<leader>dO", function() require("dap").step_over() end,                                            desc = "Step Over" },
      { "<leader>dP", function() require("dap").pause() end,                                                desc = "Pause" },
      { "<leader>dr", function() require("dap").repl.toggle() end,                                          desc = "Toggle REPL" },
      { "<leader>ds", function() require("dap").session() end,                                              desc = "Session" },
      { "<leader>dt", function() require("dap").terminate() end,                                            desc = "Terminate" },
      { "<leader>dw", function() require("dap.ui.widgets").hover() end,                                     desc = "Widgets" },
    },

    opts = function()
      local dap = require("dap")
      -- dap.adapters.lldb = {
      --   type = "executable",
      --   command = "C:/Tools/llvm/bin/lldb-dap.exe", -- adjust as needed, must be absolute path
      --   name = "lldb",
      -- detached = not JVim.is_win(),
      -- }
      -- -- https://github.com/llvm/llvm-project/tree/main/lldb/tools/lldb-dap#lldb-dap
      -- -- https://github.com/llvm/llvm-project/blob/main/lldb/tools/lldb-dap/package.json
      -- dap.configurations.cpp = {
      --   {
      --     name = "Launch",
      --     type = "lldb",
      --     request = "launch",
      --     program = function()
      --       return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/build/", "file")
      --     end,
      --     cwd = "${workspaceFolder}",
      --     stopOnEntry = false,
      --     -- args = {},
      --     -- runInTerminal = false,
      --
      --     -- WARN:
      --     -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
      --     --
      --     --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
      --     --
      --     -- Otherwise you might get the following error:
      --     --
      --     --    Error on launch: Failed to attach to the target process
      --     --
      --     -- But you should be aware of the implications:
      --     -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
      --   },
      -- }

      -- codelldb
      dap.adapters.codelldb = {
        type = "executable",
        command = "codelldb", -- or if not in $PATH: "/absolute/path/to/codelldb"
        -- command = "C:/Tools/codelldb-win32-x64/extension/adapter/codelldb",

        -- On windows you may have to uncomment this:
        detached = not JVim.is_win(),
      }
      dap.configurations.cpp = {
        {
          name = "Launch file",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
        },
      }

      dap.configurations.c = dap.configurations.cpp
    end,

    config = function()
      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

      for name, sign in pairs(JVim.config.icons.dap) do
        sign = type(sign) == "table" and sign or { sign }
        vim.fn.sign_define(
          "Dap" .. name,
          { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
        )
      end

      -- TODO(jm): See if this is worth it.
      -- setup dap config by VsCode launch.json file
      -- local vscode = require("dap.ext.vscode")
      -- local json = require("plenary.json")
      -- vscode.json_decode = function(str)
      --   return vim.json.decode(json.json_strip_comments(str))
      -- end
      require("telescope").load_extension("dap")
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    -- stylua: ignore
    keys = {
      { "<leader>du", function() require("dapui").toggle({}) end, desc = "Dap UI" },
      { "<leader>de", function() require("dapui").eval() end,     desc = "Eval",  mode = { "n", "v" } },
    },
    opts = {},
    config = function(_, opts)
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup(opts)
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open({})
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close({})
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close({})
      end
    end,
  },
  -- {
  --   "jbyuki/one-small-step-for-vimkind",
  --   ft = { "lua" },
  --   -- stylua: ignore
  --   config = function()
  --     local dap = require("dap")
  --     dap.adapters.nlua = function(callback, conf)
  --       local adapter = {
  --         type = "server",
  --         host = conf.host or "127.0.0.1",
  --         port = conf.port or 8086,
  --       }
  --       if conf.start_neovim then
  --         local dap_run = dap.run
  --         dap.run = function(c)
  --           adapter.port = c.port
  --           adapter.host = c.host
  --         end
  --         require("osv").run_this()
  --         dap.run = dap_run
  --       end
  --       callback(adapter)
  --     end
  --     dap.configurations.lua = {
  --       {
  --         type = "nlua",
  --         request = "attach",
  --         name = "Run this file",
  --         start_neovim = {},
  --       },
  --       {
  --         type = "nlua",
  --         request = "attach",
  --         name = "Attach to running Neovim instance (port = 8086)",
  --         port = 8086,
  --       },
  --     }
  --   end,
  -- },
  {
    "mfussenegger/nvim-dap-python",
    -- stylua: ignore
    keys = {
      { "<leader>dPt", function() require('dap-python').test_method() end, desc = "Debug Method", ft = "python" },
      { "<leader>dPc", function() require('dap-python').test_class() end,  desc = "Debug Class",  ft = "python" },
    },
    config = function()
      -- TODO(jm): Try to take into account the local .venv of the repository here
      -- Look how this is done in lsp/init.lua for clangd, or do something like
      --   local root_patterns = { ".git", ".clang-format", "pyproject.toml", "setup.py" }
      --   local root_dir = vim.fs.dirname(vim.fs.find(root_patterns, { upward = true })[1])
      if vim.fn.has("win32") == 1 then
        require("dap-python").setup(JVim.get_pkg_path("debugpy", "/venv/Scripts/pythonw.exe"))
      else
        require("dap-python").setup(JVim.get_pkg_path("debugpy", "/venv/bin/python"))
      end
    end,
  },
}
