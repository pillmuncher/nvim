-- Add indentation guides even on blank lines
-- See `:help ibl
return {
    'lukas-reineke/indent-blankline.nvim',
    lazy = false,
    main = 'ibl',
    opts = {
        enabled = false,
        indent = { char = "▏" },
        scope = { enabled = true },
        whitespace = { remove_blankline_trail = true },
    },
    keys = {
        {
            '<leader>ti',
            '<CMD> IBLToggle <CR>',
            desc = 'Toggle IndentLines',
            mode = { 'n' },
        },
        {
            '<leader>cc',
            function()
                local ok, start = require('ibl.utils').get_current_context(
                    vim.g.indent_blankline_context_patterns,
                    vim.g.indent_blankline_use_treesitter_scope
                )
                if ok then
                    vim.api.nvim_win_set_cursor(vim.api.nvim_get_current_win(), { start, 0 })
                    vim.cmd [[normal! _]]
                end
            end,
            desc = 'Jump to current context',
            mode = { 'n' },
        },
    },
}
