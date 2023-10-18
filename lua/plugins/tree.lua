vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

return {
    'nvim-tree/nvim-tree.lua',
    dependencies = {
        { 'nvim-tree/nvim-web-devicons', opts = {}, },
    },
    opts = {},
    keys = {
        {
            '<C-N>',
            '<CMD> NvimTreeToggle <CR>',
            desc = 'Toggle NvimTree',
            mode = { 'i', 'n' },
        },
    },
}
