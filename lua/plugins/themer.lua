return {
    'themercorp/themer.lua',
    dependencies = {
        { 'nvim-telescope/telescope.nvim', opts = {} },
    },
    opts = {
        colorscheme = 'nightlamp',
        enable_installer = true,
        styles = {
            ['function']    = { style = 'italic' },
            functionbuiltin = { style = 'italic' },
            variable        = { style = 'italic' },
            variableBuiltIn = { style = 'italic' },
            parameter       = { style = 'italic' },
        },
    },
    keys = {
        {
            '<C-t>',
            '<CMD> Telescope themes <CR>',
            desc = 'Open Colorschemes',
            mode = { 'n' },
        },
    },
}
