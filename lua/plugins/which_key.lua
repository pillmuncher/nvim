return {
    'folke/which-key.nvim',
    opts = {},
    keys = {
        {
            '<leader>:',
            function()
                local input = vim.fn.input 'WhichKey: '
                vim.cmd('WhichKey ' .. input)
            end,
            desc = 'WhichKey',
            mode = 'n',
        },
    },
}
