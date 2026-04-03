-- lua/settings/mappings.lua
local cmd = vim.cmd
local gitsigns = require("gitsigns")
local telescope = require("telescope")
local whichkey = require("which-key")
local neotest = require("neotest")
local coverage = require("coverage")
local aerial = require("aerial")

-- ============================================================================
-- Telescope: silence missing position_encoding warning (Neovim 0.11+ / Telescope bug)
-- ============================================================================
local orig_make_position_params = vim.lsp.util.make_position_params
vim.lsp.util.make_position_params = function(window, encoding)
    window = window or vim.api.nvim_get_current_win()
    if not encoding then
        local bufnr = vim.api.nvim_win_get_buf(window)
        local clients = vim.lsp.get_clients({ bufnr = bufnr })
        encoding = (clients[1] and clients[1].offset_encoding) or "utf-16"
    end
    return orig_make_position_params(window, encoding)
end

-- ============================================================================
-- Command Abbreviations
-- ============================================================================
local abbrevs = {
    q = { "Q" },
    qa = { "QA", "Qa", "qA" },
    w = { "W" },
    wa = { "WA", "Wa", "wA" },
    wq = { "WQ", "Wq", "wQ" },
    wqa = { "WQA", "WQa", "WqA", "Wqa", "wQA", "wQa", "wqA" },
}
for correct, typos in pairs(abbrevs) do
    for _, typo in ipairs(typos) do
        cmd.cnoreabbrev(typo, correct)
    end
end

