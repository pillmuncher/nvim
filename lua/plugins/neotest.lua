return {
    'nvim-neotest/neotest',
    dependencies = {
        'nvim-neotest/neotest-python',
        'nvim-neotest/neotest-plenary',
        'nvim-neotest/neotest-vim-test',
        'andythigpen/nvim-coverage',
        'nvim-neotest/nvim-nio',
    },
    config = function()
        require('neotest').setup({
            adapters = {
                require('neotest-plenary'),
                -- require('neotest-python')({
                --     dap = { justMyCode = false },
                --     python = function()
                --         return vim.fn.system("pdm info --python-path"):gsub("%s+$", "")
                --     end,
                -- }),
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
