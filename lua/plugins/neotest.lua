return {
    'nvim-neotest/neotest',
    dependencies = {
        { 'nvim-neotest/neotest-python' },
        { 'nvim-neotest/neotest-plenary' },
        { 'nvim-neotest/neotest-vim-test' },
        { 'nvim-neotest/nvim-nio' },
    },
    config = function()
        require('neotest').setup({
            adapters = {
                require('neotest-python')({
                    dap = { justMyCode = false },
                }),
                require('neotest-plenary'),
                require('neotest-vim-test')({
                    ignore_file_types = { 'python', 'vim', 'lua' },
                }),
            },
        })
    end,
}