-- ============================================================================
-- Which-Key Groups
-- ============================================================================
whichkey.add({
    { "<leader>b", group = "Buffer" },
    { "<leader>c", group = "Code" },
    { "<leader>d", group = "Diagnostics" },
    { "<leader>f", group = "Find" },
    { "<leader>g", group = "GoTo" },
    { "<leader>o", group = "Open" },
    { "<leader>s", group = "Symbols" },
    { "<leader>t", group = "Toggle" },
    { "<leader>w", group = "Workspace" },
    { "<leader>G", group = "Git" },
    { "<leader>S", group = "Show" },
    { "<leader>T", group = "Test" },

    -- ============================================================================
    -- WhichKey search
    -- ============================================================================
    {
        "<leader><leader>",
        function()
            cmd("WhichKey " .. vim.fn.input("WhichKey: "))
        end,
        desc = "Search WhichKey",
        mode = "n",
    },
    --
    -- ============================================================================
    -- Visual / basic operations
    -- ============================================================================
    { "<Esc>", "<CMD>noh<CR>", desc = "Clear search highlights", mode = "n" },
    {
        "<Esc>",
        vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, true, true),
        desc = "Exit terminal mode",
        mode = "t",
    },
    { "y.", "<CMD>%y+<CR>", desc = "Yank entire buffer", mode = "n" },
    { "<C-#>", "gc", desc = "Toggle comment", mode = "v", remap = true },
    { "<C-#>", "gcc", desc = "Toggle comment", mode = { "i", "n" }, remap = true },
    { "<S-Down>", "<Down>", mode = { "n", "v" }, silent = true },
    { "<S-Up>", "<Up>", mode = { "n", "v" }, silent = true },
    {
        "<leader>p",
        'p:let @+=@0<CR>:let @"=@0<CR>',
        desc = "Paste without replacing register",
        mode = "v",
    },
    { "<", "<gv", desc = "Dedent and keep selection", mode = "v" },
    { ">", ">gv", desc = "Indent and keep selection", mode = "v" },

    -- ============================================================================
    -- Window / buffer / terminal / TUI
    -- ============================================================================
    {
        "<M-Down>",
        function()
            local w = vim.fn.winnr()
            vim.cmd("wincmd k | resize +2")
            vim.cmd(w .. "wincmd w")
        end,
        desc = "Divider down",
        mode = "n",
    },
    {
        "<M-Up>",
        function()
            local w = vim.fn.winnr()
            vim.cmd("wincmd k | resize -2")
            vim.cmd(w .. "wincmd w")
        end,
        desc = "Divider up",
        mode = "n",
    },
    { "<C-Left>", "<C-W>h", desc = "Window left", mode = "n" },
    { "<C-Right>", "<C-W>l", desc = "Window right", mode = "n" },
    { "<C-Up>", "<C-W>k", desc = "Window above", mode = "n" },
    { "<C-Down>", "<C-W>j", desc = "Window below", mode = "n" },
    { "<C-PageUp>", "<CMD>bprev!<CR>", desc = "Previous buffer", mode = "n" },
    { "<C-PageDown>", "<CMD>bnext!<CR>", desc = "Next buffer", mode = "n" },
    {
        "<C-d>",
        function()
            local wins = vim.tbl_filter(function(w)
                return vim.api.nvim_win_get_config(w).relative == ""
            end, vim.api.nvim_list_wins())
            if #wins > 1 then
                vim.api.nvim_win_close(0, true)
            else
                vim.cmd("bd")
            end
        end,
        desc = "Close window or buffer",
        mode = { "n", "v", "t" },
    },
    { "<C-g>", "<CMD>LazyGit<CR>", desc = "Toggle LazyGit", mode = "n" },
    { "<C-j>", "<CMD>Telescope jumplist<CR>", desc = "Open jumplist", mode = "n" },
    { "<C-l>", "<CMD>AerialToggle!<CR>", desc = "Toggle code outline", mode = "n" },
    { "<C-n>", "<CMD>NvimTreeToggle<CR>", desc = "Toggle file explorer", mode = { "i", "n" } },
    {
        "<C-o>",
        function()
            vim.diagnostic.setloclist({ open = true })
            cmd("lopen")
        end,
        desc = "Open diagnostics in loclist",
    },
    {
        "<C-p>",
        function()
            cmd.split()
            cmd.terminal("python3")
            vim.cmd("startinsert")
        end,
        desc = "Open Python REPL",
        mode = "n",
    },
    {
        "<C-t>",
        function()
            cmd.split()
            cmd.terminal()
            vim.cmd("startinsert")
        end,
        desc = "New terminal (shell)",
        mode = { "n", "v" },
    },
    { "<C-u>", "<CMD>UndotreeToggle<CR>", desc = "Toggle undo tree", mode = { "i", "n" } },
    -- ============================================================================
    -- Buffer
    -- ============================================================================
    { "<leader>bd", "<CMD>bd<CR>", desc = "Delete buffer", mode = "n" },
    { "<leader>bn", "<CMD>enew<CR>", desc = "New buffer", mode = "n" },

    -- ============================================================================
    -- Diagnostics
    -- ============================================================================
    {
        "[d",
        function()
            vim.diagnostic.jump({ count = -1, float = true })
        end,
        desc = "Previous diagnostic",
    },
    {
        "]d",
        function()
            vim.diagnostic.jump({ count = 1, float = true })
        end,
        desc = "Next diagnostic",
    },
    { "<leader>dd", vim.diagnostic.open_float, desc = "Diagnostic float" },
    { "<leader>dl", vim.diagnostic.setloclist, desc = "Diagnostic loclist" },
})

-- ============================================================================
-- Find (Telescope)
-- ============================================================================
whichkey.add({
    { "<leader>f/", "<CMD>Telescope command_history<CR>", desc = "Command history" },
    { "<leader>f?", "<CMD>Telescope help_tags<CR>", desc = "Find help" },
    { "<leader>fD", "<CMD>Telescope diagnostics<CR>", desc = "Find diagnostics" },
    {
        "<leader>fa",
        "<CMD>Telescope find_files follow=true no_ignore=true hidden=true<CR>",
        desc = "Find any file",
    },
    { "<leader>fb", "<CMD>Telescope buffers<CR>", desc = "Find buffer" },
    { "<leader>fc", "<CMD>Telescope git_commits<CR>", desc = "Find git commit" },
    { "<leader>ff", "<CMD>Telescope find_files<CR>", desc = "Find file" },
    { "<leader>fg", "<CMD>Telescope git_files<CR>", desc = "Find git-tracked file" },
    { "<leader>fm", "<CMD>Telescope marks<CR>", desc = "Find marks" },
    { "<leader>fr", "<CMD>Telescope oldfiles<CR>", desc = "Find recent files" },
    { "<leader>fs", "<CMD>Telescope git_status<CR>", desc = "Find git status files" },
    {
        "<leader>ft",
        function()
            telescope.extensions.git_worktree.git_worktrees()
        end,
        desc = "Find git worktree",
    },
    { "<leader>fx", "<CMD>Telescope live_grep<CR>", desc = "Live grep" },
    { "<leader>fz", "<CMD>Telescope spell_suggest<CR>", desc = "Spell suggest" },
})

