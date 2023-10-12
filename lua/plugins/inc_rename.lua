return {
    "smjonas/inc-rename.nvim",
    opts = {},
    keys = {
        {
            "<leader>lr",
            function()
                local line = ":IncRename " .. vim.fn.expand("<cword>")
                vim.api.nvim_feedkeys(line, "n", true)
            end,
            desc = "[L]SP [R]ename",
            mode = { "n" },
        },
    },
}
