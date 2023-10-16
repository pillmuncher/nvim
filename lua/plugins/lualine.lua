return {
    'nvim-lualine/lualine.nvim',
    dependencies = {
        { 'nvim-tree/nvim-web-devicons', opts = {} },
    },
    opts = {
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
