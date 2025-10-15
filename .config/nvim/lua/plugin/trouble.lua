-- vim:textwidth=0:foldmethod=marker:foldlevel=1:
--------------------------------------------------------------------------------

return {
  'folke/trouble.nvim',
  cmd = 'Trouble',
  keys = { 'gle', 'glr' },
  opts = function()
    local trouble_api = require('trouble.api')
    local helper = require('helper')

    vim.keymap.set('n', 'gd', function() -- {{{
      local pos = { vim.api.nvim_win_get_cursor(0) }
      vim.cmd.normal({ 'gd', bang = true })
      if not (vim.deep_equal(pos, { vim.api.nvim_win_get_cursor(0) }) and (#vim.lsp.get_clients({ bufnr = 0 }) == 0)) then
        return
      end
      vim.lsp.buf.definition({
        reuse_win = true,
        on_list = function(opts)
          local item1 = opts.items[1]
          if #opts.items == 2 then
            local item2 = opts.items[2]

            if item1.filename == item2.filename and item1.lnum == item2.lnum then
              local filename = helper.normalize(item1.filename)
              if filename ~= helper.normalize(vim.api.nvim_buf_get_name(0)) then
                vim.cmd.edit(filename)
              end

              vim.api.nvim_win_set_cursor(0, { item1.lnum, item1.col })
              return
            end
          end
          trouble_api.open('lsp_definitions')
        end,
      })
    end, { desc = 'Trouble definitions' }) -- }}}
    vim.keymap.set('n', 'gle', function()
      trouble_api.toggle('diagnostics_buffer')
    end, { desc = 'Trouble diagnostics' })
    vim.keymap.set('n', 'glr', function()
      trouble_api.toggle('lsp_references')
    end, { desc = 'Trouble references' })

    return { -- {{{1
      auto_close = false,
      auto_open = false,
      auto_preview = false,
      auto_refresh = true,
      auto_jump = false,
      focus = true,
      restore = false,
      follow = true,
      indent_guides = true,
      max_items = 50,
      multiline = true,
      pinned = false,
      warn_no_results = true,
      open_no_results = false,
      throttle = {
        refresh = 200, -- fetches new data when needed
        update = 100, -- updates the window
        render = 100, -- renders the window
        follow = 100, -- follows the current item
        preview = { ms = 100, debounce = true }, -- shows the preview for the current item
      },
      keys = { -- {{{2
        ['<Tab>'] = 'cancel',
        ['<C-l>'] = 'refresh',
        ['<cr>'] = 'jump_close',
        ['j'] = 'next',
        ['k'] = 'prev',
        -- ['h'] = 'fold_close',
        -- ['l'] = 'fold_open',
        ['o'] = 'jump',
        ['<2-leftmouse>'] = 'jump',
      },
      modes = { -- {{{2
        lsp_definitions = {
          mode = 'lsp_definitions',
          auto_preview = true,
          auto_close = true,
          win = {
            --   type = 'float',
            --   border = 'rounded',
            --   title = 'Lsp definitions',
            --   title_pos = 'center',
            --   size = { width = 0.6, height = 0.5 },
            --   zindex = 200,
            size = 0.2,
          },
          preview = {
            type = 'split',
            relative = 'win',
            position = 'right',
            size = 0.7,
          },
        },
        diagnostics_buffer = {
          auto_close = true,
          auto_refresh = true,
          auto_preview = true,
          focus = false,
          mode = 'diagnostics',
          filter = { buf = 0 },
        },
      },
      icons = {
        kinds = require('tartar.icon.kind'),
      }, -- }}}2
    }
  end, -- }}}1
}
