vim.keymap.set('n', 'gb', '<Nop>', { desc = '' })
vim.keymap.set('n', 'gc', '<Nop>', { desc = '' })
return {
    'hrsh7th/nvim-cmp',
    dependencies = {
        { 'hrsh7th/cmp-nvim-lsp',        opts = {} },
        { 'L3MON4D3/LuaSnip',            opts = {} },
        { 'saadparwaiz1/cmp_luasnip' },
        { 'rafamadriz/friendly-snippets' },
    },
    opts = {},
}
