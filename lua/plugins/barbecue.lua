return {
    'utilyre/barbecue.nvim',
    name = 'barbecue',
    version = '*',
    dependencies = {
        { 'SmiteshP/nvim-navic',         opts = {}, dependencies = { 'neovim/nvim-lspconfig' } },
        { 'nvim-tree/nvim-web-devicons', opts = {}, },
    },
    opts = {
        show_dirname = false,
        context_follow_icon_color = true,
    },
}
