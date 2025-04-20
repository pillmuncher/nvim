return {
    'xiyaowong/transparent.nvim',
    -- Optional, you don't have to run setup.
    -- table: default groups
    config = function()
        require('transparent').setup({
            groups = {
                'Comment',
                'Conditional',
                'Constant',
                'CursorLine',
                'CursorLineNr',
                'EndOfBuffer',
                'Function',
                'Identifier',
                'LineNr',
                'NonText',
                'Normal',
                'NormalNC',
                'Operator',
                'PreProc',
                'Repeat',
                'SignColumn',
                'Special',
                'Statement',
                'String',
                'Structure',
                'Todo',
                'Type',
                'Underlined',
            },
            -- table: additional groups that should be cleared
            extra_groups = {
                'DiagnosticOK',
                'DiagnosticSignError',
                'DiagnosticSignHint',
                'DiagnosticSignInfo',
                'DiagnosticSignWarn',
                'GitSignsAdd',
                'GitSignsAddLnInline',
                'GitSignChange',
                'GitSignsChange',
                'GitSignsDelete',
                'SignColumn',
                'StatusLine',
                'StatusLineNC',
            },
            -- table: groups you don't want to clear
            exclude_groups = {
            },
            -- function: code to be executed after highlight groups are cleared
            -- Also the user event "TransparentClear" will be triggered
            on_clear = function() end,
        })
    end,
}
