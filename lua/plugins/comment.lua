return {
    'numToStr/Comment.nvim',
    opts = {},
    keys = {
        {
            '<C-#>',
            function() require('Comment.api').toggle.linewise.current() end,
            desc = 'Toggle Comment',
            mode = { 'i', 'n' },
        },
        {
            '<C-#>',
            '<ESC><CMD>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>',
            desc = 'Toggle Comment',
            mode = 'v',
        },
    },
}
