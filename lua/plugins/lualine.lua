return {
    'nvim-lualine/lualine.nvim',
    -- enabled = false,
    dependencies = {
        { 'nvim-tree/nvim-web-devicons', opts = {} },
    },
    opts = {
        extensions = {
            'fzf',
            'lazy',
            'nvim-tree',
            'quickfix',
        },
        options = {
            component_separators = { left = '', right = '' },
            section_separators = { left = '', right = '' },
            -- globalstatus = true,
        },
        sections = {
            lualine_c = {
                {
                    'filename',
                    path = 3,
                    file_status = true,
                    newfile_status = true,
                    symbols = {
                        modified = '[✗]',
                        readonly = '[]',
                    }
                },
                'selectioncount',
            },
            lualine_x = {
                -- 'hostname',
                'searchcount',
            },
            lualine_y = {
                'fileformat',
                'encoding',
            },
            lualine_z = {
                'progress',
                'location',
            },
        },
    },
}
