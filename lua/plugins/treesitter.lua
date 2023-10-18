return {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
        { 'nvim-treesitter/nvim-treesitter-textobjects', },
    },
    opts = {},
    build = ':TSUpdate',
}
