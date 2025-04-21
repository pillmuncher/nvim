return {
    'nvim-neotest/neotest',
    dependencies = {
        'Issafalcon/neotest-dotnet',
        'nvim-neotest/neotest-plenary',
        'nvim-neotest/neotest-python',
        'nvim-neotest/neotest-vim-test',
        'nvim-neotest/nvim-nio',
        'rcasia/neotest-bash',
    },
    config = function()
        require('neotest').setup({
            adapters = {
                require('neotest-plenary'),
                require('neotest-python')({
                    dap = { justMyCode = true },
                    verbose = true, -- This will print out more debug information.
                    runner = 'pytest',
                    on_output = function(output)
                        print("Neotest Output: ", output)
                    end,
                }),
                require('neotest-vim-test')({
                    ignore_file_types = { 'python', 'vim', 'lua' },
                }),
            },
            quickfix = {
                enabled = true,
                open = false,
            },
            output = {
                enabled = true,
                open_on_run = true,
            },
            diagnostic = {
                enabled = true
            },
            signs = {
                enabled = true,
                priority = 40,
            }
        })
    end,
}
