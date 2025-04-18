return {
    'HiPhish/rainbow-delimiters.nvim',
    config = function()
        require('rainbow-delimiters.setup').setup({
            strategy = {
                [''] = 'rainbow-delimiters.strategy.global',
                vim = 'rainbow-delimiters.strategy.local',
                clojure = 'rainbow-delimiters.strategy.local',
                python = 'rainbow-delimiters.strategy.global',
            },
            query = {
                [''] = 'rainbow-delimiters',
                lua = 'rainbow-blocks',
                clojure = 'rainbow-delimiters',
                python = 'rainbow-delimiters',
            },
            priority = {
                [''] = 110,
                lua = 210,
            },
            highlight = {
                'RainbowDelimiterRed',
                'RainbowDelimiterYellow',
                'RainbowDelimiterBlue',
                'RainbowDelimiterOrange',
                'RainbowDelimiterGreen',
                'RainbowDelimiterViolet',
                'RainbowDelimiterCyan',
            }
        })
    end,
    ft = { 'python', 'lua', 'clojure', 'vim' } -- Ensure it's loaded for Python
}
