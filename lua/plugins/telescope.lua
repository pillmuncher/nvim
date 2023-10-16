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
                    ['<C-u>'] = false,
                    ['<C-d>'] = false,
                },
            },
            sorting_strategy = 'ascending',
        },
    },
    keys = {
        {
            '<leader>cm',
            '<CMD> Telescope git_commits <CR>',
            desc = 'Git commits',
            mode = { 'n' },
        },
        {
            '<leader>fa',
            '<CMD> Telescope find_files follow=true no_ignore=true hidden=true <CR>',
            desc = '[F]ind [A]ll',
            mode = { 'n' },
        },
        {
            '<leader>fb',
            '<CMD> Telescope buffers <CR>',
            desc = '[F]ind [B]uffers',
            mode = { 'n' },
        },
        {
            '<leader>of',
            '<CMD> Telescope find_files <CR>',
            desc = '[O]pen [F]ile',
            mode = { 'n' },
        },
        {
            '<leader>gf',
            '<CMD> Telescope find_files <CR>',
            desc = '[G]it [F]iles',
            mode = { 'n' },
        },
        {
            '<leader>fh',
            '<CMD> Telescope help_tags <CR>',
            desc = '[F]ind [H]elp',
            mode = { 'n' },
        },
        {
            '<leader>fr',
            '<CMD> Telescope oldfiles <CR>',
            desc = '[F]ind [R]ecent Files',
            mode = { 'n' },
        },
        {
            '<leader>og',
            '<CMD> Telescope live_grep <CR>',
            desc = '[O]pen [G]rep',
            mode = { 'n' },
        },
        {
            '<leader>gt',
            '<CMD> Telescope git_status <CR>',
            desc = '[G]it [S]tatus',
            mode = { 'n' },
        },
        {
            '<leader>ma',
            '<CMD> Telescope marks <CR>',
            desc = 'Find bookmarks',
            mode = { 'n' },
        },
        {
            '<leader>ff',
            function()
                -- You can pass additional configuration to telescope to change theme, layout, etc.
                require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
                    winblend = 10,
                    previewer = false,
                })
            end,
            desc = '[F]ind [F]uzzily in current buffer',
        },
    },
}
