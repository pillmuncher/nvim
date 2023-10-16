return {
    'smjonas/inc-rename.nvim',
    opts = {},
    keys = {
        {
            '<leader>lr',
            function()
                return ':IncRename ' .. vim.fn.expand('<cword>')
            end,
            desc = '[L]SP [R]ename',
            mode = { 'n' },
            expr = true,
        },
    },
}
