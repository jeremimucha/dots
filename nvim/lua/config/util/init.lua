-- local LazyUtil = require("lazy.core.util")
--
local M = {}

-- setmetatable(M, {
--   __index = function(t, k)
--     if LazyUtil[k] then
--       return LazyUtil[k]
--     end
--     ---@diagnostic disable-next-line: no-unknown
--     t[k] = require("config.util." .. k)
--     -- M.deprecated.decorate(k, t[k])
--     return t[k]
--   end,
-- })

function M.hello()
  vim.api.nvim_echo({
    {
      "Hello from util!\n"
    },
  }, true, {})
end

function M.is_loaded(name)
  local Config = require("lazy.core.config")
  return Config.plugins[name] and Config.plugins[name]._.loaded
end

---@param name string
---@param fn fun(name:string)
function M.on_load(name, fn)
  if M.is_loaded(name) then
    fn(name)
  else
    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyLoad",
      callback = function(event)
        if event.data == name then
          fn(name)
          return true
        end
      end,
    })
  end
end

M.lsp_action = setmetatable({}, {
  __index = function(_, action)
    return function()
      vim.lsp.buf.code_action({
        apply = true,
        context = {
          only = { action },
          diagnostics = {},
        },
      })
    end
  end,
})

---@param on_attach fun(client:vim.lsp.Client, buffer)
---@param name? string
function M.on_lsp_attach(on_attach, name)
  return vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local buffer = args.buf ---@type number
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client and (not name or client.name == name) then
        return on_attach(client, buffer)
      end
    end,
  })
end

--- Gets a path to a package in the Mason registry.
---@param pkg string
---@param path? string
---@param opts? { warn?: boolean }
function M.get_pkg_path(pkg, path, opts)
  pcall(require, "mason") -- make sure Mason is loaded. Will fail when generating docs
  local root = vim.env.MASON or (vim.fn.stdpath("data") .. "/mason")
  opts = opts or {}
  opts.warn = opts.warn == nil and true or opts.warn
  path = path or ""
  local ret = root .. "/packages/" .. pkg .. "/" .. path
  if opts.warn and not vim.loop.fs_stat(ret) and not require("lazy.core.config").headless() then
    vim.api.nvim_notify(
    ("Mason package path not found for **%s**:\n- `%s`\nYou may need to force update the package."):format(pkg, path),
      vim.log.levels.WARN, {})
  end
  return ret
end

function M.is_win()
  return vim.uv.os_uname().sysname:find("Windows") ~= nil
end

---@param name string
function M.get_plugin(name)
  return require("lazy.core.config").spec.plugins[name]
end

---@param name string
---@param path string?
function M.get_plugin_path(name, path)
  local plugin = M.get_plugin(name)
  path = path and "/" .. path or ""
  return plugin and (plugin.dir .. path)
end

---@param plugin string
function M.has(plugin)
  return M.get_plugin(plugin) ~= nil
end

---@param name string
function M.opts(name)
  local plugin = M.get_plugin(name)
  if not plugin then
    return {}
  end
  local Plugin = require("lazy.core.plugin")
  return Plugin.values(plugin, "opts", false)
end

function M.toggle_option(opt, name)
  local message = name
  local new_state = not vim.opt[opt]:get()
  if new_state then
    message = message .. " ON"
  else
    message = message .. " OFF"
  end
  vim.opt[opt] = new_state
  vim.api.nvim_notify(message, vim.log.levels.INFO, {})
end

function M.toggle_global(opt, name)
  local message = name
  local new_state = not vim.g[opt]
  if new_state then
    message = message .. " ON"
  else
    message = message .. " OFF"
  end
  vim.g[opt] = new_state
  vim.api.nvim_notify(message, vim.log.levels.INFO, {})
end

return M
