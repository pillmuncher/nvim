return {
    'lewis6991/gitsigns.nvim',
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
            function() require('gitsigns').preview_hunk() end,
            desc = 'Preview hunk',
            { mode = { 'n' }, },
        },
        {
            '<leader>hn',
            function()
                if vim.wo.diff then
                    return 'hn'
                end
                vim.schedule(function() require('gitsigns').next_hunk() end)
                return '<Ignore>'
            end,
            desc = 'Jump to Next Hunk',
            { mode = { 'n' }, },
        },
        {
            '<leader>hN',
            function()
                if vim.wo.diff then
                    return 'hN'
                end
                vim.schedule(function() require('gitsigns').prev_hunk() end)
                return '<Ignore>'
            end,
            desc = 'Jump to Previous Hunk',
            { mode = { 'n' }, },
        },
        {
            '<leader>hd',
            function() require('gitsigns').toggle_deleted() end,
            desc = 'Toggle Deleted',
            { mode = { 'n' }, },
        },
        {
            '<leader>hr',
            function() require('gitsigns').reset_hunk() end,
            desc = 'Reset Hunk',
            { mode = { 'n' }, },
        },
        {
            '<leader>gb',
            function() package.loaded.gitsigns.blame_line() end,
            desc = 'Git Blame',
            { mode = { 'n' }, },
        },
    },
}
