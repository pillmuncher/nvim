return {
    'nvim-telescope/telescope.nvim',
    branch       = '0.1.x',
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
    config       = function()
        -- Enable telescope fzf native and git-worktree, if installed
        pcall(require('telescope').load_extension, 'fzf')
        pcall(require('telescope').load_extension, 'git_worktree')
    end,
    opts         = {
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
    keys         = {
        {
            '<leader>fa',
            '<CMD> Telescope find_files follow=true no_ignore=true hidden=true <CR>',
            desc = 'Find Any',
            mode = 'n',
        },
        {
            '<leader>fb',
            '<CMD> Telescope buffers <CR>',
            desc = 'Find Buffer',
            mode = 'n',
        },
        {
            '<leader>fc',
            '<CMD> Telescope git_commits <CR>',
            desc = 'Find Git Commit',
            mode = 'n',
        },
        {
            '<leader>ff',
            '<CMD> Telescope find_files <CR>',
            desc = 'Find File',
            mode = 'n',
        },
        {
            '<leader>fg',
            '<CMD> Telescope git_files <CR>',
            desc = 'Find Git File',
            mode = 'n',
        },
        {
            '<leader>fh',
            '<CMD> Telescope help_tags <CR>',
            desc = 'Find Help',
            mode = 'n',
        },
        {
            '<leader>fm',
            '<CMD> Telescope marks <CR>',
            desc = 'Find Marks',
            mode = 'n',
        },
        {
            '<leader>fr',
            '<CMD> Telescope oldfiles <CR>',
            desc = 'Find Recent',
            mode = 'n',
        },
        {
            '<leader>fx',
            '<CMD> Telescope live_grep <CR>',
            desc = 'Find Regex',
            mode = 'n',
        },
        {
            '<leader>fs',
            '<CMD> Telescope git_status <CR>',
            desc = 'Git Status',
            mode = 'n',
        },
    },
}
