return {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
        -- See `:help gitsigns.txt`
        signs = {
            add = { text = '+' },
            change = { text = '~' },
            delete = { text = '_' },
            topdelete = { text = '‾' },
            changedelete = { text = '~' },
        },
        on_attach = function(bufnr)
            vim.keymap.set('n', '<leader>hp', require('gitsigns').preview_hunk, { buffer = bufnr, desc = 'Preview git hunk' })
            -- don't override the built-in and fugitive keymaps
            local gs = package.loaded.gitsigns
            vim.keymap.set({ 'n', 'v' }, ']c', function()
                if vim.wo.diff then
                    return ']c'
                end
                vim.schedule(function()
                    gs.next_hunk()
                end)
                return '<Ignore>'
            end, { expr = true, buffer = bufnr, desc = 'Jump to next hunk' })
            vim.keymap.set({ 'n', 'v' }, '[c', function()
                if vim.wo.diff then
                    return '[c'
                end
                vim.schedule(function()
                    gs.prev_hunk()
                end)
                return '<Ignore>'
            end, { expr = true, buffer = bufnr, desc = 'Jump to previous hunk' })
        end,
    },
    keys = {
        {
            "]c",
            function()
                if vim.wo.diff then
                    return "]c"
                end
                vim.schedule(function()
                    require("gitsigns").next_hunk()
                end)
                return "<Ignore>"
            end,
            desc = "Jump to next hunk",
            mode = { "n" },
            opts = { expr = true },
        },
        {
            "[c",
            function()
                if vim.wo.diff then
                    return "[c"
                end
                vim.schedule(function()
                    require("gitsigns").prev_hunk()
                end)
                return "<Ignore>"
            end,
            desc = "Jump to prev hunk",
            mode = { "n" },
            opts = { expr = true },
        },

        {
            "<leader>gb",
            function()
                package.loaded.gitsigns.blame_line()
            end,
            desc = "Blame line",
            mode = { "n" },
        },
        {
            "<leader>ph",
            function()
                require("gitsigns").preview_hunk()
            end,
            desc = "Preview hunk",
            mode = { "n" },
        },
        {
            "<leader>rh",
            function()
                require("gitsigns").reset_hunk()
            end,
            desc = "Reset hunk",
            mode = { "n" },
        },
        {
            "<leader>td",
            function()
                require("gitsigns").toggle_deleted()
            end,
            desc = "Toggle deleted",
            mode = { "n" },
        },
    },
}