-- ============================================================================
-- GoTo
-- ============================================================================
whichkey.add({
    { "<leader>g.", "<CMD>lcd %:p:h<CR>", desc = "cd to current file's dir" },
    { "[[", aerial.prev, desc = "Previous symbol" },
    { "]]", aerial.next, desc = "Next symbol" },
})

-- ============================================================================
-- Open
-- ============================================================================
whichkey.add({
    { "<leader>oq", "<CMD>copen<CR>", desc = "Open quickfix", mode = { "n", "v" } },
    { "<leader>os", "<CMD>Obsession<CR>", desc = "Toggle session tracking" },
})

-- ============================================================================
-- Toggle
-- ============================================================================
whichkey.add({
    { "<leader>tc", "<CMD>set list!<CR>", desc = "Toggle listchars" },
    { "<leader>ti", "<CMD>IBLToggle<CR>", desc = "Toggle indent lines" },
    { "<leader>tn", "<CMD>set nu!<CR>", desc = "Toggle line numbers" },
    { "<leader>tr", "<CMD>set rnu!<CR>", desc = "Toggle relative numbers" },
    { "<leader>ts", "<CMD>IBLToggleScope<CR>", desc = "Toggle scope lines" },
})

-- ============================================================================
-- Git
-- ============================================================================
whichkey.add({
    { "<leader>GB", gitsigns.stage_buffer, desc = "Stage buffer" },
    { "<leader>GI", gitsigns.preview_hunk_inline, desc = "Hunk inline" },
    {
        "<leader>GN",
        function()
            if not vim.wo.diff then
                vim.schedule(function()
                    gitsigns.nav_hunk("prev")
                end)
            end
        end,
        desc = "Prev hunk",
    },
    { "<leader>Gb", gitsigns.blame_line, desc = "Blame line" },
    { "<leader>Gh", gitsigns.preview_hunk, desc = "Hunk diff" },
    {
        "<leader>Gn",
        function()
            if not vim.wo.diff then
                vim.schedule(function()
                    gitsigns.nav_hunk("next")
                end)
            end
        end,
        desc = "Next hunk",
    },
    { "<leader>Gs", gitsigns.stage_hunk, desc = "Stage hunk" },
    { "<leader>Gt", gitsigns.toggle_current_line_blame, desc = "Toggle blame" },
    { "<leader>Gu", gitsigns.reset_hunk, desc = "Reset hunk" },
})

-- ============================================================================
-- Show
-- ============================================================================
whichkey.add({
    { "<leader>Sd", vim.diagnostic.open_float, desc = "Diagnostics float" },
})

