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
map(n + v, '<Space>', '<Nop>', { desc = '' })

-- Window navigation:
map(n, '<C-PageUp>', '<CMD> bprev! <CR>', { desc = 'Change to previous buffer' })
map(n, '<C-PageDown>', '<CMD> bnext! <CR>', { desc = 'Change to next buffer' })
map(n, '<C-Up>', '<C-w>k', { desc = 'Change to window above' })
map(n, '<C-Down>', '<C-w>j', { desc = 'Change to window below' })
map(n, '<C-Left>', '<C-w>h', { desc = 'Change to window on the left' })
map(n, '<C-Right>', '<C-w>l', { desc = 'Change to window on the right' })

-- Window manipulation:
map(n, '<M-Up>', '<CMD> wincmd k <CR>:resize -2 <CR>', { desc = 'Increase lower window size' })
map(n, '<M-Down>', '<CMD> wincmd k <CR>:resize +2 <CR>', { desc = 'Increase upper window size' })

-- Buffer Management:
map(n, '<leader>cb', '<CMD> enew <CR>', { desc = 'New buffer' })
map(n, '<leader>db', '<CMD> bd <CR>', { desc = 'Close current buffer' })

map(i + n + v + t, '<C-d>',
    function()
        if #vim.api.nvim_list_wins() > 1 then
            vim.api.nvim_win_close(0, true)
        else
            vim.cmd('bd')
        end
    end,
    { desc = 'Close window' })

-- System Shell
map(i + n + v, '<C-s>',
    function()
        cmd.split()
        cmd.startinsert()
        cmd.terminal()
    end,
    { desc = 'New Shell' }
)

-- Python Shell
map(i + n + v, '<C-p>',
    function()
        cmd.split()
        cmd.startinsert()
        cmd.terminal('python')
    end,
    { desc = 'New Python Shell', }
)

-- Indenting:
map(v, '<', '<gv', { desc = 'Dedent line', noremap = true, })
map(v, '>', '>gv', { desc = 'Indent line', noremap = true, })

-- Formatting:
map(n, 'W', 'gwip', { desc = 'Wrap paragraph' })
map(v, 'W', 'gw', { desc = 'Wrap paragraph' })

-- Selection:
map(n, '<S-Home>', 'Vgg', { desc = 'Go to beginning of line' })
map(n, '<S-End>', 'VG', { desc = 'Go to end of line' })

-- Yanking & Pasting:
--
-- yank whole buffer:
map(n, 'y.', '<CMD> %y+ <CR>', { desc = 'Yank current buffer' })
-- paste and replace selection, but don't yank it:
map(x, '<leader>p', 'p:let @+=@0<CR>:let @"=@0<CR>', { desc = 'Paste w/o replacing register' })

-- Open QuickFix window:
map(i + n + v + t, '<C-q>', '<CMD> copen <CR>', { desc = 'Open QuickFix' })

-- cd to folder of current file:
map(n, '<leader>wd', '<CMD> lcd %:p:h<CR>', { desc = '`cd` to folder of current file' })

-- Diagnostics keymaps:
map(n, '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
map(n, ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
map(n, '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
map(n, '<leader>od', vim.diagnostic.setloclist, { desc = 'Open Diagnostics' })

-- Misc:
map(n, '<leader>tl', '<CMD> set list!<CR>', { desc = 'Toggle listchars' })
map(n, '<leader>tn', '<CMD> set nu! <CR>', { desc = 'Toggle line numbers' })
map(n, '<leader>tr', '<CMD> set rnu! <CR>', { desc = 'Toggle relative numbers' })
map(n, '<Esc>', '<CMD> noh <CR>', { desc = 'Clear highlights' })
map(t, '<Esc>', vim.api.nvim_replace_termcodes('<C-\\><C-N>', true, true, true),
    { desc = 'Escape terminal mode', noremap = true })
