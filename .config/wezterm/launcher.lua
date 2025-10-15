local SCOOP = os.getenv('scoop'):gsub('\\', '/')

local get_scoop_path = function(name, dir)
  return string.format('%s/apps/%s/current/%s', SCOOP, dir, name)
end

local generate_launcher = function(name, cmdline)
  return {
    args = cmdline,
    label = name,
    set_environment_variables = {},
  }
end

local create_menu = function(clients)
  local menu = {}
  for _, value in pairs(clients) do
    table.insert(menu, value)
  end
  return menu
end

local clients = {
  nyagos = generate_launcher('nyagos', { get_scoop_path('nyagos.exe', 'nyagos') }),
  nvim = generate_launcher('nvim', { get_scoop_path('bin/nvim.exe', 'neovim-nightly') }),
  bash = generate_launcher('bash', { get_scoop_path('usr/bin/bash.exe', 'git') }),
  ppb = generate_launcher(
    'ppb',
    { string.format('%s/ppbw.exe', os.getenv('PPX_DIR'):gsub('\\', '/')), '-k', '*option', 'common' }),
}
local menu = create_menu(clients)

return { clients = clients, menu = menu }
