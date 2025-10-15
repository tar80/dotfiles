local win_height = 10
vim.go.hlsearch = true
vim.wo.wrap = false
vim.b.enable_preview = false

local function is_qf()
  local wininfo = vim.fn.getwininfo(vim.fn.win_getid())
  return wininfo[0].loclist ~= 1
end

local function get_row()
  return vim.api.nvim_win_get_cursor(0)[1]
end

local function filewin()
  local winnr = vim.fn.winnr('#')
  return vim.fn.win_getid(winnr)
end

local function get_list()
  return is_qf and vim.fn.getqflist()[get_row()] or vim.fn.getloclist(0)[get_row()]
end

local function preview(direction)
  if direction then
    if direction == 'P' then
      vim.b.enable_preview = not vim.b.enable_preview
      if not vim.b.enable_preview then
        return ''
      end
    else
      vim.api.nvim_command('normal! ' .. direction)
      if not vim.b.enable_preview then
        return ''
      end
    end
  end
  local list = get_list()
  local winnr = filewin()
  vim.api.nvim_win_set_buf(winnr, list.bufnr)
  vim.api.nvim_win_set_cursor(winnr, { list.lnum + 1, list.col })
  return ''
end

local function open_vert()
  local list = get_list()
  local winnr = filewin()
  vim.api.nvim_win_call(winnr, function()
    vim.api.nvim_command('vsplit ' .. vim.fn.bufname(list.bufnr))
    winnr = vim.api.nvim_get_current_win()
  end)
  vim.api.nvim_win_set_cursor(winnr, { list.lnum, list.col })
end

local function open_tab()
  local list = get_list()
  vim.api.nvim_command('tabedit ' .. vim.fn.bufname(list.bufnr))
  vim.api.nvim_win_set_cursor(0, { list.lnum, list.col })
end

local bufnr = vim.api.nvim_get_current_buf()
vim.keymap.set('n', 'p', preview, { buffer = true })
vim.keymap.set('n', 'P', function()
  preview('P')
end, { buffer = true })
vim.keymap.set('n', 'j', function()
  preview('j')
end, { buffer = true })
vim.keymap.set('n', 'k', function()
  preview('k')
end, { buffer = true })
vim.keymap.set('n', '<C-v>', open_vert, { buffer = true })
vim.keymap.set('n', '<C-t>', open_tab, { buffer = true })
vim.keymap.set('n', 'q', '<Cmd>quit<CR>', { buffer = true })

if vim.api.nvim_win_get_position(0)[1] > 1 then
  local au_id = vim.api.nvim_create_augroup('ft_qf', {})
  vim.api.nvim_create_autocmd({ 'BufEnter' }, {
    group = au_id,
    buffer = bufnr,
    callback = function()
      vim.api.nvim_win_set_height(0, win_height)
    end,
  })
  vim.api.nvim_create_autocmd({ 'BufLeave' }, {
    group = au_id,
    buffer = bufnr,
    callback = function()
      vim.api.nvim_win_set_height(0, 3)
    end,
  })
end
