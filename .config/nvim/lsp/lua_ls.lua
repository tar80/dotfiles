local helper = require('helper')
local luals_root = helper.mason_apps('lua-language-server')
local lazy_plugins = helper.xdg_path('data', 'lazy')

local PLACE_HOLDER = '-- workspace='
local WORKSPACE_LIBRARY = {
  luals_root .. '/locale/ja-jp/meta.lua',
  lazy_plugins .. '/snacks.nvim/lua/snacks/meta',
  lazy_plugins .. '/flash.nvim/lua/flash/meta',
  '$VIMRUNTIME/lua/vim',
  '$VIMRUNTIME/lua/vim/shared.lua',
  '$VIMRUNTIME/lua/vim/lsp',
  '$VIMRUNTIME/lua/vim/treesitter',
  '${3rd}/luv/library',
  '${3rd}/busted/library',
  '${3rd}/luassert/library',
}
local regex = vim.regex('^' .. PLACE_HOLDER)

local function get_workspace()
  local library = WORKSPACE_LIBRARY
  local line = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1]
  if regex:match_str(line) then
    local buf_workspace = line:gsub(PLACE_HOLDER, '', 1)
    table.insert(library, buf_workspace)
  end
  return library
end

---@type vim.lsp.Config
return {
  cmd = { luals_root .. '/bin/lua-language-server.exe' },
  cmd_cwd = luals_root .. '/bin',
  filetypes = { 'lua' },
  root_markers = {
    '.luarc.json',
    '.luarc.jsonc',
    '.luacheckrc',
    '.stylua.toml',
    'stylua.toml',
    'selene.toml',
    'selene.yml',
    '.git',
  },
  workspace_required = false,
  settings = { Lua = {} },
  on_init = function(client, _)
    -- if client.workspace_folders then
    --   local path = client.workspace_folders[1].name
    --   if vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc') then
   --     return
    --   end
    -- end
    ---@diagnostic disable-next-line: param-type-mismatch
    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      completion = {
        enable = true,
        callSnippet = 'Replace',
        showWord = 'Enable',
        -- showWord = 'Disable',
      },
      runtime = {
        version = 'LuaJIT',
        pathStrict = false,
        path = { '?.lua', '?/init.lua', '?/types.lua' },
      },
      diagnostics = {
        enable = true,
        globals = { 'vim', 'nyagos', 'describe', 'before_each', 'setup', 'teardown', 'it', 'Snacks' },
      },
      format = { enable = false },
      hover = { enable = true },
      semantic = { enable = false },
      signature_help = { enable = true },
      window = { progressBar = true, statusBar = false },
      hint = {
        enable = true,
        setType = false,
        arrayIndex = 'Disable',
      },
      workspace = {
        maxPreload = 2500,
        checkThirdParty = 'Disable',
        ignoreDir = { 'test', 'spec' },
        library = get_workspace(),
      },
    })
  end,
}
