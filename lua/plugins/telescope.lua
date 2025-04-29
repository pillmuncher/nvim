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
        { 'ThePrimeagen/refactoring.nvim' },
    },
    config       = function()
        -- Enable telescope fzf native and git-worktree, if installed
        pcall(require('telescope').load_extension, 'fzf')
        pcall(require('telescope').load_extension, 'git_worktree')
        pcall(require("telescope").load_extension, "refactoring")
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
    keys         = {},
}
