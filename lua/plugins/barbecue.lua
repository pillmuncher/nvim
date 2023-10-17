return {
    'utilyre/barbecue.nvim',
    -- enabled = false,
    name = 'barbecue',
    version = '*',
    dependencies = {
        { 'SmiteshP/nvim-navic',         opts = {} },
        { 'nvim-tree/nvim-web-devicons', opts = {} },
    },
    opts = {
        show_dirname = false,
        context_follow_icon_color = true,
    },
}
