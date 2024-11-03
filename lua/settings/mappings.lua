-- be more concise:
local map = vim.keymap.set
local cmd = vim.cmd

-- Seriously, guys. It's not like :W or :Q are mapped to anything anyway.
cmd.cnoreabbrev('Q', 'q')
cmd.cnoreabbrev('QA', 'qa')
cmd.cnoreabbrev('Qa', 'qa')
cmd.cnoreabbrev('qA', 'qa')
cmd.cnoreabbrev('W', 'w')
cmd.cnoreabbrev('WA', 'wa')
cmd.cnoreabbrev('Wa', 'wa')
cmd.cnoreabbrev('wA', 'wa')
cmd.cnoreabbrev('WQ', 'wq')
cmd.cnoreabbrev('Wq', 'wq')
cmd.cnoreabbrev('wQ', 'wq')
cmd.cnoreabbrev('WQA', 'wqa')
cmd.cnoreabbrev('WQa', 'wqa')
cmd.cnoreabbrev('WqA', 'wqa')
cmd.cnoreabbrev('Wqa', 'wqa')
cmd.cnoreabbrev('wQA', 'wqa')
cmd.cnoreabbrev('wQa', 'wqa')
cmd.cnoreabbrev('wqA', 'wqa')

-- leader is space, so we can set it to Nop.
map({ 'n', 'v' }, '<Space>', '<Nop>', { desc = '' })

-- make Shift-Up/Down keys not behave stupid in visual mode:
map({ 'n', 'v' }, '<S-Up>', '<Up>', { desc = '', silent = true })
map({ 'n', 'v' }, '<S-Down>', '<Down>', { desc = '', silent = true })

-- Window navigation:
map('n', '<C-PageUp>', '<CMD> bprev! <CR>', { desc = 'Change to previous buffer' })
map('n', '<C-PageDown>', '<CMD> bnext! <CR>', { desc = 'Change to next buffer' })
map('n', '<C-Up>', '<C-W>k', { desc = 'Change to window above' })
map('n', '<C-Down>', '<C-W>j', { desc = 'Change to window below' })
map('n', '<C-Left>', '<C-W>h', { desc = 'Change to window on the left' })
map('n', '<C-Right>', '<C-W>l', { desc = 'Change to window on the right' })

-- Window manipulation:
map('n', '<M-Up>', '<CMD> wincmd k <CR>:resize -2 <CR>', { desc = 'Increase lower window size' })
map('n', '<M-Down>', '<CMD> wincmd k <CR>:resize +2 <CR>', { desc = 'Increase upper window size' })

-- Buffer Management:
map('n', '<leader>bb', '<CMD> enew <CR>', { desc = 'New Buffer' })
map('n', '<leader>bc', '<CMD> bd <CR>', { desc = 'Close Current Buffer' })

map({ 'i', 'n', 'v', 't' }, '<C-D>',
    function()
        if #vim.api.nvim_list_wins() > 1 then
            vim.api.nvim_win_close(0, true)
        else
            cmd('bd')
        end
    end,
    { desc = 'Close window' })

-- Shell Terminal
map({ 'i', 'n', 'v' }, '<C-T>',
    function()
        cmd.split()
        cmd.startinsert()
        cmd.terminal()
    end,
    { desc = 'New Shell' }
)

-- Python Terminal
map({ 'i', 'n', 'v' }, '<C-P>',
    function()
        cmd.split()
        cmd.startinsert()
        cmd.terminal('python')
    end,
    { desc = 'New Python Shell', }
)

-- Indenting:
map('v', '<', '<gv', { desc = 'Dedent line', noremap = true, })
map('v', '>', '>gv', { desc = 'Indent line', noremap = true, })

-- Formatting:
map('n', 'W', 'gwip', { desc = 'Wrap paragraph' })
map('v', 'W', 'gw', { desc = 'Wrap paragraph' })

-- Yanking & Pasting:
--
-- yank whole buffer:
map('n', 'y.', '<CMD> %y+ <CR>', { desc = 'Yank current buffer' })
-- paste and replace selection, but don't yank it:
map('x', '<leader>p', 'p:let @+=@0<CR>:let @"=@0<CR>', { desc = 'Paste w/o replacing register' })

