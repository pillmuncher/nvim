return {
    -- Add indentation guides even on blank lines
    -- See `:help ibl
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    keys = {},
    opts = {
        enabled = false,
        indent = { char = '▏' },
        scope = { enabled = false },
        whitespace = { remove_blankline_trail = true },
    },
}
