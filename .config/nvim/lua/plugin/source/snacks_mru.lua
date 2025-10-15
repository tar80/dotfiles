---@diagnostic disable: undefined-doc-name, undefined-global, undefined-field
local MRU = { list = 'mr#mru#list', delete = 'mr#mru#delete', title = 'Most Recently Used' }

---@param filter snacks.picker.Filter
---@param list? string[]
local function recent(filter, list)
  local done = {} ---@type table<string, boolean>
  local files = {} ---@type string[]
  vim.list_extend(files, list or {})
  local i = 0
  return function()
    for f = i + 1, #files do
      i = f
      local file = files[f]
      local normalized_file = vim.fn.fnamemodify(file, ':p')
      normalized_file = svim.fs.normalize(normalized_file, { _fast = true, expand_env = false })
      local want = not done[normalized_file] and filter:match({ file = normalized_file, text = '' })
      done[normalized_file] = true
      if want and vim.uv.fs_stat(normalized_file) then
        return normalized_file, file
      end
    end
  end
end

--- Get the most recent files, optionally filtered by the
--- current working directory or a custom directory.
---@param opts snacks.picker.Config
local function finder(opts, ctx)
  if vim.g.loaded_mr ~= 1 then
    assert(false, 'Not installed vim-mr')
  end
  local list = vim.fn[MRU.list]()
  ---@async
  ---@param cb async fun(item: snacks.picker.finder.Item)
  return function(cb)
    for normalized_file, file in recent(ctx.filter, list) do
      cb({ file = normalized_file, text = file })
    end
  end
end

---@class snacks.picker.mru.Config
return {
  finder = finder,
  supports_live = false,
  title = MRU.title,
  actions = {
    del_mru_item = function(picker)
      local items = picker:selected({ fallback = true })
      for _, item in ipairs(items) do
        vim.fn['mr#mru#delete'](item.text)
      end
      vim.notify('Removed from mru', vim.log.levels.INFO, { title = 'Snacks picker mru' })
      -- picker.list:set_selected()
      -- picker.list:set_target()
      -- picker:find()
    end,
  },
  win = {
    input = {
      keys = {
        ['D'] = { 'del_mru_item', mode = { 'i', 'n' } },
      },
    },
    list = { keys = { ['D'] = 'del_mru_item' } },
  },
}
