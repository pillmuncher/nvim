return {
    'smjonas/inc-rename.nvim',
    opts = {},
    keys = {
        {
            '<leader>cr',
            function()
                return ':IncRename ' .. vim.fn.expand('<cword>')
            end,
            desc = 'Code Rename',
            mode = 'n',
            expr = true,
        },
    },
}
