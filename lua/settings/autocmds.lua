-- close terminal window on <c-d>
vim.api.nvim_create_autocmd('TermOpen', {
    pattern = '*',
    callback = function()
        map('t', '<c-d>', '<CMD> bd! <CR>', { buffer = 0 })
    end,
})

-- dont list quickfix buffers
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'qf',
    callback = function() vim.opt_local.buflisted = false end,
})

-- keep the winbar updated:
vim.api.nvim_create_autocmd({ 'BufWinEnter', 'CursorHold', 'InsertLeave', 'WinResized' }, {
    group = vim.api.nvim_create_augroup('barbecue.updater', {}),
    callback = function() require('barbecue.ui').update() end,
})

-- make a little flash when yanking:
vim.api.nvim_create_autocmd('TextYankPost', {
    pattern = '*',
    group = vim.api.nvim_create_augroup('YankHighlight', { clear = true }),
    callback = function() vim.highlight.on_yank() end,
})
