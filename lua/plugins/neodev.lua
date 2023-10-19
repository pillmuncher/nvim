return {
    'folke/neodev.nvim',
    dependencies = {
        { 'nvim-lua/plenary.nvim' },
        { 'nvim-treesitter/nvim-treesitter' },
        { 'antoinemadec/FixCursorHold.nvim' },
        { 'nvim-neotest/neotest-python' },
    },
    config = function()
        require('neodev').setup({
            library = {
                plugins = { 'nvim-dap-ui', 'neotest' },
                types = true,
            },
        })
    end,
}
