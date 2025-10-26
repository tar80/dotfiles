--- vim:textwidth=0:foldmethod=marker:foldlevel=1:
-------------------------------------------------------------------------------
local M = {}
local api = vim.api
local fn = vim.fn

---Get the character at the cursor position
---@return string
M.getchr = function()
  local col = api.nvim_win_get_cursor(0)[2]
  local line = api.nvim_get_current_line()
  local charidx = vim.str_utfindex(line, 'utf-32', col)
  return fn.strcharpart(line, charidx, 1)
end

---Check if the character before the cursor position is an alphanumeric character
---@return boolean
M.has_words_before = function()
  local row, col = unpack(api.nvim_win_get_cursor(0))
  return col ~= 0 and api.nvim_buf_get_lines(0, row - 1, row, true)[1]:sub(col, col):match('%w') ~= nil
end

---Feeds the specified key
---@param key string
---@param mode string
M.feedkey = function(key, mode)
  api.nvim_feedkeys(api.nvim_replace_termcodes(key, true, false, true), mode, false)
end

---Replaces "<" in the string with "<lt>"
---@param v string
M.replace_lt = function(v)
  return v:gsub('<([%a-]+>)', '<lt>%1')
end

---@param bufnr integer
---@param mode string|string[]
---@param lhs string
---@param rhs string|function
---@param opts vim.api.keyset.keymap
M.buf_setmap = function(bufnr, mode, lhs, rhs, opts)
  if type(mode) == 'string' then
    mode = { mode }
  end
  for _, v in ipairs(mode) do
    if type(rhs) == 'function' then
      opts.callback = rhs
      rhs = 'callback'
    end
    api.nvim_buf_set_keymap(bufnr, v, lhs, rhs, opts)
  end
end

---Normalize specified path
---@param path string
---@return string
M.normalize = function(path)
  path = ('%s%s'):format(path:sub(1, 1):upper(), path:sub(2))
  return vim.fs.normalize(path)
end

---Get project root path
---@param path string
---@param markers string[]
-- M.get_project_root = function(path, markers)
--   return vim.fs.root(path, markers) or vim.uv.cwd()
-- end

---Get the executable file path under scoop management
---@param path string
---@return string
M.scoop_apps = function(path)
  path, _ = ('%s/%s'):format(os.getenv('SCOOP'), path):gsub('\\', '/')
  return path
end

---Get the executable file path under mason management
---@param path string
---@return string
M.mason_apps = function(path)
  return ('%s/mason/packages/%s'):format(fn.stdpath('data'), path)
end

---Get an XDG-relative path
---@param xdg string
---@param path string
M.xdg_path = function(xdg, path)
  return ('%s/%s'):format(fn.stdpath(xdg), path)
end

---Unload preset plugins
M.unload_presets = function()
  vim.g.loaded_2html_plugin = true
  vim.g.loaded_gzip = true
  vim.g.loaded_matchit = true
  vim.g.loaded_matchparen = true
  vim.g.loaded_netrwPlugin = true
  vim.g.loaded_spellfile_plugin = true
  vim.g.loaded_tarPlugin = true
  vim.g.loaded_tutor_mode_plugin = true
  vim.g.loaded_zipPlugin = true
end

---Measure the time it takes to start vim
M.measure_startup = function()
  if fn.has('vim_starting') then
    local pre = fn.reltime()
    local augroup = api.nvim_create_augroup('rc_helper', {})
    api.nvim_create_autocmd('UIEnter', {
      group = augroup,
      once = true,
      callback = function()
        local post = fn.reltime(pre)
        local msg = ('Startup time: %s'):format(fn.reltimestr(post))
        vim.notify(msg, vim.log.levels.INFO)
        api.nvim_del_augroup_by_id(augroup)
      end,
    })
  end
end

---Set vim client server
---@param port? string|integer
---@param level? string
M.set_client_server = function(port, level) -- {{{
  if level then
    return
  end
  local pipe = ([[\\.\pipe\nvim.%s.0]]):format(port or '100')
  local server = vim.v.servername
  if not server then
    pcall(fn.serverstart, pipe)
  elseif server ~= pipe then
    local ok = pcall(fn.serverstart, pipe)
    if ok then
      pcall(fn.serverstop, server)
    end
  end
end -- }}}

---Optimize the environment variable "PATH"
---@param remove string[]
M.optimize_env_path = function(remove) -- {{{
  local env_path = vim.env.path
  if not env_path then
    return
  end
  local seen = {}
  local iter = vim.iter(vim.gsplit(env_path, ';', { plain = true }))
  vim.env.path = iter
    :filter(function(path)
      return not vim.tbl_contains(remove, function(v)
        return path:lower():find(v, 1, true)
      end, { predicate = true })
    end)
    :map(function(path)
      if not seen[path] then
        seen[path] = true
        return path
      end
    end)
    :join(';')
end -- }}}

---Set the specified shell environment
---@param name string Specify the shell name
M.shell = function(name) -- {{{
  local obj = {
    cmd = { path = 'cmd.exe', flag = '/c', pipe = '>%s 2>&1', quote = '', xquote = '"', slash = false },
    nyagos = {
      path = M.scoop_apps('apps/nyagos/current/nyagos.exe'),
      flag = '-c',
      pipe = '|& tee',
      quote = '',
      xquote = '',
      slash = true,
      completeslash = 'slash',
    },
    bash = {
      path = M.scoop_apps('apps/git/current/bin/bash.exe'),
      flag = '-c',
      pipe = '2>&1| tee',
      quote = '',
      xquote = '"',
      slash = true,
      completeslash = 'slash',
    },
  }
  local cui = obj[name]
  local set = function(key, value)
    api.nvim_set_option_value(key, value, { scope = 'global' })
  end
  set('shell', cui.path)
  set('shellcmdflag', cui.flag)
  set('shellpipe', cui.pipe)
  set('shellquote', cui.quote)
  set('shellxquote', cui.xquote)
  set('shellslash', cui.slash)
  set('completeslash', cui.completeslash)
end -- }}}