-- ============================================================================
-- Test (Neotest)
-- ============================================================================
whichkey.add({
    {
        "<leader>TA",
        function()
            local state = require("test_state")
            state.running = true
            state.passed = 0
            state.failed = 0
            local timer = vim.uv.new_timer()
            timer:start(
                0,
                500,
                vim.schedule_wrap(function()
                    if not state.running then
                        timer:stop()
                        timer:close()
                    end
                    vim.cmd("redrawstatus")
                end)
            )
            vim.defer_fn(function()
                neotest.run.run(vim.fn.getcwd())
            end, 300)
        end,
        desc = "Run all tests",
    },
    { "<leader>TC", coverage.toggle, desc = "Toggle coverage" },
    {
        "<leader>TF",
        function()
            neotest.jump.prev({ status = "failed" })
        end,
        desc = "Previous failed test",
    },
    { "<leader>TL", coverage.load, desc = "Load coverage" },
    { "<leader>TS", coverage.summary, desc = "Coverage summary" },
    {
        "<leader>TT",
        function()
            neotest.run.run(vim.fn.expand("%"))
        end,
        desc = "Run current file",
    },
    { "<leader>Ta", neotest.run.attach, desc = "Attach to test" },
    {
        "<leader>Tf",
        function()
            neotest.jump.next({ status = "failed" })
        end,
        desc = "Next failed test",
    },
    { "<leader>Tm", neotest.summary.toggle, desc = "Toggle test summary" },
    { "<leader>To", neotest.output.open, desc = "Test output" },
    { "<leader>Tp", neotest.output_panel.toggle, desc = "Toggle output panel" },
    { "<leader>Tr", neotest.run.run, desc = "Run nearest test" },
    { "<leader>Ts", neotest.run.stop, desc = "Stop test" },
})

-- ============================================================================
-- LSP buffer-local mappings
-- ============================================================================
local M = {}

function M.setup_lsp(bufnr)
    local wk = require("which-key")
    local tb = require("telescope.builtin")

    wk.add({
        { "<C-k>", vim.lsp.buf.signature_help, desc = "Signature help", buffer = bufnr },
        { "<leader>Sh", vim.lsp.buf.hover, desc = "Hover docs", buffer = bufnr },
        { "<leader>Ss", vim.lsp.buf.signature_help, desc = "Signature help", buffer = bufnr },
        {
            "<leader>ca",
            function()
                local start = vim.fn.getpos("v")
                local end_ = vim.fn.getpos(".")
                vim.lsp.buf.code_action({
                    range = {
                        start = { start[2] - 1, math.max(0, start[3] - 1) },
                        ["end"] = { end_[2] - 1, end_[3] },
                    },
                })
            end,
            desc = "Code actions (visual)",
            buffer = bufnr,
            mode = "v",
        },
        { "<leader>ca", vim.lsp.buf.code_action, desc = "Code actions", buffer = bufnr },
        {
            "<leader>cf",
            function()
                vim.lsp.buf.format({ async = true })
            end,
            desc = "Format buffer",
            buffer = bufnr,
        },
        {
            "<leader>cr",
            function()
                return ":IncRename " .. vim.fn.expand("<cword>")
            end,
            desc = "Rename symbol",
            buffer = bufnr,
            expr = true,
        },
        {
            "<leader>fd",
            function()
                tb.lsp_document_symbols({ show_line = true })
            end,
            desc = "Find document symbols",
            buffer = bufnr,
        },
        { "<leader>gt", vim.lsp.buf.type_definition, desc = "Type definition", buffer = bufnr },
        {
            "<leader>sd",
            function()
                tb.lsp_document_symbols({ show_line = true })
            end,
            desc = "Document symbols",
            buffer = bufnr,
        },
        {
            "<leader>sw",
            tb.lsp_dynamic_workspace_symbols,
            desc = "Workspace symbols",
            buffer = bufnr,
        },
        {
            "<leader>wa",
            vim.lsp.buf.add_workspace_folder,
            desc = "Add workspace folder",
            buffer = bufnr,
        },
        {
            "<leader>wd",
            vim.lsp.buf.remove_workspace_folder,
            desc = "Remove workspace folder",
            buffer = bufnr,
        },
        {
            "<leader>wl",
            function()
                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end,
            desc = "List workspace folders",
            buffer = bufnr,
        },
        { "K", vim.lsp.buf.hover, desc = "Hover docs", buffer = bufnr },
        { "gD", vim.lsp.buf.declaration, desc = "Declaration", buffer = bufnr },
        { "gd", vim.lsp.buf.definition, desc = "Definition", buffer = bufnr },
        { "gi", vim.lsp.buf.implementation, desc = "Implementation", buffer = bufnr },
        { "gr", vim.lsp.buf.references, desc = "References", buffer = bufnr },
    }, { buffer = bufnr })
end

return M
