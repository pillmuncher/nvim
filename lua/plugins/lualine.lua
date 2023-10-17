return {
    'nvim-lualine/lualine.nvim',
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
                    'filetype',
                    icon_only = true,           -- Display only an icon for filetype
                    icon = { align = 'right' }, -- Display filetype icon on the right hand side
                },
                {
                    'filename',
                    path = 4,
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
