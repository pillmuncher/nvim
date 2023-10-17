return {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
        { 'nvim-lua/plenary.nvim' },
        -- Fuzzy Finder Algorithm which requires local dependencies to be built.
        -- Only load if `make` is available. Make sure you have the system
        -- requirements installed.
        {
            'nvim-telescope/telescope-fzf-native.nvim',
            -- NOTE: If you are having trouble with this installation,
            --       refer to the README for telescope-fzf-native for more instructions.
            build = 'make',
            cond = function()
                return vim.fn.executable 'make' == 1
            end,
        },
    },
    opts = {
        defaults = {
            mappings = {
                i = {
                    ['<C-U>'] = false,
                    ['<C-D>'] = false,
                },
            },
            sorting_strategy = 'ascending',
        },
    },
    keys = {
        {
            '<leader>gc',
            '<CMD> Telescope git_commits <CR>',
            desc = 'Git Commits',
            mode = { 'n' },
        },
        {
            '<leader>fa',
            '<CMD> Telescope find_files follow=true no_ignore=true hidden=true <CR>',
            desc = 'Find All',
            mode = { 'n' },
        },
        {
            '<leader>fb',
            '<CMD> Telescope buffers <CR>',
            desc = 'Find Buffers',
            mode = { 'n' },
        },
        {
            '<leader>of',
            '<CMD> Telescope find_files <CR>',
            desc = 'Open File',
            mode = { 'n' },
        },
        {
            '<leader>gf',
            '<CMD> Telescope git_files <CR>',
            desc = 'Git Files',
            mode = { 'n' },
        },
        {
            '<leader>fh',
            '<CMD> Telescope help_tags <CR>',
            desc = 'Find Help',
            mode = { 'n' },
        },
        {
            '<leader>fr',
            '<CMD> Telescope oldfiles <CR>',
            desc = 'Find Recent Files',
            mode = { 'n' },
        },
        {
            '<leader>og',
            '<CMD> Telescope live_grep <CR>',
            desc = 'Open Grep',
            mode = { 'n' },
        },
        {
            '<leader>gt',
            '<CMD> Telescope git_status <CR>',
            desc = 'Git Status',
            mode = { 'n' },
        },
        {
            '<leader>ma',
            '<CMD> Telescope marks <CR>',
            desc = 'Find bookmarks',
            mode = { 'n' },
        },
    },
}
