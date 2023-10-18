return {
    'utilyre/barbecue.nvim',
    name = 'barbecue',
    version = '*',
    dependencies = {
        { 'SmiteshP/nvim-navic',         opts = {} },
        { 'nvim-tree/nvim-web-devicons', opts = {} },
    },
    opts = {
        context_follow_icon_color = true,
        create_autocmd = false,
        show_dirname = false,
    },
}