---Create new scratch buffer
M.scratch_buffer = function() -- {{{
  ---@type string
  local bufname
  local i = 1
  repeat
    bufname = ('Scratch%s'):format(i)
    i = i + 1
  until fn.bufnr(bufname) == -1
  local ft = vim.bo.filetype
  vim.cmd.new(bufname)
  api.nvim_set_option_value('buftype', 'nofile', { buf = 0 })
  api.nvim_set_option_value('bufhidden', 'wipe', { buf = 0 })
  api.nvim_set_option_value('filetype', ft, { buf = 0 })
end -- }}}

M.set_macros = function()
  local k = vim.keycode
  fn.setreg('e', string.format([[:let @=@w%s]], k('<Left><Left><Left>')))
  fn.setreg('b', string.format([[V:s \//\\%s]], k('<CR>')))
  fn.setreg('d', string.format([[V:s \\/\\\\%s]], k('<CR>')))
  fn.setreg('s', string.format([[V:s \\\\/\/%s]], k('<CR>')))
  vim.notify('[Info] Registered macros', vim.log.levels.INFO)
end

---Get adapt time
---@param daytime integer
---@param nighttime integer
M.adapt_time = function(daytime, nighttime)
  local hour = os.date('*t').hour
  if daytime < hour and hour < nighttime then
    return 'daytime'
  else
    return 'nighttime'
  end
end

---Start hlsearch at cursor position
---@param has_g? boolean Has plefix "g"
---@param is_visual? boolean Visual mode or not
M.search_star = function(has_g, is_visual)
  local word ---@type string
  if is_visual then
    local pos = { fn.getpos('v'), fn.getpos('.') }
    if pos[1][3] > pos[2][3] then
      pos = { pos[2], pos[1] }
    end
    local lines = api.nvim_buf_get_lines(0, pos[1][2] - 1, pos[2][2], false)
    if #lines == 1 then
      word = lines[1]:sub(pos[1][3], pos[2][3])
    else
      return M.feedkey('*', 'n')
    end
    vim.defer_fn(function()
      M.feedkey('<Esc>', 'x')
    end, 0)
  else
    word = fn.expand('<cword>')
    if not has_g then
      word = string.format([[\<%s\>]], word)
    end
  end
  if vim.v.count > 0 then
    return M.feedkey('*', 'n')
  else
    fn.setreg('/', word)
    fn.histadd('search', word)
    return api.nvim_set_option_value('hlsearch', true, { scope = 'global' })
  end
end

--- This code was copied from snacks.debug.
---@param max_lines integer
---@param ... unknown
---@return string, string
function M.inspect(max_lines, ...) -- {{{2
  local obj = { ... } ---@type unknown[]
  local caller = debug.getinfo(1, 'S')
  for level = 3, 10 do
    local info = debug.getinfo(level, 'S')
    if
      info
      and info.source ~= caller.source
      and info.what ~= 'C'
      and info.source ~= 'lua'
      and info.source ~= '@' .. (os.getenv('MYVIMRC') or '')
    then
      caller = info
      break
    end
  end
  local dirname = vim.fs.dirname(caller.source):gsub('^.*/', '')
  local basename = vim.fs.basename(caller.source)
  local info = ('[%s]%s:%s'):format(dirname, basename, caller.linedefined)
  -- local info = fn.fnamemodify(caller.source:sub(2), ':t') .. ':' .. caller.linedefined
  if ... == nil then
    return info, 'nil'
  end
  local lines = vim.split(vim.inspect(obj), '\\n')
  if #lines > max_lines then
    local c = #lines
    lines = vim.list_slice(lines, 1, max_lines)
    lines[#lines + 1] = (c - max_lines) .. ' more lines have been truncated...'
  end
  local msg = table.concat(lines, '\n')
  msg = vim.trim(msg):sub(2, -2)
  return info, msg
end -- }}}2

--[[
---Check the existence of the executable file
---@param cmd string[]
---@return boolean
M.executable = function(cmd)
  local ok, job = pcall(vim.system, cmd, { text = true })

  if ok then
    vim.defer_fn(function()
      if not job:is_closing() then
        job:kill(9)
      end
    end, 1000)
  end

  return ok
end
--]]

local function _option_notify(name, value)
  local suffix = value and 'Enable ' or 'Disable '
  vim.notify(suffix .. name:sub(1, 1) .. name:sub(2), vim.log.levels.INFO, { title = 'Toggle Options' })
end

function M.toggleShellslash() -- {{{2
  local shellslash = not api.nvim_get_option_value('shellslash', { scope = 'global' })
  vim.opt_local.shellslash = shellslash
  vim.bo.completeslash = shellslash and 'slash' or 'backslash'
  _option_notify('shellslash', shellslash)
  -- vim.cmd.redrawstatus()
  -- vim.cmd.redrawtabline()
end

---Toggle wrap option
function M.toggle_wrap() -- {{{2
  local wrap = not vim.wo.wrap
  vim.wo.wrap = wrap
  if vim.wo.diff == true then
    vim.iter(vim.api.nvim_list_wins()):each(function(winid)
      if vim.api.nvim_win_is_valid(winid) then
        if vim.api.nvim_get_option_value('diff', { win = winid }) then
          api.nvim_set_option_value('wrap', wrap, { win = winid })
        end
      end
    end)
  end
  _option_notify('wrap', wrap)
end

return M
