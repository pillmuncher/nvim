return {
    'kdheepak/lazygit.nvim',
    -- enabled = false,
    -- optional for floating window border decoration
    dependencies = {
        { 'nvim-lua/plenary.nvim' },
    },
    keys = {
        {
            '<C-g>',
            '<CMD> LazyGit <CR>',
            desc = 'Open LazyGit',
            mode = { 'n' },
        },
    },
}
