return {
    'Exafunction/codeium.vim',
    event = 'BufEnter',
    keys = {
        {
            '<C-Enter>',
            '<Cmd> call codeium#Accept() <CR>',
            desc = 'Next Codeium Suggestion',
            mode = { 'i' },
        },
        {
            '<M-Right>',
            '<Cmd> call codeium#CycleCompletions(1) <CR>',
            desc = 'Next Codeium Suggestion',
            mode = { 'i' },
        },
        {
            '<M-Left>',
            '<Cmd> call codeium#CycleCompletions(-1) <CR>',
            desc = 'Previous Codeium Suggestion',
            mode = { 'i' },
        },
    },
}