-- Open QuickFix window:
map({ 'n', 'v' }, '<leader>oq', '<CMD> copen <CR>', { desc = 'Open QuickFix' })

-- cd to folder of current file:
map('n', '<leader>wd', '<CMD> lcd %:p:h<CR>', { desc = '`cd` to folder of current file' })

-- Diagnostics keymaps:
map('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
map('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
map('n', '<leader>of', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
map('n', '<leader>od', vim.diagnostic.setloclist, { desc = 'Open Diagnostics' })

-- Misc:
map('n', '<leader>tc', '<CMD> set list!<CR>', { desc = 'Toggle Listchars' })
map('n', '<leader>tn', '<CMD> set nu! <CR>', { desc = 'Toggle Line Numbers' })
map('n', '<leader>tr', '<CMD> set rnu! <CR>', { desc = 'Toggle Relative Numbers' })
map('n', '<Esc>', '<CMD> noh <CR>', { desc = 'Clear highlights' })
map('t', '<Esc>', vim.api.nvim_replace_termcodes('<C-\\><C-N>', true, true, true),
    { desc = 'Escape terminal mode', noremap = true })

-- unmap gc to remove annoying :checkhealth message:
map('n', 'gc', '')

-- which-key config:
require("which-key").add({
    {
        '<leader>:',
        function()
            cmd('WhichKey ' .. vim.fn.input 'WhichKey: ')
        end,
        desc = 'WhichKey',
        mode = 'n',
    },
    { '<leader>b', group = 'Buffer' },
    { '<leader>c', group = 'Code' },
    { '<leader>f', group = 'Find' },
    { '<leader>h', group = 'Git Hunks' },
    { '<leader>j', group = 'Jump' },
    { '<leader>o', group = 'Open' },
    { '<leader>s', group = 'Show' },
    { '<leader>t', group = 'Toggle' },
    { '<leader>w', group = 'Workspace' },
    {
        '<C-#>',
        function() require('Comment.api').toggle.linewise.current() end,
        desc = 'Toggle Comment',
        mode = { 'i', 'n' },
    },
    {
        '<C-#>',
        '<ESC><CMD>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>',
        desc = 'Toggle Comment',
        mode = 'v',
    },
    {
        '<leader>hv',
        function() require('gitsigns').preview_hunk() end,
        desc = 'Preview hunk',
        { mode = 'n', },
    },
    {
        '<leader>hn',
        function()
            if vim.wo.diff then
                return 'hn'
            end
            vim.schedule(function() require('gitsigns').next_hunk() end)
            return '<Ignore>'
        end,
        desc = 'Jump to Next Hunk',
        { mode = 'n', },
    },
    {
        '<leader>hN',
        function()
            if vim.wo.diff then
                return 'hN'
            end
            vim.schedule(function() require('gitsigns').prev_hunk() end)
            return '<Ignore>'
        end,
        desc = 'Jump to Previous Hunk',
        { mode = 'n', },
    },
    {
        '<leader>td',
        function() require('gitsigns').toggle_deleted() end,
        desc = 'Toggle Deleted Lines',
        { mode = 'n', },
    },
    {
        '<leader>hr',
        function() require('gitsigns').reset_hunk() end,
        desc = 'Reset Hunk',
        { mode = 'n', },
    },
    {
        '<leader>sb',
        function() package.loaded.gitsigns.blame_line() end,
        desc = 'Show Git Blame',
        { mode = 'n', },
    },
    {
        '<C-G>',
        '<CMD> LazyGit <CR>',
        desc = 'Open LazyGit',
        mode = 'n',
    },
    {
        '<leader>ft',
        function()
            require('telescope').extensions.git_worktree.git_worktrees()
        end,
        desc = 'Find Git Worktree',
    },
    {
        '<leader>cr',
        function()
            return ':IncRename ' .. vim.fn.expand('<cword>')
        end,
        desc = 'Code Rename',
        mode = 'n',
        expr = true,
    },
    {
        '<leader>ti',
        '<CMD> IBLToggle <CR>',
        desc = 'Toggle IndentLines',
        mode = 'n',
    },
    {
        '<leader>ts',
        '<CMD> IBLToggleScope <CR>',
        desc = 'Toggle ScopeLines',
        mode = 'n',
    },
    -- {
    --     '<leader>gD',
    --     function() vim.lsp.buf.declaration() end,
    --     desc = 'Jump to Declaration',
    --     mode = 'n'
    -- },
    -- {
    --     '<leader>gd',
    --     function() vim.lsp.buf.definition() end,
    --     desc = 'Jump to Definition',
    --     mode = 'n'
    -- },
    {
        '<leader>gi',
        function() vim.lsp.buf.implementation() end,
        desc = 'Jump to Implementation',
        mode = 'n'
    },
    {
        '<leader>gt',
        function() vim.lsp.buf.type_definition() end,
        desc = 'Jump to Type',
        mode = 'n'
    },
    {
        '<leader>or',
        function() vim.lsp.buf.references() end,
        desc = 'Open References',
        mode = 'n'
    },
    {
        '<leader>sd',
        function() vim.lsp.buf.hover() end,
        desc = 'Show Documentation',
        mode = 'n'
    },
    {
        '<leader>ca',
        function() vim.lsp.buf.code_action() end,
        desc = 'Code Action',
        mode = 'n'
    },
    {
        '<leader>cf',
        function() vim.lsp.buf.format({ async = true }) end,
        desc = 'Code Format',
        mode = 'n'
    },
    {
        '<leader>ss',
        function() vim.lsp.buf.signature_help() end,
        desc = 'Show Signature',
        mode = 'n'
    },
    {
        '<leader>wa',
        function() vim.lsp.buf.add_workspace_folder() end,
        desc = 'New Workspace Folder',
        mode = 'n'
    },
    {
        '<leader>sw',
        function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
        desc = 'Show Workspace Folders',
        mode = 'n'
    },
    {
        '<leader>wr',
        function() vim.lsp.buf.remove_workspace_folder() end,
        desc = 'Delete Workspace Folders',
        mode = 'n'
    },
    {
        '<leader>fw',
        function() require('telescope.builtin').lsp_dynamic_workspace_symbols() end,
        desc = 'Find Workspace Symbols',
        mode = 'n'
    },
    {
        '<leader>fd',
        function() require('telescope.builtin').lsp_document_symbols({ show_line = true }) end,
        desc = 'Find Document Symbols',
        mode = 'n'
    },
    {
        '<leader>fa',
        '<CMD> Telescope find_files follow=true no_ignore=true hidden=true <CR>',
        desc = 'Find Any',
        mode = 'n',
    },
    {
        '<leader>fb',
        '<CMD> Telescope buffers <CR>',
        desc = 'Find Buffer',
        mode = 'n',
    },
    {
        '<leader>fc',
        '<CMD> Telescope git_commits <CR>',
        desc = 'Find Git Commit',
        mode = 'n',
    },
    {
        '<leader>ff',
        '<CMD> Telescope find_files <CR>',
        desc = 'Find File',
        mode = 'n',
    },
    {
        '<leader>fg',
        '<CMD> Telescope git_files <CR>',
        desc = 'Find Git File',
        mode = 'n',
    },
    {
        '<leader>fh',
        '<CMD> Telescope help_tags <CR>',
        desc = 'Find Help',
        mode = 'n',
    },
    {
        '<leader>fm',
        '<CMD> Telescope marks <CR>',
        desc = 'Find Marks',
        mode = 'n',
    },
    {
        '<leader>fr',
        '<CMD> Telescope oldfiles <CR>',
        desc = 'Find Recent',
        mode = 'n',
    },
    {
        '<leader>fx',
        '<CMD> Telescope live_grep <CR>',
        desc = 'Find Regex',
        mode = 'n',
    },
    {
        '<leader>fs',
        '<CMD> Telescope git_status <CR>',
        desc = 'Git Status',
        mode = 'n',
    },
    {
        '<C-N>',
        '<CMD> NvimTreeToggle <CR>',
        desc = 'OpenExplorer',
        mode = { 'i', 'n' },
    },
    {
        '<C-U>',
        '<CMD> UndotreeToggle <CR>',
        desc = 'Toggle UndoTree',
        mode = { 'i', 'n' },
    },
})
