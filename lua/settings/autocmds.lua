-------------------------------------- autocmds ------------------------------------------

-- close terminal window on <c-d>
vim.api.nvim_create_autocmd(
    'TermOpen',
    {
        pattern = '*',
        callback = function()
            map(t, '<c-d>', '<CMD> bd! <CR>', { buffer = 0 })
        end,
    }
)

-- dont list quickfix buffers
vim.api.nvim_create_autocmd(
    'FileType',
    {
        pattern = 'qf',
        callback = function() vim.opt_local.buflisted = false end,
    }
)

vim.api.nvim_create_autocmd({
    'BufModifiedSet', -- include this if you have set `show_modified` to `true`
    'BufWinEnter',
    'CursorHold',
    'InsertLeave',
    'WinResized',
}, {
    group = vim.api.nvim_create_augroup('barbecue.updater', {}),
    callback = function() require('barbecue.ui').update() end,
})

local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
    pattern = '*',
    group = highlight_group,
    callback = function() vim.highlight.on_yank() end,
})
