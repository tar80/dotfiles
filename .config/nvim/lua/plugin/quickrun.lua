--- vim:textwidth=0:foldmethod=marker:foldlevel=1:
-------------------------------------------------------------------------------
local api = vim.api

return {
  { -- {{{ quickrun
    'thinca/vim-quickrun',
    cmd = 'QuickRun',
    dependencies = {
      { 'tar80/vim-quickrun-neovim-job', branch = 'win-nyagos', dev = true },
    },
    keys = {
      {
        'mq',
        function()
          if vim.bo.filetype == '' then
            return
          end

          local prefix = ''
          local mode = api.nvim_get_mode().mode
          local start_line, end_line ---@type integer, integer

          if mode:find('^[vV\x16]') then
            start_line = vim.fn.line('v')
            end_line = api.nvim_win_get_cursor(0)[1]

            if start_line > end_line then
              start_line, end_line = end_line, start_line
            end
            api.nvim_buf_set_mark(0, 'q', start_line, 0, {})
            api.nvim_buf_set_mark(0, 'r', end_line, 0, {})
            api.nvim_exec_autocmds('User', { pattern = 'StabaUpdateMark', modeline = false })
            prefix = ('%s,%s'):format(start_line, end_line)
          else
            start_line = api.nvim_buf_get_mark(0, 'q')[1]
            end_line = api.nvim_buf_get_mark(0, 'r')[1]
            if (start_line + end_line) > 0 then
              prefix = ('%s,%s'):format(start_line, end_line)
            end
          end

          local suffix = ''
          local bufnr = vim.api.nvim_get_current_buf()
          local pos = vim.api.nvim_win_get_cursor(0)
          local row, col = pos[1] - 1, pos[2]
          local captures = vim.treesitter.get_captures_at_pos(bufnr, row, col)
          local filetypes = { 'lua', 'javascript', 'typescript', 'vim' }
          local is_injection = vim.iter(captures):find(function(capture)
            return vim.tbl_contains(filetypes, capture.lang)
          end)
          if is_injection then
            suffix = is_injection.lang
          end
          vim.cmd(('%sQuickRun %s'):format(prefix, suffix))
        end,
        mode = { 'n', 'v' },
        desc = 'QuickRun',
      },
    },
    init = function()
      ---@see https://github.com/yuki-yano/dotfiles/blob/main/.vim/lua/plugins/utils.lua
      local jobs = {}
      vim.g.quickrun_config = {
        ['_'] = {
          outputter = 'error',
          ['outputter/error/success'] = 'message',
          ['outputter/error/error'] = 'message',
          -- ['outputter/buffer/opener'] = ':botright 5split',
          -- ['outputter/buffer/close_on_empty'] = 0,
          runner = 'neovim_job',
          hooks = {
            {
              on_ready = function(session, _)
                local job_id = nil
                if session._temp_names then
                  job_id = session._temp_names[1]
                  jobs[job_id] = { finish = false }
                end
                vim.cmd(string.format('echon "[QuickRun] Running %s ..."', session.config.command))
              end,
              on_success = function(_, _)
                vim.cmd('echon "[QuickRun] Success"')
              end,
              on_failure = function(_, _)
                vim.cmd('echohl Error | echo "[QuickRun] Failure" | echohl None')
              end,
              on_finish = function(session, _)
                if session._temp_names then
                  local job_id = session._temp_names[1]
                  jobs[job_id].finish = true
                end
              end,
            },
          },
        },
        typescript = { type = 'deno' },
        deno = {
          command = 'deno',
          cmdopt = '--no-check --allow-all',
          tempfile = '%{tempname()}.ts',
          exec = { '%c run %o %S' },
        },
        lua = {
          command = ':luafile',
          exec = { '%C %S' },
          runner = 'vimscript',
        },
        javascript = { type = 'ppx' },
        ppx = {
          command = 'ppbw',
          cmdopt = '-c *stdout',
          tempfile = '%{tempname()}.js',
          exec = { '${PPX_DIR}/%C %o [PPx] %%*script(%S)' },
        },
        node = {
          command = 'node',
          tempfile = '%{tempname()}.js',
          exec = { '%c %S' },
        },
      }
    end,
  }, -- }}}
}
