return {
    'folke/which-key.nvim',
    lazy = false,
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
    config = function()
        -- document existing key chains
        require('which-key').register {
            ['<leader>c'] = { name = 'Code', _ = 'which_key_ignore' },
            ['<leader>d'] = { name = 'Document', _ = 'which_key_ignore' },
            ['<leader>f'] = { name = 'Find', _ = 'which_key_ignore' },
            ['<leader>g'] = { name = 'Git', _ = 'which_key_ignore' },
            ['<leader>h'] = { name = 'More git', _ = 'which_key_ignore' },
            -- ['<leader>r'] = { name = 'Rename', _ = 'which_key_ignore' },
            ['<leader>j'] = { name = 'Jump', _ = 'which_key_ignore' },
            ['<leader>o'] = { name = 'Open', _ = 'which_key_ignore' },
            ['<leader>s'] = { name = 'Show', _ = 'which_key_ignore' },
            ['<leader>t'] = { name = 'Toggle', _ = 'which_key_ignore' },
            ['<leader>w'] = { name = 'Workspace', _ = 'which_key_ignore' },
        }
    end
}
