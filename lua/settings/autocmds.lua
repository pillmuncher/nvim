-- be more concise:
local api = vim.api

-- close terminal window on <c-d>
api.nvim_create_autocmd('TermOpen', {
    pattern = '*',
    callback = function()
        vim.keymap.set('t', '<c-d>', '<CMD> bd! <CR>', { buffer = 0 })
    end,
})

-- dont list quickfix buffers
api.nvim_create_autocmd('FileType', {
    pattern = 'qf',
    callback = function() vim.opt_local.buflisted = false end,
})

-- set textwidth for lua
api.nvim_create_autocmd('FileType', {
    pattern = 'lua',
    callback = function() vim.opt_local.textwidth = 98 end,
})

-- set textwidth for csharp
api.nvim_create_autocmd('FileType', {
    pattern = 'cs',
    callback = function() vim.opt_local.textwidth = 98 end,
})

-- set textwidth for python
api.nvim_create_autocmd('FileType', {
    pattern = 'python',
    callback = function() vim.opt_local.textwidth = 79 end,
})

-- keep the winbar updated:
api.nvim_create_autocmd({
    'WinScrolled',
    'WinResized',
    'InsertLeave',
    'CursorHold',
    'BufWinEnter',
}, {
    group = api.nvim_create_augroup('barbecue.updater', {}),
    callback = function() require('barbecue.ui').update() end,
})

-- make a little flash when yanking:
api.nvim_create_autocmd('TextYankPost', {
    pattern = '*',
    group = api.nvim_create_augroup('YankHighlight', { clear = true }),
    callback = function() vim.highlight.on_yank() end,
})
