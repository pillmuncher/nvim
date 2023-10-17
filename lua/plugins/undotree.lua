vim.g.undotree_RelativeTimestamp = 1
vim.g.undotree_SetFocusWhenToggle = 1
vim.g.undotree_ShortIndicators = 1
vim.g.undotree_WindowLayout = 4

return {
    'mbbill/undotree',
    enabled = true,
    keys = {
        {
            '<C-u>',
            '<CMD> UndotreeToggle <CR>',
            desc = 'Toggle UndoTree',
            mode = { 'i', 'n' },
        },
    },
}
