-- 'gc' to comment visual regions/lines
return {
    'numToStr/Comment.nvim',
    opts = {},
    keys = {
        {
            '<C-#>',
            function()
                require('Comment.api').toggle.linewise.current()
            end,
            desc = 'Toggle comment',
            mode = { 'i', 'n' },
        },
        {
            '<C-#>',
            '<ESC><CMD>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>',
            desc = 'Toggle comment',
            mode = { 'v' },
        },
    },
}
