local dashboard_headers = {
  -- neovim =
  [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
  -- doom =
  [[
=================     ===============     ===============   ========  ========
\\ . . . . . . .\\   //. . . . . . .\\   //. . . . . . .\\  \\. . .\\// . . //
||. . ._____. . .|| ||. . ._____. . .|| ||. . ._____. . .|| || . . .\/ . . .||
|| . .||   ||. . || || . .||   ||. . || || . .||   ||. . || ||. . . . . . . ||
||. . ||   || . .|| ||. . ||   || . .|| ||. . ||   || . .|| || . | . . . . .||
|| . .||   ||. _-|| ||-_ .||   ||. . || || . .||   ||. _-|| ||-_.|\ . . . . ||
||. . ||   ||-'  || ||  `-||   || . .|| ||. . ||   ||-'  || ||  `|\_ . .|. .||
|| . _||   ||    || ||    ||   ||_ . || || . _||   ||    || ||   |\ `-_/| . ||
||_-' ||  .|/    || ||    \|.  || `-_|| ||_-' ||  .|/    || ||   | \  / |-_.||
||    ||_-'      || ||      `-_||    || ||    ||_-'      || ||   | \  / |  `||
||    `'         || ||         `'    || ||    `'         || ||   | \  / |   ||
||            .===' `===.         .==='.`===.         .===' /==. |  \/  |   ||
||         .=='   \_|-_ `===. .==='   _|_   `===. .===' _-|/   `==  \/  |   ||
||      .=='    _-'    `-_  `='    _-'   `-_    `='  _-'   `-_  /|  \/  |   ||
||   .=='    _-'          `-__\._-'         `-_./__-'         `' |. /|  |   ||
||.=='    _-'                                                     `' |  /==.||
=='    _-'                                                            \/   `==
\   _-'                                                                `-_   /
 `''                                                                      ``']],
  -- NOTE: Make sure the trailing whitespace in the header definition is preserved.
  -- not_vscode =
  [[
███╗   ██╗ ██████╗ ████████╗    ██╗   ██╗███████╗ ██████╗ ██████╗ ██████╗ ███████╗
████╗  ██║██╔═══██╗╚══██╔══╝    ██║   ██║██╔════╝██╔════╝██╔═══██╗██╔══██╗██╔════╝
██╔██╗ ██║██║   ██║   ██║       ██║   ██║███████╗██║     ██║   ██║██║  ██║█████╗  
██║╚██╗██║██║   ██║   ██║       ╚██╗ ██╔╝╚════██║██║     ██║   ██║██║  ██║██╔══╝  
██║ ╚████║╚██████╔╝   ██║        ╚████╔╝ ███████║╚██████╗╚██████╔╝██████╔╝███████╗
╚═╝  ╚═══╝ ╚═════╝    ╚═╝         ╚═══╝  ╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝ ╚══════╝]],
}
local random_header = (function()
  math.randomseed()
  return dashboard_headers[math.random(3)]
end)()


---@class snacks.dashboard.Config
---@field enabled? boolean
---@field sections snacks.dashboard.Section
---@field formats table<string, snacks.dashboard.Text|fun(item:snacks.dashboard.Item, ctx:snacks.dashboard.Format.ctx):snacks.dashboard.Text>
return {
  {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
      -- vvv dashboard vvv
      dashboard = {
        width = 60,
        row = nil,                                                                   -- dashboard position. nil for center
        col = nil,                                                                   -- dashboard position. nil for center
        pane_gap = 4,                                                                -- empty columns between vertical panes
        autokeys = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", -- autokey sequence
        -- These settings are used by some built-in sections
        preset = {
          -- Defaults to a picker that supports `fzf-lua`, `telescope.nvim` and `mini.pick`
          ---@type fun(cmd:string, opts:table)|nil
          pick = nil,
          -- Used by the `keys` section to show keymaps.
          -- Set your custom keymaps here.
          -- When using a function, the `items` argument are the default keymaps.
          ---@type snacks.dashboard.Item[]
          keys = {
            { icon = " ", key = "f", desc = "Find File", action = ":lua require('telescope.builtin').find_files()" },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua require('telescope.builtin').oldfiles()" },
            { icon = " ", key = "c", desc = "Config", action = ":lua require('telescope.builtin').find_files({ cwd = vim.fn.stdpath('config')})" },
            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
          header = random_header,
          -- Used by the `header` section
        },
        -- item field formatters
        formats = {
          -- icon = function(item)
          --   if item.file and item.icon == "file" or item.icon == "directory" then
          --     return M.icon(item.file, item.icon)
          --   end
          --   return { item.icon, width = 2, hl = "icon" }
          -- end,
          footer = { "%s", align = "center" },
          header = { "%s", align = "center" },
          file = function(item, ctx)
            local fname = vim.fn.fnamemodify(item.file, ":~")
            fname = ctx.width and #fname > ctx.width and vim.fn.pathshorten(fname) or fname
            if #fname > ctx.width then
              local dir = vim.fn.fnamemodify(fname, ":h")
              local file = vim.fn.fnamemodify(fname, ":t")
              if dir and file then
                file = file:sub(-(ctx.width - #dir - 2))
                fname = dir .. "/…" .. file
              end
            end
            local dir, file = fname:match("^(.*)/(.+)$")
            return dir and { { dir .. "/", hl = "dir" }, { file, hl = "file" } } or { { fname, hl = "file" } }
          end,
        },
        sections = {
          { section = "header" },
          { section = "keys",   gap = 1, padding = 1 },
          { section = "startup" },
        },
      },
      -- ^^^ dashboard ^^^
      terminal = { enabled = false },
      -- indent = {
      --   only_scope = true,   -- only show indent guides of the scope
      --   only_current = true, -- only show indent guides in the current window
      --   hl = "SnacksIndent", ---@type string|string[] hl groups for indent guides
      --   animate = {
      --     enabled = false,
      --   },
      --   ---@class snacks.indent.Scope.Config: snacks.scope.Config
      --   scope = {
      --     enabled = true, -- enable highlighting the current scope
      --     -- priority = 200,
      --     -- char = "│",
      --     -- underline = false, -- underline the start of the scope
      --     only_current = true, -- only show scope in the current window
      --     -- hl = "SnacksIndentScope", ---@type string|string[] hl group for scopes
      --   },
      -- }
    }
  }
}
