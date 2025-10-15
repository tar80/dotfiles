local wezterm = require('wezterm')

---@class Config
---@field init fun(color_scheme, default_cwd, profiles):table<string,any>
local M = {}

---Initialize Config
---@param color_scheme string colorscheme to apply
---@param default_cwd string default working directory
---@param profiles string[] cornfiguration profiles
---@return table<string,any>
function M.init(color_scheme, default_cwd, profiles)
  local self = {}
  local workspace = wezterm.mux.get_active_workspace()
  self.color_scheme = color_scheme
  self.default_cwd = default_cwd
  if workspace == 'debug' then
    self = wezterm.config_builder()
    self.log_unknown_escape_sequences = true
    self.debug_key_events = true
  else
    self.log_unknown_escape_sequences = false
    self.debug_key_events = false
  end

  for _, name in ipairs(profiles) do
    local ok, opts = pcall(require, string.format('config.%s', name))
    if not ok then
      wezterm.log_error(string.format('Profile is not found: %s', name))
    else
      for k, v in pairs(opts) do
        if self[k] ~= nil then
          wezterm.log_warn('Duplicate config option detected: ', { old = self[k], new = opts[k] })
          goto continue
        end
        self[k] = v
        ::continue::
      end
    end
  end

  return self
end

return M
