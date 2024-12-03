return {
    'nvim-lualine/lualine.nvim',
    dependencies = { { 'nvim-tree/nvim-web-devicons' }, },
    opts
                 = {
        extensions = { 'fzf', 'lazy', 'man', 'mason', 'nvim-dap-ui', 'nvim-tree', 'quickfix',
            'symbols-outline', 'toggleterm', },
        options = {
            component_separators = { left = '', right = '' },
            section_separators = { left = '', right = '' },
        },
        sections = {
            lualine_c = { { 'filetype', icon_only = true, icon = { align = 'right' },
            }, {
                'filename',
                path = 4,
                file_status = true,
                newfile_status = true,
                symbols = {
                    modified
                             = '[✗]',
                    readonly = '[]',
                }
            }, },
            lualine_x = { 'selectioncount', 'searchcount',
                -- '%{"AI:"}%3{codeium#GetStatusString()}',
            },
            lualine_y = { 'fileformat', 'encoding', },
            lualine_z = { 'progress', 'location', },
        },
    },
}
