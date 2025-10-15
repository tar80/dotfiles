-- vim:textwidth=0:foldmethod=marker:foldlevel=1:
--------------------------------------------------------------------------------
local api = vim.api
local fn = vim.fn
local keymap = vim.keymap

---@desc Auto-commands {{{1
local augroup = api.nvim_create_augroup('config/command', {})

--NOTE: next_version
---Remove ignore history from cmdline history{{{2
---@see https://blog.atusy.net/2023/07/24/vim-clean-history/
-- local delete_history = vim.regex([=[^\c\(mes\%[sages]\|h\%[elp]\)\_.*$]=])
-- vim.api.nvim_create_autocmd('CmdlineLeavePre', {
--   desc = 'Remove ignore history',
--   pattern = ':',
--   group = augroup,
--   callback = function()
--     vim.schedule(function()
--       for i = 1, 2 do
--         local text = fn.histget(':', -i)
--         if text ~= '' and #text < 7 or delete_history:match_str(text) then
--           fn.histdel(':', -i)
--         end
--       end
--     end)
--   end,
-- })

local _wshada_triggered
local function _update_shada()
  _wshada_triggered = true
  vim.api.nvim_create_autocmd('CmdWinLeave', {
    desc = 'Update shada',
    once = true,
    group = augroup,
    callback = function()
      vim.cmd.wshada({ bang = true })
      _wshada_triggered = false
    end,
  })
end

---Delete current line from cmdwin-history {{{2
vim.api.nvim_create_autocmd('CmdWinEnter', {
  desc = 'Attach command window',
  group = augroup,
  callback = function()
    vim.wo.signcolumn = 'no'
    keymap.set('n', 'D', function()
      local line = fn.line('.') - fn.line('$')
      fn.histdel(':', line)
      api.nvim_del_current_line()
      if not _wshada_triggered then
        _update_shada()
      end
    end, { buffer = 0 })
    keymap.set('n', 'q', '<Cmd>quit<CR>', { buffer = 0 })
  end,
})

---Cursor line highlighting rules {{{2
local function set_cursorline_hl()
  if vim.bo.filetype ~= 'snacks_picker_input' then
    vim.opt_local.winhighlight:append('CursorLine:CursorLineHold')
    api.nvim_set_option_value('cursorline', true, {})
  end
end

---Cursor line highlighting rules {{{2
api.nvim_create_autocmd('CursorHoldI', {
  desc = 'Ignore cursorline highlight',
  group = augroup,
  callback = function()
    set_cursorline_hl()
  end,
})

api.nvim_create_autocmd({ 'FocusLost', 'BufLeave' }, {
  desc = 'Ignore cursorline highlight',
  group = augroup,
  callback = function()
    if api.nvim_get_mode().mode == 'i' then
      set_cursorline_hl()
    end
  end,
})

api.nvim_create_autocmd({ 'BufEnter', 'CursorMovedI', 'InsertLeave' }, {
  desc = 'Ignore cursorline highlight',
  group = augroup,
  -- command = 'setl nocursorline',
  callback = vim.schedule_wrap(function()
    vim.wo.cursorline = false
    vim.opt_local.winhighlight:remove('CursorLine')
  end),
})

---Insert-Mode, we want a longer updatetime {{{2
api.nvim_create_autocmd('InsertEnter', {
  desc = 'Set to longer updatetime',
  group = augroup,
  callback = function()
    vim.go.updatetime = 7000
  end,
})

api.nvim_create_autocmd('InsertLeave', {
  desc = 'Revert to normal updatetime',
  group = augroup,
  -- command = 'setl iminsert=0|execute "set updatetime=" . g:update_time',
  callback = function()
    vim.bo.iminsert = 0
    vim.go.updatetime = vim.g.update_time
    -- vim.g._ts_force_sync_parsing = false
  end,
})

---Yanked, it shines {{{2
api.nvim_create_autocmd('TextYankPost', {
  desc = 'On yank highlight',
  group = augroup,
  pattern = '*',
  callback = function(_)
    vim.hl.on_yank({ higroup = 'Visual', on_visual = false, timeout = 200, prioritiy = 300 })
  end,
})

---Supports changing options that affect diff {{{2
local function _delete_diffmap(bufnr)
  keymap.del('x', 'do', { buffer = bufnr })
  keymap.del('x', 'dp', { buffer = bufnr })
  keymap.del('x', 'dd', { buffer = bufnr })
  keymap.del({ 'x', 'n' }, 'du', { buffer = bufnr })
end
api.nvim_create_autocmd('OptionSet', {
  desc = 'Settings applied to diff buffers',
  group = augroup,
  pattern = { 'diff' },
  callback = function(opts)
    if not vim.api.nvim_buf_is_valid(opts.buf) then
      return
    end
    if vim.wo.diff then
      keymap.set({ 'n', 'x' }, 'du', '<Cmd>diffupdate<CR>', { buffer = opts.buf, desc = 'Update diff status' })
      keymap.set('x', 'do', '<Cmd>diffget<CR>', { buffer = opts.buf, desc = 'Get selection diff' })
      keymap.set('x', 'dp', '<Cmd>diffput<CR>', { buffer = opts.buf, desc = 'Put selection diff' })
      keymap.set('x', 'dd', function()
        if not vim.wo.diff and vim.fn.mapcheck('dd', 'x') ~= '' then
          _delete_diffmap(opts.buf)
          return 'dd'
        end
        return 'd'
      end, { buffer = opts.buf, expr = true, desc = 'Delete selection range' })
    elseif vim.fn.mapcheck('dd', 'x') ~= '' then
      _delete_diffmap(opts.buf)
    end
  end,
})

---@desc User-commands {{{1
api.nvim_create_user_command('BustedThisFile', function() -- {{{2
  local rgx = vim.regex([[\(_spec\)\?\.lua$]])
  local path = string.gsub(vim.fn.expand('%'), '\\', '/')
  path = string.format('%s_spec.lua', path:sub(1, rgx:match_str(path)))
  vim.cmd.PlenaryBustedFile(path)
end, {})

---@desc "Z <filepath>" zoxide query
-- api.nvim_create_user_command('Z', 'execute "lcd " . system("zoxide query " . <q-args>)', { nargs = 1 })

---@desc Jest compose multi-panel
---@type string
local pane_id
api.nvim_create_user_command('JestDo', function() -- {{{2
  local path = vim.fn.expand('%:t')
  if not path:find('test.ts$') then
    path = path:gsub('.ts$', '.test.ts')
  end
  vim.system(
    { 'wezterm', 'cli', 'send-text', '--pane-id', pane_id, '--no-paste' },
    { stdin = { string.format('npx jest --test-match=**/%s', path) }, text = true }
  )
end, {})

api.nvim_create_user_command('JestSetup', function()
  local has_config = fn.filereadable('jest.config.js') + fn.filereadable('package.json')
  if has_config == 0 then
    vim.notify('Could not found jest configurations', 3)
  end
  vim.system(
    { 'wezterm', 'cli', 'split-pane', '--right', '--percent=40', string.format('--cwd=%s', vim.uv.cwd()), 'bash' },
    { text = true },
    function(obj)
      pane_id = vim.trim(obj.stdout)
      vim.system({ 'wezterm', 'cli', 'activate-pane-direction', 'left' }, { text = true })
    end
  )
  local symbol = 'test'
  local sym_dir = string.format('__%ss__', symbol)
  local parent_dir = vim.fs.dirname(api.nvim_buf_get_name(0))
  local test_dir = vim.fs.joinpath(parent_dir, sym_dir)
  local name = fn.expand('%:t:r')
  if parent_dir and not parent_dir:find(sym_dir, 1, true) then
    local test_path = string.format('%s/%s.%s.ts', test_dir, name, symbol)
    local insert_string = ''
    if fn.filereadable(test_path) ~= 1 then
      local line1 = "import PPx from '@ppmdev/modules/ppx.ts';"
      local line2 = 'global.PPx = Object.create(PPx)'
      local line3 = string.format("import from '../%s'", fn.expand('%:t'))
      insert_string = string.format('|execute "normal! I%s\n%s\n%s\\<Esc>3G06l"', line1, line2, line3)
    end
    if fn.isdirectory(test_dir) ~= 1 then
      fn.mkdir(test_dir)
    end
    api.nvim_command(string.format('bot split %s|set fenc=utf-8|set ff=unix%s', test_path, insert_string))
  end
end, {})
