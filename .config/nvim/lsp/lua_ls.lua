local helper = require('helper')
local _root = helper.mason_apps('lua-language-server')
local lazy_plugins = helper.xdg_path('data', 'lazy')

local PLACE_HOLDER = '-- workspace='
local WORKSPACE_LIBRARIES = {
  '$VIMRUNTIME/lua/vim',
  '$VIMRUNTIME/lua/uv/_meta.lua',
}
local TEST_LIBRARIES = {
  lazy_plugins .. '/plenary.nvim/lua/plenary/busted.lua',
  lazy_plugins .. '/plenary.nvim/lua/luassert',
  -- lazy_plugins .. '/plenary.nvim/lua/plenary/_meta/_luassert.lua',
}

local rgx_ph = vim.regex('^' .. PLACE_HOLDER)
local rgx_spec = vim.regex('_spec.lua$')

local function get_workspace()
  local library = vim.list_extend({}, WORKSPACE_LIBRARIES)
  local line = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1]
  if line and rgx_ph:match_str(line) then
    local buf_workspace = line:gsub(PLACE_HOLDER, '', 1)
    table.insert(library, buf_workspace)
  end
  local bufname = vim.api.nvim_buf_get_name(0)
  if rgx_spec:match_str(bufname) then
    for _, path in ipairs(TEST_LIBRARIES) do
      table.insert(library, path)
    end
  end
  return library
end

---@type vim.lsp.Config
return {
  cmd = { _root .. '/bin/lua-language-server.exe' },
  cmd_cwd = _root .. '/bin',

  filetypes = { 'lua' },
  root_markers = {
    '.emmyrc.json',
    '.luarc.json',
    '.luarc.jsonc',
    '.luacheckrc',
    '.stylua.toml',
    '.git',
  },
  workspace_required = false,
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
        pathStrict = false,
        path = { '?.lua', '?/init.lua', '?/types.lua' },
      },
      codeLens = { enable = true },
      completion = {
        enable = true,
        callSnippet = 'Replace',
        showWord = 'Enable',
        -- showWord = 'Disable',
      },
      diagnostics = {
        enable = true,
        globals = { 'vim', 'nyagos', 'describe', 'before_each', 'after_each', 'setup', 'teardown', 'it', 'Snacks' },
      },
      format = { enable = false },
      hint = {
        enable = true,
        setType = false,
        arrayIndex = 'Disable',
      },
      hover = { enable = true },
      semantic = { enable = false },
      signature_help = { enable = true },
      window = { progressBar = true, statusBar = false },
    },
  },
  on_init = function(client, _)
    ---@diagnostic disable-next-line: param-type-mismatch
    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua or {}, {
      workspace = {
        maxPreload = 2500,
        checkThirdParty = 'Disable',
        -- ignoreDir = { 'tests', 'spec' },
        library = get_workspace(),
      },
    })
  end,
}
