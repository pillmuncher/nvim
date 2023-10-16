return {
    'kdheepak/lazygit.nvim',
    -- optional for floating window border decoration
    dependencies = {
        { 'nvim-lua/plenary.nvim' },
    },
    keys = {
        {
            '<C-g>',
            '<CMD> LazyGit <CR>',
            desc = '[O]pen [L]azyGit',
            mode = { 'n' },
        },
    },
}
