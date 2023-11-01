return {
    'ThePrimeagen/git-worktree.nvim',
    keys = {
        {
            '<leader>ft',
            function()
                require('telescope').extensions.git_worktree.git_worktrees()
            end,
            desc = 'Find Git Worktree',
        }
    },
}
