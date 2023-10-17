return {
    'smjonas/inc-rename.nvim',
    -- enabled = false,
    opts = {},
    keys = {
        {
            '<leader>lr',
            function()
                return ':IncRename ' .. vim.fn.expand('<cword>')
            end,
            desc = 'LSP Rename',
            mode = { 'n' },
            expr = true,
        },
    },
}
