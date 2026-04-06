return {
    -- Auto pairs
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = true,
    },

    -- Which-key
    {
        "folke/which-key.nvim",
        lazy = false,
        dependencies = {
            { "echasnovski/mini.icons", version = "*" },
        },
        config = function()
            local wk = require("which-key")
            wk.setup({})
            wk.add({
                { "gc", hidden = true },
            })
        end,
    },

    -- Incremental rename
    { "smjonas/inc-rename.nvim", config = true },

    -- Undo tree
    {
        "mbbill/undotree",
        init = function()
            vim.g.undotree_RelativeTimestamp = 1
            vim.g.undotree_SetFocusWhenToggle = 1
            vim.g.undotree_ShortIndicators = 1
            vim.g.undotree_WindowLayout = 4
        end,
    },

    -- Session management
    { "tpope/vim-obsession" },
}
