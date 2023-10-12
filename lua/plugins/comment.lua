-- "gc" to comment visual regions/lines
return {
    'numToStr/Comment.nvim',
    opts = {},
    keys = {
        {
            "<leader>/",
            "<ESC><CMD>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
            desc = "Toggle comment",
            mode = { "v" },
        },
        {
            "<leader>/",
            function()
                require("Comment.api").toggle.linewise.current()
            end,
            desc = "Toggle comment",
            mode = { "n" },
        },
    },
}
