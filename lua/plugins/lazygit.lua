return {
    'kdheepak/lazygit.nvim',
    dependencies = {
        -- optional for floating window border decoration
        { 'nvim-lua/plenary.nvim' },
    },
    keys         = {
        {
            '<C-G>',
            '<CMD> LazyGit <CR>',
            desc = 'Open LazyGit',
            mode = 'n',
        },
    },
}
