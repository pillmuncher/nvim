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
    },
}
