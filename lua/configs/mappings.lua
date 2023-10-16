require('utils')

-- Seriously, guys. It's not like :W or :Q are mapped to anything anyway.
cmd.cnoreabbrev('Q', 'q')
cmd.cnoreabbrev('QA', 'qa')
cmd.cnoreabbrev('Qa', 'qa')
cmd.cnoreabbrev('qA', 'qa')
cmd.cnoreabbrev('W', 'w')
cmd.cnoreabbrev('WA', 'wa')
cmd.cnoreabbrev('Wa', 'wa')
cmd.cnoreabbrev('wA', 'wa')
cmd.cnoreabbrev('WQ', 'wq')
cmd.cnoreabbrev('Wq', 'wq')
cmd.cnoreabbrev('wQ', 'wq')
cmd.cnoreabbrev('WQA', 'wqa')
cmd.cnoreabbrev('WQa', 'wqa')
cmd.cnoreabbrev('WqA', 'wqa')
cmd.cnoreabbrev('Wqa', 'wqa')
cmd.cnoreabbrev('wQA', 'wqa')
cmd.cnoreabbrev('wQa', 'wqa')
cmd.cnoreabbrev('wqA', 'wqa')


-- leader is space, so we can set it to Nop.
map(n + v, '<Space>', '<Nop>',
    { desc = '', noremap = true, silent = true })

-- Add descritions to nvim builtins:
map(n, '$', '$',
    { desc = 'Go to end of line', noremap = true, silent = true })
map(n, '0', '0',
    { desc = 'Go to beginning of line', noremap = true, silent = true })
map(n, '^', '^',
    { desc = 'Go to first non-blank character of line', noremap = true, silent = true })
map(n, 'Y', 'y$',
    { desc = 'Yank until end of line', noremap = true, silent = true })
map(n, '<C-l>', '<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>',
    { desc = 'Refresh screen', noremap = true, silent = true })
map(i, '<C-u>', '<C-G>u<C-U>',
    { desc = 'Delete to beginning of line', noremap = true, silent = true })
map(i, '<C-w>', '<C-G>u<C-W>',
    { desc = 'Delete to beginning of word', noremap = true, silent = true })
map(x, '*', 'y/\\V<C-R>"<CR>',
    { desc = 'Search forward for current word', noremap = true, silent = true })
map(x, '#', 'y?\\V<C-R>"<CR>',
    { desc = 'Search backward for current word', noremap = true, silent = true })
map(n, '&', ':&&<CR>',
    { desc = 'Repeat last substitution', noremap = true, silent = true })

-- Window navigation:
map(n, '<C-PageUp>', '<CMD> bprev! <CR>',
    { desc = 'Change to previous buffer', noremap = true, silent = true })
map(n, '<C-PageDown>', '<CMD> bnext! <CR>',
    { desc = 'Change to next buffer', noremap = true, silent = true })
map(n, '<C-Up>', '<C-w>k',
    { desc = 'Change to window above', noremap = true, silent = true })
map(n, '<C-Down>', '<C-w>j',
    { desc = 'Change to window below', noremap = true, silent = true })
map(n, '<C-Left>', '<C-w>h',
    { desc = 'Change to window on the left', noremap = true, silent = true })
map(n, '<C-Right>', '<C-w>l',
    { desc = 'Change to window on the right', noremap = true, silent = true })

-- Window manipulation:
map(n, '<M-Up>', '<CMD> wincmd k <CR>:resize -2 <CR>',
    { desc = 'Increase lower window size', silent = true })
map(n, '<M-Down>', '<CMD> wincmd k <CR>:resize +2 <CR>',
    { desc = 'Increase upper window size', silent = true })

map(n, '<leader>cb', '<CMD> enew <CR>',
    { desc = 'New buffer', silent = true })
map(n, '<leader>db', '<CMD> bd <CR>',
    { desc = 'Close current buffer', silent = true })

map(i + n + v + t, '<C-d>',
    function()
        if #vim.api.nvim_list_wins() > 1 then
            vim.api.nvim_win_close(0, true)
        else
            vim.cmd('bd')
        end
    end,
    { desc = 'Close window', silent = true })

map(i + n + v, '<C-s>',
    function()
        cmd.split()
        cmd.startinsert()
        cmd.terminal()
    end,
    { desc = 'New Shell', silent = true }
)

map(i + n + v, '<C-p>',
    function()
        cmd.split()
        cmd.startinsert()
        cmd.terminal('python')
    end,
    { desc = 'New Python Shell', silent = true, }
)

-- Indenting:
map(v, '<', '<gv',
    { desc = 'Dedent line', noremap = true, silent = true, })
map(v, '>', '>gv',
    { desc = 'Indent line', noremap = true, silent = true, })

-- Formatting:
map(n, 'W', 'gwip',
    { desc = 'Wrap paragraph', noremap = true, silent = true })
map(v, 'W', 'gw',
    { desc = 'Wrap paragraph', noremap = true, silent = true })

-- Selection:
map(n, '<S-Home>', 'Vgg',
    { desc = 'Go to beginning of line', noremap = true, silent = true })
map(n, '<S-End>', 'VG',
    { desc = 'Go to end of line', noremap = true, silent = true })

-- Yanking:
map(n, 'y.', '<CMD> %y+ <CR>',
    { desc = 'Yank current buffer', noremap = true, silent = true })
map(x, '<leader>p', 'p:let @+=@0<CR>:let @"=@0<CR>',
    { desc = 'Paste w/o replacing register', noremap = true, silent = true })

-- Quickfix
map(i + n + v + t, '<C-q>', '<CMD> copen <CR>',
    { desc = 'Open QuickFix', silent = true })

-- cd to folder of current file:
map(n, '<leader>wd', '<CMD> lcd %:p:h<CR>',
    { desc = '`cd` to folder of file in current buffer', silent = true })

-- Diagnostics keymaps:
map(n, '[d', vim.diagnostic.goto_prev,
    { desc = 'Go to previous diagnostic message' })
map(n, ']d', vim.diagnostic.goto_next,
    { desc = 'Go to next diagnostic message' })
map(n, '<leader>e', vim.diagnostic.open_float,
    { desc = 'Open floating diagnostic message' })
map(n, '<leader>od', vim.diagnostic.setloclist,
    { desc = '[O]pen [D]iagnostics' })

-- Misc:
map(t, '<Esc>', vim.api.nvim_replace_termcodes('<C-\\><C-N>', true, true, true),
    { desc = 'Escape terminal mode', noremap = true, silent = true })

map(n, '<Esc>', '<CMD> noh <CR>',
    { desc = 'Clear highlights', silent = true })

map(n, '<leader>n', '<CMD> set rnu! <CR>',
    { desc = 'Toggle relative number', silent = true })

map(n, '<leader><CR>', '<CMD> set list!<CR>',
    { desc = 'Show listchars', silent = true })
