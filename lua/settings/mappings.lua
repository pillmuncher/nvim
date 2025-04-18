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

-- -- leader is space, so we can set it to Nop.
map({ 'n', 'v' }, '<Space>', '<Nop>', { desc = '' })
--
-- -- unmap gc to remove annoying :checkhealth message:
map('n', 'gc', '')
--
local comment = require('Comment')
local commentapi = require('Comment.api')
local gitsigns = require('gitsigns')
local telescope = require('telescope')
local whichkey = require('which-key')

-- which-key config:
whichkey.add({
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
        function() commentapi.toggle.linewise.current() end,
        desc = 'Toggle Comment',
        mode = { 'i', 'n' },
    },
    {
        '<C-#>',
        '<ESC><CMD>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>',
        desc = 'Toggle Comment',
        mode = 'v',
    },

    -- make Shift-Up/Down keys not behave stupid in visual mode
    {
        '<S-Up>',
        '<Up>',
        desc = '',
        mode = { 'n', 'v' },
        silent = true,
    },
    {
        '<S-Down>',
        '<Down>',
        desc = '',
        mode = { 'n', 'v' },
        silent = true,
    },

    -- Window navigation
    {
        '<C-PageUp>',
        '<CMD> bprev! <CR>',
        desc = 'Change to previous buffer',
        mode = 'n',
    },
    {
        '<C-PageDown>',
        '<CMD> bnext! <CR>',
        desc = 'Change to next buffer',
        mode = 'n',
    },
    {
        '<C-Up>',
        '<C-W>k',
        desc = 'Change to window above',
        mode = 'n',
    },
    {
        '<C-Down>',
        '<C-W>j',
        desc = 'Change to window below',
        mode = 'n',
    },
    {
        '<C-Left>',
        '<C-W>h',
        desc = 'Change to window on the left',
        mode = 'n',
    },
    {
        '<C-Right>',
        '<C-W>l',
        desc = 'Change to window on the right',
        mode = 'n',
    },

    -- Window manipulation
    {
        '<M-Up>',
        '<CMD> wincmd k <CR>:resize -2 <CR>',
        desc = 'Increase lower window size',
        mode = 'n',
    },
    {
        '<M-Down>',
        '<CMD> wincmd k <CR>:resize +2 <CR>',
        desc = 'Increase upper window size',
        mode = 'n',
    },

    -- Buffer Management
    {
        '<leader>bb',
        '<CMD> enew <CR>',
        desc = 'New Buffer',
        mode = 'n',
    },
    {
        '<leader>bc',
        '<CMD> bd <CR>',
        desc = 'Close Current Buffer',
        mode = 'n',
    },

    -- Close window if only one window exists, else close buffer
    {
        '<C-D>',
        function()
            if #vim.api.nvim_list_wins() > 1 then
                vim.api.nvim_win_close(0, true)
            else
                vim.cmd('bd')
            end
        end,
        desc = 'Close window',
        mode = { 'i', 'n', 'v', 't' },
    },

    -- Shell Terminal
    {
        '<C-T>',
        function()
            vim.cmd.split()
            vim.cmd.startinsert()
            vim.cmd.terminal()
        end,
        desc = 'New Shell',
        mode = { 'n', 'v' },
    },

    -- Python Terminal
    {
        '<C-P>',
        function()
            vim.cmd.split()
            vim.cmd.startinsert()
            vim.cmd.terminal('python3')
        end,
        desc = 'New Python Shell',
        mode = { 'n', 'v' },
    },

    -- Indenting
    {
        '<',
        '<gv',
        desc = 'Dedent line',
        mode = 'v',
        noremap = true,
    },
    {
        '>',
        '>gv',
        desc = 'Indent line',
        mode = 'v',
        noremap = true,
    },

    -- Formatting
    {
        'W',
        'gwip',
        desc = 'Wrap paragraph',
        mode = 'n',
    },
    {
        '<leader>W',
        'gw',
        desc = 'Wrap paragraph',
        mode = 'v',
    },

    -- Yanking & Pasting
    {
        'y.',
        '<CMD> %y+ <CR>',
        desc = 'Yank current buffer',
        mode = 'n',
    },
    {
        '<leader>p',
        'p:let @+=@0<CR>:let @"=@0<CR>',
        desc = 'Paste w/o replacing register',
        mode = 'x',
    },

    -- Open QuickFix window
    {
        '<leader>oq',
        '<CMD> copen <CR>',
        desc = 'Open QuickFix',
        mode = { 'n', 'v' },
    },

    -- cd to folder of current file
    {
        '<leader>wd',
        '<CMD> lcd %:p:h<CR>',
        desc = '`cd` to folder of current file',
        mode = 'n',
    },

    -- Diagnostics keymaps
    {
        '[d',
        vim.diagnostic.goto_prev,
        desc = 'Go to previous diagnostic message',
        mode = 'n',
    },
    {
        ']d',
        vim.diagnostic.goto_next,
        desc = 'Go to next diagnostic message',
        mode = 'n',
    },
    {
        '<leader>of',
        vim.diagnostic.open_float,
        desc = 'Open floating diagnostic message',
        mode = 'n',
    },
    {
        '<leader>od',
        vim.diagnostic.setloclist,
        desc = 'Open Diagnostics',
        mode = 'n',
    },

    -- Misc
    {
        '<leader>tc',
        '<CMD> set list!<CR>',
        desc = 'Toggle Listchars',
        mode = 'n',
    },
    {
        '<leader>tn',
        '<CMD> set nu! <CR>',
        desc = 'Toggle Line Numbers',
        mode = 'n',
    },
    {
        '<leader>tr',
        '<CMD> set rnu! <CR>',
        desc = 'Toggle Relative Numbers',
        mode = 'n',
    },
    {
        '<Esc>',
        '<CMD> noh <CR>',
        desc = 'Clear highlights',
        mode = 'n',
    },
    {
        '<Esc>',
        vim.api.nvim_replace_termcodes('<C-\\><C-N>', true, true, true),
        desc = 'Escape terminal mode',
        mode = 't',
        noremap = true,
    },
    {
        '<leader>hv',
        gitsigns.preview_hunk,
        desc = 'Preview hunk',
        { mode = 'n', },
    },
    {
        '<leader>hn',
        function()
            if vim.wo.diff then
                return 'hn'
            end
            vim.schedule(function() gitsigns.nav_hunk('next') end)
        end,
        expr = true,
        desc = 'Jump to Next Hunk',
        { mode = 'n', },
    },
    {
        '<leader>hN',
        function()
            if vim.wo.diff then
                return 'hN'
            end
            vim.schedule(function() gitsigns.nav_hunk('prev') end)
        end,
        expr = true,
        desc = 'Jump to Previous Hunk',
        { mode = 'n', },
    },
    {
        '<leader>td',
        gitsigns.preview_hunk_inline,
        desc = 'Toggle Deleted Lines',
        { mode = 'n', },
    },
    {
        '<leader>hr',
        gitsigns.reset_hunk,
        desc = 'Reset Hunk',
        { mode = 'n', },
    },
    {
        '<leader>sb',
        package.loaded.gitsigns.blame_line,
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
            telescope.extensions.git_worktree.git_worktrees()
        end,
        desc = 'Find Git Worktree',
    },
    {
        '<leader>cr',
        function()
            vim.lsp.buf.rename()
        end,
        desc = 'Code Rename',
        mode = 'n',
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
        function() telescope.builtin.lsp_dynamic_workspace_symbols() end,
        desc = 'Find Workspace Symbols',
        mode = 'n'
    },
    {
        '<leader>fd',
        function() telescope.builtin.lsp_document_symbols({ show_line = true }) end,
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


M = {}

-- LSP mappings for on_attach
function M.setup_lsp(bufnr)
    local lsp_maps = {
        ["gD"]         = { "<CMD> lua vim.lsp.buf.declaration()<CR>", "Go to Declaration" },
        ["<leader>gd"] = { "<CMD> lua vim.lsp.buf.definition()<CR>", "Go to Definition" },
        ["K"]          = { "<CMD> lua vim.lsp.buf.hover()<CR>", "Hover" },
        ["gi"]         = { "<CMD> lua vim.lsp.buf.implementation()<CR>", "Go to Implementation" },
        ["<C-k>"]      = { "<CMD> lua vim.lsp.buf.signature_help()<CR>", "Signature Help" },
        ["<space>wa"]  = { "<CMD> lua vim.lsp.buf.add_workspace_folder()<CR>", "Add Workspace Folder" },
        ["<space>wr"]  = { "<CMD> lua vim.lsp.buf.remove_workspace_folder()<CR>", "Remove Workspace Folder" },
        ["<space>wl"]  = { "<CMD> lua vim.lsp.buf.list_workspace_folders()<CR>", "List Workspace Folders" },
        ["<space>D"]   = { "<CMD> lua vim.lsp.buf.type_definition()<CR>", "Type Definition" },
        ["<space>rn"]  = { "<CMD> lua vim.lsp.buf.rename()<CR>", "Rename" },
        ["<space>ca"]  = { "<CMD> lua vim.lsp.buf.code_action()<CR>", "Code Action" },
        ["gr"]         = { "<CMD> lua vim.lsp.buf.references()<CR>", "Go to References" },
        ["<space>e"]   = { "<CMD> lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", "Show Diagnostics" },
        ["[d"]         = { "<CMD> lua vim.lsp.diagnostic.goto_prev()<CR>", "Previous Diagnostic" },
        ["]d"]         = { "<CMD> lua vim.lsp.diagnostic.goto_next()<CR>", "Next Diagnostic" },
        ["<space>q"]   = { "<CMD> lua vim.lsp.diagnostic.set_loclist()<CR>", "Set Location List" },
        ["<space>f"]   = { "<CMD> lua vim.lsp.buf.format({ async = true })<CR>", "Format Buffer" },
    }

    -- Set the key mappings
    for key, value in pairs(lsp_maps) do
        local opts = {
            noremap = true,
            silent = true,
            desc = value[2],
        }
        -- Pass the Lua command as a string
        vim.api.nvim_buf_set_keymap(bufnr, 'n', key, value[1], opts)
    end
end

return M
