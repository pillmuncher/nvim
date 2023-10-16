vim.g.undotree_WindowLayout = 4
vim.g.undotree_SetFocusWhenToggle = 1

return {
    'mbbill/undotree',
    keys = {
        {
            '<C-u>',
            '<CMD> UndotreeToggle <CR>',
            desc = 'Toggle UndoTree',
            mode = { 'i', 'n' },
        },
    },
}
