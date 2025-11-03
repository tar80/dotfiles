-- vim:textwidth=0:foldmethod=marker:foldlevel=2:

return { -- {{{2
  ---@library
  { 'nvim-lua/plenary.nvim', lazy = true },
  { -- {{{3 mini.icons
    'echasnovski/mini.icons',
    lazy = true,
    config = function()
      require('mini.icons').setup()
      require('mini.icons').mock_nvim_web_devicons()
    end,
  }, -- }}}
  { -- {{{3 tartar
    'tar80/tartar.nvim',
    priority = 1000,
    dev = true,
    lazy = false,
    init = function() -- {{{4
      vim.api.nvim_create_autocmd('User', {
        pattern = 'VeryLazy',
        callback = function()
          local sauce = require('tartar.sauce')
          local abbrev = sauce.abbrev()
          abbrev.tbl = { --- {{{5
            ia = {
              ['cache'] = { 'chace', 'chache' },
              ['export'] = { 'exprot', 'exoprt' },
              ['field'] = { 'filed' },
              ['string'] = { 'stirng' },
              ['function'] = { 'funcion', 'fuction', 'funciton' },
              ['return'] = { 'reutnr', 'reutrn', 'retrun' },
              ['true'] = { 'treu' },
            },
            ca = {
              be = { { [[lua require('tartar.sauce.bench').insert_template(false,'q','r')<CR>]] } },
              bee = { { [[lua require('tartar.sauce.bench').clear()<CR>]] } },
              bt = { { [[T deno task build <C-r>=expand(\"%\:\.\")<CR>]] } },
              bp = { { [[!npm run build:prod]] }, true },
              ms = { { 'MugShow' }, true },
              es = { { [[e ++enc=cp932 ++ff=dos<CR>]] } },
              e8 = { { [[e ++enc=utf-8<CR>]] } },
              eu = { { [[e ++enc=utf-16le ++ff=dos<CR>]] } },
              sc = { { [[set scb <Bar> wincmd p <Bar> set scb<CR>]] } },
              scn = { { 'set<Space>noscb<CR>' } },
              del = { { [[call delete(expand('%'))]] } },
              cs = { { [[execute '50vsplit'g:repo.'/dotfiles/.config/nvim/.cheatsheet'<CR>]] } },
              ca = { { 'CodeCompanionActions<CR>', 'CodeCompanion add function description and annotations<CR>' } },
              cc = { { 'CodeCompanion #{buffer}', 'CodeCompanion' } },
              dd = { { 'diffthis<Bar>wincmd<Space>p<Bar>diffthis<Bar>wincmd<Space>p<CR>' } },
              dof = { { 'syntax<Space>enable<Bar>diffoff!<CR>' } },
              dor = {
                {
                  'tab<Space>split<Bar>vert<Space>bel<Space>new<Space>difforg<Bar>set<Space>bt=nofile<Bar>r<Space>++edit<Space>#<Bar>0d_<Bar>windo<Space>diffthis<Bar>wincmd<Space>p<CR>',
                },
              },
              ht = { { 'so<Space>$VIMRUNTIME/syntax/hitest.vim' } },
              ct = { { 'so<Space>$VIMRUNTIME/syntax/colortest.vim' } },
              shadad = { { '!rm ~/.local/share/nvim-data/shada/main.shada.tmp*' } },
              s = { { '%s//<Left>', 's//<Left>' }, true },
              ss = { { '%s///<Left>', 's///<Left>' }, true },
              z = { { 'Z' } },
            },
          } ---}}}5
          abbrev:set('ia')
          abbrev:set('ca')

          sauce.foldtext()
          sauce.smart_zc('treesitter')

          vim.keymap.set('x', 'aa', sauce.align, { desc = 'Tartar align' })

          do ---{{{5 live replace
            local live_rectangle_replace = sauce.live_replace()
            vim.keymap.set('v', 'I', function()
              live_rectangle_replace('I', { linewise_blockify = true })
            end, { desc = 'Tartar live_replace' })
            vim.keymap.set('v', 'gI', function()
              live_rectangle_replace('I', { linewise_blockify = true, zero = true })
            end, { desc = 'Tartar live_replace' })
            vim.keymap.set('v', 'A', function()
              live_rectangle_replace('A', { after = true, fill = true, linewise_blockify = true })
            end, { desc = 'Tartar live_replace' })
            vim.keymap.set('v', 'c', function()
              live_rectangle_replace('c', { is_replace = true, higroup = 'Visual' })
            end, { desc = 'Tartar live_replace' })
            vim.keymap.set('v', 'C', function()
              live_rectangle_replace('C', { send_key = true })
            end, { desc = 'Tartar live_replace' })
          end ---}}}

          do -- {{{5 plug operator
            local function quit_recording()
              return vim.fn.reg_recording() == '' and 'qw' or 'q'
            end
            local operatable_q = sauce.plugkey('n', 'operat_q', 'q')
            operatable_q({ ':', '/', '?', { 'w', quit_recording } })
            local repeatable_g = sauce.plugkey('n', 'repeatable_g', 'g', true)
            repeatable_g({ 'j', 'k' })
            local repeatable_z = sauce.plugkey('n', 'repeatable_z', 'z', true)
            repeatable_z({ 'h', 'l' })
            local replaceable_space = sauce.plugkey('n', 'replaceable_space', '<Space>', true)
            replaceable_space({ { '-', '<C-w>-' }, { ';', '<C-w>+' }, { ',', '<C-w><' }, { '.', '<C-w>>' } })
            local argumentable_H = sauce.plugkey('n', 'argumentable_H', 'H', true)
            argumentable_H('H', '<PageUp>H')
            local argumentable_L = sauce.plugkey('n', 'argumentable_L', 'L', true)
            argumentable_L('L', '<PageDown>L')
          end -- }}}

          sauce.testmode({
            localleader = '\\',
            test_key = '<LocalLeader><LocalLeader>',
          })
        end,
      })
    end, -- }}}4
    config = true,
  }, -- }}}3
  { 'folke/ts-comments.nvim', event = 'VeryLazy', opts = {} },

  { -- {{{3 staba
    'tar80/staba.nvim',
    dev = true,
    dependencies = { 'mini.icons', 'tartar.nvim' },
    event = 'UIEnter',
    config = function()
      local function git_branch() -- {{{
        local repo = vim.uv.cwd():gsub('^(.+[/\\])', '')
        local branch = vim.b.mug_branch_name or ''
        local detach = vim.b.mug_branch_info or ''
        detach = detach ~= '' and ('(%s) '):format(detach) or ' '
        local state = vim.b.mug_branch_stats
        state = state
            and ('%s+%s%s~%s%s!%s%s '):format(
              '%#DiagnosticSignOk#',
              state.s,
              '%#DiagnosticSignWarn#',
              state.u,
              '%#DiagnosticSignError#',
              state.c,
              '%*'
            )
          or ''
        local details = branch .. detach .. state
        return details == ' ' and ''
          or ('%s %s:%%#Special#%s '):format(require('tartar.icon.symbol').git.branch, repo, details)
      end -- }}}

      vim.keymap.set('n', 'gb', '<Plug>(staba-pick)')
      vim.keymap.set('n', '<Space>1', '<Plug>(staba-cleanup)')
      vim.keymap.set('n', '<Space>q', '<Plug>(staba-delete-select)')
      vim.keymap.set('n', '<Space>qq', function()
        local key
        if vim.bo.filetype == 'codecompanion' then
          key = '<C-c>'
        else
          key = '<Plug>(staba-delete-current)'
        end
        return key
      end, { expr = true, remap = true })
      vim.keymap.set('n', 'm', '<Plug>(staba-mark-operator)', {})
      vim.keymap.set('n', 'mm', '<Plug>(staba-mark-toggle)', {})
      vim.keymap.set('n', 'mD', '<Plug>(staba-mark-delete-all)', {})
      require('staba').setup({
        -- no_name = '[no name]',
        adjust_icon = true,
        enable_fade = true,
        enable_underline = true,
        enable_sign_marks = true,
        enable_statuscolumn = true,
        enable_statusline = true,
        enable_tabline = true,
        mode_line = 'LineNr',
        nav_keys = 'basdfghjklzxcvnmqweertuiopy',
        ignore_filetypes = {
          fade = { 'trouble' },
          statuscolumn = { 'qf', 'help', 'terminal', 'undotree' },
          statusline = { 'terminal', 'trouble', 'snacks_layout_box' },
          tabline = { 'qf', 'snacks_picker_list' },
        },
        -- nav_key = '',
        statusline = {
          active = {
            left = { 'search_count', 'snacks_profiler' },
            middle = {},
            -- left = { 'staba_logo' },
            -- middle = { 'search_count' },
            right = { '%<', 'diagnostics', ' ', git_branch, 'filetype', 'encoding', ' ', 'position' },
          },
          -- inactive = { left = {}, middle = { 'devicon', 'filename', '%*' }, right = {} },
        },
        tabline = { '%q' },
        -- icons = {},
      })
    end,
  }, -- }}}
  { -- {{{3 rereope
    'tar80/rereope.nvim',
    dev = true,
    opts = { map_cyclic_register_keys = {} },
    keys = {
      {
        '_',
        function()
          require('rereope').open('_', {
            end_point = false,
            beacon = { 'FretAlternative', 100, 30, 15 },
            hint = { winblend = 10, border = { '', '', '', '', '', '', '', '┃' } },
          })
        end,
        mode = { 'n', 'x' },
        desc = 'Rereope regular replace',
      },
    },
  }, -- }}}3
  { -- {{{3 fret
    'tar80/fret.nvim',
    dev = true,
    keys = { 'f', 'F', 't', 'T', 'd', 'v', 'V', 'y', 'c', '\x16' },
    opts = {
      fret_enable_beacon = true,
      fret_enable_kana = true,
      fret_enable_symbol = true,
      fret_repeat_notify = false,
      fret_smart_fold = true,
      fret_timeout = 9000,
      fret_samekey_repeat = true,
      -- beacon_opts = { hl = 'LazyButtonActive', interval = 80, blend = 30, decay = 15 },
      mapkeys = { fret_f = 'f', fret_F = 'F', fret_t = 't', fret_T = 'T' },
    },
  }, ---}}}
  { -- {{{3 matchwith
    'tar80/matchwith.nvim',
    dev = true,
    event = 'VeryLazy',
    init = function()
      vim.keymap.set({ 'o', 'x' }, 'i%', '<Plug>(matchwith-operator-i)')
      vim.keymap.set({ 'o', 'x' }, 'a%', '<Plug>(matchwith-operator-a)')
      vim.keymap.set({ 'o', 'x' }, 'iP', '<Plug>(matchwith-operator-parent-i)')
      vim.keymap.set({ 'o', 'x' }, 'aP', '<Plug>(matchwith-operator-parent-a)')
    end,
    opts = {
      -- captures = {
      --   html = { 'tag.delimiter', 'punctuation.bracket' },
      --   javascript = { 'tag.delimiter', 'punctuation.bracket' },
      -- },
      ignore_filetypes = {
        'fidget',
        'snacks_picker_input',
      },
      -- ignore_buftypes = {},
      jump_key = '%',
      indicator = 0,
      priority = 200,
      sign = false,
      show_parent = false,
      show_next = true,
    },
  }, -- }}}
  { -- {{{3 smartword
    'kana/vim-smartword',
    keys = {
      { 'w', '<Plug>(smartword-w)', mode = { 'n' } },
      { 'b', '<Plug>(smartword-b)', mode = { 'n' } },
      { 'e', '<Plug>(smartword-e)', mode = { 'n' } },
      { 'ge', '<Plug>(smartword-ge)', mode = { 'n' } },
    },
  }, -- }}}
  { -- {{{3 sandwich
    'machakann/vim-sandwich',
    keys = {
      { '<Leader>i', '<Plug>(operator-sandwich-add)i', mode = { 'n' } },
      { '<Leader>ii', '<Plug>(textobj-sandwich-auto-i)<Plug>(operator-sandwich-add)', mode = { 'n' } },
      { '<Leader>a', '<Plug>(operator-sandwich-add)a', mode = { 'n' } },
      { '<Leader>aa', '<Plug>(textobj-sandwich-auto-a)<Plug>(operator-sandwich-add)', mode = { 'n' } },
      { '<Leader>a', '<Plug>(operator-sandwich-add)', mode = { 'x' } },
      { '<Leader>r', '<Plug>(sandwich-replace)', mode = { 'n', 'x' } },
      { '<Leader>rr', '<Plug>(sandwich-replace-auto)', mode = { 'n', 'x' } },
      { '<Leader>d', '<Plug>(sandwich-delete)', mode = { 'n', 'x' } },
      { '<Leader>dd', '<Plug>(sandwich-delete-auto)', mode = { 'n', 'x' } },
    },
    init = function()
      vim.g.sandwich_no_default_key_mappings = true
    end,
    config = function()
      local recipes = vim.deepcopy(vim.g['sandwich#default_recipes'])
      local esc_quote = { s = [[\']], d = [[\"]] }
      recipes = vim.list_extend(recipes, {
        { buns = { esc_quote.s, esc_quote.s }, input = { esc_quote.s } },
        { buns = { esc_quote.d, esc_quote.d }, input = { esc_quote.d } },
        { buns = { '【', '】' }, input = { ']' }, filetype = { 'markdown' } },
        { buns = { '${', '}' }, input = { '$' }, filetype = { 'typescript', 'javascript' } },
        { buns = { '%(', '%)' }, input = { '%' }, filetype = { 'typescript', 'javascript' } },
      })
      vim.g['sandwich#recipes'] = recipes
      vim.g['sandwich#magicchar#f#patterns'] = {
        { header = [[\<\%(\h\k*\.\)*\h\k*]], bra = '(', ket = ')', footer = '' },
      }
    end,
  }, -- }}}

  ---@desc On key
  { -- {{{3 dial
    'monaqa/dial.nvim',
    keys = { '<C-a>', '<C-x>', { 'g<C-a>', mode = 'x' }, { 'g<C-x>', mode = 'x' } },
    config = function()
      local augend = require('dial.augend')
      local default_rules = {
        augend.semver.alias.semver,
        augend.integer.alias.decimal_int,
        augend.integer.alias.hex,
        augend.decimal_fraction.new({}),
        augend.date.alias['%Y/%m/%d'],
        augend.constant.alias.bool,
        -- augend.paren.alias.quote,
      }
      local js_rules = {
        augend.constant.new({ elements = { 'let', 'const' } }),
      }
      require('dial.config').augends:register_group({
        default = default_rules,
        case = {
          augend.case.new({
            types = { 'camelCase', 'snake_case' },
            cyclic = true,
          }),
        },
      })
      require('dial.config').augends:on_filetype({
        typescript = vim.tbl_extend('force', default_rules, js_rules),
        javascript = vim.tbl_extend('force', default_rules, js_rules),
        -- lua = {},
        -- markdown = { augend.misc.alias.markdown_header, },
      })

      -- vim.keymap.set('n', '<C-t>', require('dial.map').inc_normal('case'), { silent = true, noremap = true })
      vim.keymap.set('n', '<C-a>', require('dial.map').inc_normal(), { silent = true, noremap = true })
      vim.keymap.set('n', '<C-x>', require('dial.map').dec_normal(), { silent = true, noremap = true })
      vim.keymap.set('v', '<C-a>', require('dial.map').inc_visual(), { silent = true, noremap = true })
      vim.keymap.set('v', '<C-x>', require('dial.map').dec_visual(), { silent = true, noremap = true })
      vim.keymap.set('v', 'g<C-a>', require('dial.map').inc_gvisual(), { silent = true, noremap = true })
      vim.keymap.set('v', 'g<C-x>', require('dial.map').dec_gvisual(), { silent = true, noremap = true })
    end,
  }, -- }}}
  { -- {{{3 undotree
    'mbbill/undotree',
    keys = { { '<F7>', '<Cmd>UndotreeToggle<CR>', desc = 'Toggle undotree' } },
    config = function()
      vim.g.undotree_WindowLayout = 2
      vim.g.undotree_ShortIndicators = 1
      vim.g.undotree_SplitWidth = 28
      vim.g.undotree_DiffpanelHeight = 6
      vim.g.undotree_DiffAutoOpen = 1
      vim.g.undotree_SetFocusWhenToggle = 1
      vim.g.undotree_TreeNodeShape = '*'
      vim.g.undotree_TreeVertShape = '|'
      vim.g.undotree_DiffCommand = 'diff'
      vim.g.undotree_RelativeTimestamp = 1
      vim.g.undotree_HighlightChangedText = 1
      vim.g.undotree_HighlightChangedWithSign = 1
      vim.g.undotree_HighlightSyntaxAdd = 'DiffAdd'
      vim.g.undotree_HighlightSyntaxChange = 'DiffChange'
      vim.g.undotree_HighlightSyntaxDel = 'DiffDelete'
      vim.g.undotree_HelpLine = 1
      vim.g.undotree_CursorLine = 1
      -- keymap.set('n', '<F7>', '<Cmd>UndotreeToggle<CR>')
    end,
  }, -- }}}

  { -- {{{3 translate
    'uga-rosa/translate.nvim',
    cmd = 'Translate',
    init = function()
      vim.keymap.set({ 'n', 'x' }, '<Leader>ie', '<Cmd>Translate EN<CR><C-[>', { silent = true })
      vim.keymap.set({ 'n', 'x' }, '<Leader>ij', '<Cmd>Translate JA<CR><C-[>', { silent = true })
      vim.keymap.set({ 'n', 'x' }, '<Leader>iE', '<Cmd>Translate EN -output=replace<CR>', { silent = true })
      vim.keymap.set({ 'n', 'x' }, '<Leader>iJ', '<Cmd>Translate JA -output=replace<CR>', { silent = true })
      -- keymap.set({ 'n', 'x' }, 'mj', '<Cmd>echo "Translate keymap was changed <lt>Leader>ij"<CR>', { desc = 'dummy' })
    end,
    opts = { silent = true },
  }, -- }}}

  ---@desc On filetype
  { 'tar80/vim-PPxcfg', dev = true, ft = 'PPxcfg' },
  { 'vim-jp/vimdoc-ja' },
} -- }}}2
