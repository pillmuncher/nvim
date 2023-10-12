return {
    'folke/which-key.nvim',
    lazy = false,
    opts = {},
    keys = {
        {
            "<leader>wk",
            function()
                local input = vim.fn.input "WhichKey: "
                vim.cmd("WhichKey " .. input)
            end,
            desc = "Which-key query lookup",
            mode = { "n" }
        },
        {
            "<leader>wK",
            function()
                vim.cmd "WhichKey"
            end,
            desc = "Which-key all keymaps",
            mode = { "n" }
        },
    },
}
