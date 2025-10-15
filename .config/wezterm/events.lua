local wezterm = require('wezterm')
local colors = require('colors')
local launcher = require('launcher')
local mux = wezterm.mux
local act = wezterm.action

---@desc Workspace select menu
---@see https://zenn.dev/sankantsu/articles/e713d52825dbbb
wezterm.on('user_select_workspace', function(win, pane)
  local workspaces = {}
  for i, name in ipairs(wezterm.mux.get_workspace_names()) do
    table.insert(workspaces, { id = name, label = string.format('%d. %s', i, name) })
  end
  table.insert(workspaces, { id = 'new', label = '0. Create new workspace' })
  local current = wezterm.mux.get_active_workspace()
  win:perform_action(
    act.InputSelector({
      action = wezterm.action_callback(function(_, _, id, label)
        if not id and not label then
          wezterm.log_info('Workspace selection canceled')
        elseif id == 'new' then
          win:perform_action(
            act.SwitchToWorkspace({ spawn = launcher.clients[win:active_tab():get_title():gsub('%s', '')] }),
            pane
          )
        else
          win:perform_action(act.SwitchToWorkspace({ name = id }), pane)
        end
      end),
      title = 'Select workspace',
      choices = workspaces,
      fuzzy = true,
      fuzzy_description = string.format('Select workspace: %s -> ', current),
    }),
    pane
  )
end)

---@desc Confirm only the last pane and exit
wezterm.on('user_toggle_debug_mode', function(win, pane)
  local workspace = mux.get_active_workspace()
  if workspace == 'debug' then
    mux.rename_workspace(workspace, 'default')
  else
    mux.rename_workspace(workspace, 'debug')
  end
end)

---@desc Confirm only the last pane and exit
wezterm.on('user_toggle_screen_mode', function(win, pane)
  local workspace = mux.get_active_workspace()
  local overrides = win:get_config_overrides() or {}
  if workspace == 'screen' then
    mux.rename_workspace(workspace, 'default')
    overrides.color_scheme = nil
    overrides.window_background_gradient = nil
  else
    mux.rename_workspace(workspace, 'screen')
    overrides.color_scheme = 'Catppuccin Latte'
    overrides.window_background_gradient = {
      orientation = 'Vertical',
      colors = { '#FFFFFF', '#FFEEEE', '#FFFFFF' },
      interpolation = 'Linear',
      blend = 'Rgb',
      noise = 0,
    }
  end
  win:set_config_overrides(overrides)
end)

---@desc Confirm only the last pane and exit
wezterm.on('user_close', function(win, pane)
  local panes = pane:tab():panes()
  local has_confirm = #panes == 1
  win:perform_action(act.CloseCurrentPane({ confirm = has_confirm }), pane)
end)

---@desc maximize all displayed windows on startup
wezterm.on('gui-startup', function(cmd)
  local tab, pane, win =
    mux.spawn_window({
      args = { string.format('%s/ppbw.exe', os.getenv('PPX_DIR')), '-q', '-bootid:w' },
      set_environment_variables = { PATH = 'D:\\Apps\\bin;' .. os.getenv('GIT_INSTALL_ROOT') .. '\\usr\\bin;' .. os.getenv('PATH') }
    })
  win:gui_window():maximize()
  if cmd then
    local client = launcher.clients[cmd.args[1]]
    if client then
      cmd.args[1] = client.args[1]
      cmd.label = client.label
      cmd.set_environment_variables = {}
    end
    win:spawn_tab(cmd)
  end
end)

-- wezterm.on('gui-attached', function(domain)
--   wezterm.log_info(domain)
-- end)

wezterm.on('user-var-changed', function(win, pane, name, value)
  if name == 'focus' or name == 'select' then
    local window = win:mux_window()
    for _, item in ipairs(window:tabs_with_info()) do
      if item.tab:get_title():find(value) then
        item.tab:activate()
        if name == 'focus' then
          win:focus()
        end
      end
    end
    return
  end
  wezterm.log_info('var1', name, value)
end)

local function tab_title(tab_info)
  local title = tab_info.tab_title
  -- if the tab title is explicitly set, take that
  if not title or #title == 0 then
    title = string.format(' %s ', tab_info.active_pane.title:gsub('^([^%s%.%(]+).*$', '%1'))
    mux.get_tab(tab_info.tab_id):set_title(title)
  end
  return title
end

---@desc Decide on the window title
wezterm.on('format-window-title', function(tab, pane, tabs, panes, config)
  local zoomed = ''
  if tab.active_pane.is_zoomed then
    zoomed = '- zoomed'
  end

  return string.format('wezterm%s', zoomed)
end)

---@desc Decide on the tab title
wezterm.on('format-tab-title', function(tab, tabs, panes, conf, hover, max_width)
  local fg = tab.is_active and colors.tab.simple.active or colors.tab.simple.noactive
  local bg = 'NONE'
  return {
    { Background = { Color = bg } },
    { Foreground = { Color = fg } },
    { Text = tab_title(tab) },
  }
end)

---@desc decorated title
-- wezterm.on('format-tab-title', function(tab, tabs, panes, conf, hover, max_width)
--   local GLYPH_BRACKET_LEFT = wezterm.nerdfonts.ple_left_half_circle_thick
--   local GLYPH_BRACKET_RIGHT = wezterm.nerdfonts.ple_right_half_circle_thick
--   local bg, fg
--   if tab.is_active then
--     bg, fg = colors.tab.deco.active.fg, colors.tab.deco.active.bg
--   else
--     bg, fg = colors.tab.deco.noactive.fg, colors.tab.deco.noactive.bg
--   end
--   local edge_fg, edge_bg = bg, 'none'
--   return {
--     { Background = { Color = edge_bg } },
--     { Foreground = { Color = edge_fg } },
--     { Text = GLYPH_BRACKET_LEFT },
--     { Background = { Color = bg } },
--     { Foreground = { Color = fg } },
--     { Text = tab_title(tab) },
--     { Background = { Color = edge_bg } },
--     { Foreground = { Color = edge_fg } },
--     { Text = GLYPH_BRACKET_RIGHT },
--   }
-- end)

---@desc Show which key table is active in the status area
wezterm.on('update-right-status', function(window, pane)
  local mode = window:active_key_table()
  local workspace = wezterm.mux.get_active_workspace()
  if mode then
    mode = string.format('%s', mode)
    window:set_right_status(wezterm.format({
      { Foreground = colors.status.mode.fg },
      { Background = colors.status.mode.bg },
      { Text = string.format('<%s> ', mode) },
      { Foreground = colors.status.workspace.fg },
      { Background = colors.status.workspace.bg },
      { Text = string.format('[workspace:%s]', workspace) },
    }))
  else
    window:set_right_status(wezterm.format({
      { Foreground = colors.status.workspace.fg },
      { Background = colors.status.workspace.bg },
      { Text = string.format('[workspace:%s]', workspace) },
    }))
  end
end)

wezterm.on("window-focus-changed", function(window, pane)
  local zenhan_path =  string.format('/apps/zenhan/current/zenhan.exe', os.getenv('Scoop'))
  os.execute(zenhan_path)
end)
