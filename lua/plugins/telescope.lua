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
        },
    },
    keys = {
        {
            "<leader>cm",
            "<CMD> Telescope git_commits <CR>",
            desc = "Git commits",
            mode = { "n" },
        },
        {
            "<leader>fa",
            "<CMD> Telescope find_files follow=true no_ignore=true hidden=true <CR>",
            desc = "Find all",
            mode = { "n" },
        },
        {
            "<leader>fb",
            "<CMD> Telescope buffers <CR>",
            desc = "Find buffers",
            mode = { "n" },
        },
        {
            "<leader>ff",
            "<CMD> Telescope find_files <CR>",
            desc = "Find files",
            mode = { "n" },
        },
        {
            "<leader>fh",
            "<CMD> Telescope help_tags <CR>",
            desc = "Help page",
            mode = { "n" },
        },
        {
            "<leader>fo",
            "<CMD> Telescope oldfiles <CR>",
            desc = "Find oldfiles",
            mode = { "n" },
        },
        {
            "<leader>fw",
            "<CMD> Telescope live_grep <CR>",
            desc = "Live grep",
            mode = { "n" },
        },
        {
            "<leader>fz",
            "<CMD> Telescope current_buffer_fuzzy_find <CR>",
            desc = "Find in current buffer",
            mode = { "n" },
        },
        {
            "<leader>gt",
            "<CMD> Telescope git_status <CR>",
            desc = "Git status",
            mode = { "n" },
        },
        {
            "<leader>ma",
            "<CMD> Telescope marks <CR>",
            desc = "Find bookmarks",
            mode = { "n" },
        },
        {
            "<leader>pt",
            "<CMD> Telescope terms <CR>",
            desc = "Pick hidden term",
            mode = { "n" },
        },
        {
            "<leader>th",
            "<CMD> Telescope themes <CR>",
            desc = "Show themes",
            mode = { "n" },
        },
        {
            '<leader>fz', 
            function()
                -- You can pass additional configuration to telescope to change theme, layout, etc.
                require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
                    winblend = 10,
                    previewer = false,
                })
            end,
            desc = 'Fuzzily search in current buffer',
        },
    },
}
