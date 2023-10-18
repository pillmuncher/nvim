return {
    'utilyre/barbecue.nvim',
    name = 'barbecue',
    dependencies = {
        { 'SmiteshP/nvim-navic',         opts = {} },
        { 'nvim-tree/nvim-web-devicons', opts = {} },
    },
    opts = {
        create_autocmd = false,
        show_dirname = false,
    },
}
