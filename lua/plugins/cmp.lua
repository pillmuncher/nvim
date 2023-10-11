return {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
        -- Snippet Engine & its associated nvim-cmp source
        { 'L3MON4D3/LuaSnip',            opts = {} },
        { 'saadparwaiz1/cmp_luasnip' },
        -- Adds LSP completion capabilities
        { 'hrsh7th/cmp-nvim-lsp',        opts = {} },
        -- Adds a number of user-friendly snippets
        { 'rafamadriz/friendly-snippets' },
    },
    opts = {},
}
