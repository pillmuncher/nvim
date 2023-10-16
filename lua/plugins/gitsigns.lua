return {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    lazy = false,
    opts = {
        -- See `:help gitsigns.txt`
        signs = {
            add = { text = '+' },
            change = { text = '~' },
            delete = { text = '_' },
            topdelete = { text = '‾' },
            changedelete = { text = '~' },
        },
    },
    keys = {
        {
            '<leader>hv',
            function()
                require('gitsigns').preview_hunk()
            end,
            desc = 'Preview hunk',
            {
                mode = { 'n' },
            },
        },
        {
            '<leader>hn',
            function()
                if vim.wo.diff then
                    return 'hn'
                end
                vim.schedule(function()
                    require('gitsigns').next_hunk()
                end)
                return '<Ignore>'
            end,
            desc = 'Jump to next hunk',
            {
                mode = { 'n' },
            },
        },
        {
            '<leader>hN',
            function()
                if vim.wo.diff then
                    return 'hp'
                end
                vim.schedule(function()
                    require('gitsigns').prev_hunk()
                end)
                return '<Ignore>'
            end,
            desc = 'Jump to prev hunk',
            {
                mode = { 'n' },
            },
        },
        {
            '<leader>hd',
            function()
                require('gitsigns').toggle_deleted()
            end,
            desc = 'Toggle deleted',
            {
                mode = { 'n' },
            },
        },
        {
            '<leader>hr',
            function()
                require('gitsigns').reset_hunk()
            end,
            desc = 'Reset hunk',
            {
                mode = { 'n' },
            },
        },
        {
            '<leader>gb',
            function()
                package.loaded.gitsigns.blame_line()
            end,
            desc = 'Blame line',
            {
                mode = { 'n' },
            },
        },
    },
}
