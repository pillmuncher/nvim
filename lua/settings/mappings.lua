local cmd = vim.cmd
local function native_swap(is_next)
    local node = vim.treesitter.get_node()
    while node and not (node:type():find("parameter") or node:type():find("argument")) do
        node = node:parent()
    end

    if node then
        local target = is_next and node:next_sibling() or node:prev_sibling()
        -- Skip commas in the AST
        if target and target:type() == "," then
            target = is_next and target:next_sibling() or target:prev_sibling()
        end

        if target then
            -- NATIVE REPLACEMENT FOR ts_utils.swap_nodes
            local bufnr = vim.api.nvim_get_current_buf()
            local r1, c1, r2, c2 = node:range()
            local tr1, tc1, tr2, tc2 = target:range()

            local text1 = vim.api.nvim_buf_get_text(bufnr, r1, c1, r2, c2, {})
            local text2 = vim.api.nvim_buf_get_text(bufnr, tr1, tc1, tr2, tc2, {})

            -- Swap the text in the buffer (Order matters to avoid range shifts)
            if is_next then
                vim.api.nvim_buf_set_text(bufnr, tr1, tc1, tr2, tc2, text1)
                vim.api.nvim_buf_set_text(bufnr, r1, c1, r2, c2, text2)
            else
                vim.api.nvim_buf_set_text(bufnr, r1, c1, r2, c2, text2)
                vim.api.nvim_buf_set_text(bufnr, tr1, tc1, tr2, tc2, text1)
            end

            -- Move cursor to follow the swap
            vim.api.nvim_win_set_cursor(0, { tr1 + 1, tc1 })
        end
    end
end
-- Native Selection (Uses core Neovim 0.12.0 range logic)
local function ts_select(capture, v_mode)
    return function()
        local bufnr = vim.api.nvim_get_current_buf()
        local lang = vim.bo.filetype
        local node = vim.treesitter.get_node()
        if not node then
            return
        end

        -- Hard-coded Lua Fallback for 'vif' / 'vaf'
        -- This is a "brute force" fix because the Lua queries are currently broken in 0.12.0
        if lang == "lua" and capture:find("function") then
            local current = node
            while current and current:type() ~= "function_definition" do
                current = current:parent() --[[@as TSNode]]
            end
            if current then
                local s_r, s_c, e_r, e_c = current:range()
                if capture == "@function.inner" then
                    -- Select everything between 'function(...)' and 'end'
                    vim.api.nvim_win_set_cursor(0, { s_r + 2, 0 }) -- Start on line after 'function'
                    vim.cmd("normal! V")
                    vim.api.nvim_win_set_cursor(0, { e_r, 0 }) -- End on line before 'end'
                else
                    -- Select the whole function
                    vim.api.nvim_win_set_cursor(0, { s_r + 1, s_c })
                    vim.cmd("normal! V")
                    vim.api.nvim_win_set_cursor(0, { e_r + 1, e_c })
                end
                return
            end
        end

        -- Standard Logic for Python and other languages
        local query = vim.treesitter.query.get(lang, "textobjects")
        if not query then
            return
        end

        local root = node:tree():root()
        local cursor_row = vim.api.nvim_win_get_cursor(0)[1] - 1
        local start_row, start_col, end_row, end_col

        for id, match_node in query:iter_captures(root, bufnr, 0, -1) do
            if query.captures[id] == capture:gsub("^@", "") then
                local s_r, s_c, e_r, e_c = match_node:range()
                if cursor_row >= s_r and cursor_row <= e_r then
                    if not start_row or (s_r >= start_row and e_r <= end_row) then
                        start_row, start_col, end_row, end_col = s_r, s_c, e_r, e_c
                    end
                end
            end
        end

        if start_row then
            local mode = vim.api.nvim_get_mode().mode
            if mode:sub(1, 1):lower() == "v" or mode:sub(1, 1) == "\22" then
                vim.cmd("normal! " .. mode:sub(1, 1))
            end
            vim.api.nvim_win_set_cursor(0, { start_row + 1, start_col })
            vim.cmd("normal! " .. (v_mode or "v"))
            vim.api.nvim_win_set_cursor(0, { end_row + 1, math.max(0, end_col - 1) })
        end
    end
end

-- ============================================================================
-- Telescope: silence missing position_encoding warning (Neovim 0.11+ / Telescope bug)
-- ============================================================================
local orig_make_position_params = vim.lsp.util.make_position_params
---@diagnostic disable-next-line: duplicate-set-field
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
require("which-key").add({
    { "<leader>b", group = "Buffer" },
    { "<leader>c", group = "Code" },
    { "<leader>d", group = "Debug" },
    { "<leader>f", group = "Find" },
    { "<leader>g", group = "GoTo" },
    { "<leader>o", group = "Open" },
    { "<leader>s", group = "Symbols" },
    { "<leader>t", group = "Toggle" },
    { "<leader>w", group = "Workspace" },
    { "<leader>D", group = "Diagnostics" },
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
    { "<C-.>", "gc", desc = "Toggle comment", mode = "v", remap = true },
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
    {
        "<leader>Dd",
        function()
            vim.diagnostic.open_float()
        end,
        desc = "Diagnostic float",
    },
    { "<leader>Dl", vim.diagnostic.setloclist, desc = "Diagnostic loclist" },
    {
        "<leader>cs",
        function()
            native_swap(true)
        end,
        desc = "Swap with next parameter",
        mode = "n",
    },
    {
        "<leader>cS",
        function()
            native_swap(false)
        end,
        desc = "Swap with previous parameter",
        mode = "n",
    },
    -- ============================================================================
    -- Treesitter Native Logic (0.12.0 core API)
    -- ============================================================================
    { "af", ts_select("@function.outer", "V"), desc = "Function (outer)", mode = { "x", "o" } },
    { "if", ts_select("@function.inner", "V"), desc = "Function (inner)", mode = { "x", "o" } },
    { "ac", ts_select("@class.outer", "v"), desc = "Class (outer)", mode = { "x", "o" } },
    { "ic", ts_select("@class.inner", "v"), desc = "Class (inner)", mode = { "x", "o" } },
    { "aa", ts_select("@parameter.outer", "v"), desc = "Parameter (outer)", mode = { "x", "o" } },
    { "ia", ts_select("@parameter.inner", "v"), desc = "Parameter (inner)", mode = { "x", "o" } },
    -- ============================================================================
    -- Find (Telescope)
    -- ============================================================================
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
            require("telescope").extensions.git_worktree.git_worktrees()
        end,
        desc = "Find git worktree",
    },
    { "<leader>fx", "<CMD>Telescope live_grep<CR>", desc = "Live grep" },
    { "<leader>fz", "<CMD>Telescope spell_suggest<CR>", desc = "Spell suggest" },

    -- ============================================================================
    -- GoTo
    -- ============================================================================
    { "<leader>g.", "<CMD>lcd %:p:h<CR>", desc = "cd to current file's dir" },
    {
        "[[",
        function()
            require("aerial").prev()
        end,
        desc = "Previous symbol",
    },
    {
        "]]",
        function()
            require("aerial").next()
        end,
        desc = "Next symbol",
    },

    -- ============================================================================
    -- Open
    -- ============================================================================
    { "<leader>oq", "<CMD>copen<CR>", desc = "Open quickfix", mode = { "n", "v" } },
    { "<leader>os", "<CMD>Obsession<CR>", desc = "Toggle session tracking" },

    -- ============================================================================
    -- Toggle
    -- ============================================================================
    { "<leader>tc", "<CMD>set list!<CR>", desc = "Toggle listchars" },
    { "<leader>ti", "<CMD>IBLToggle<CR>", desc = "Toggle indent lines" },
    { "<leader>tn", "<CMD>set nu!<CR>", desc = "Toggle line numbers" },
    { "<leader>tr", "<CMD>set rnu!<CR>", desc = "Toggle relative numbers" },
    { "<leader>ts", "<CMD>IBLToggleScope<CR>", desc = "Toggle scope lines" },

    -- ============================================================================
    -- Git
    -- ============================================================================
    {
        "<leader>GB",
        function()
            require("gitsigns").stage_buffer()
        end,
        desc = "Stage buffer",
    },
    {
        "<leader>GI",
        function()
            require("gitsigns").preview_hunk_inline()
        end,
        desc = "Hunk inline",
    },
    {
        "<leader>GN",
        function()
            if not vim.wo.diff then
                vim.schedule(function()
                    require("gitsigns").nav_hunk("prev")
                end)
            end
        end,
        desc = "Prev hunk",
    },
    {
        "<leader>Gb",
        function()
            require("gitsigns").blame_line()
        end,
        desc = "Blame line",
    },
    {
        "<leader>Gh",
        function()
            require("gitsigns").preview_hunk()
        end,
        desc = "Hunk diff",
    },
    {
        "<leader>Gn",
        function()
            if not vim.wo.diff then
                vim.schedule(function()
                    require("gitsigns").nav_hunk("next")
                end)
            end
        end,
        desc = "Next hunk",
    },
    {
        "<leader>Gs",
        function()
            require("gitsigns").stage_hunk()
        end,
        desc = "Stage hunk",
    },
    {
        "<leader>Gt",
        function()
            require("gitsigns").toggle_current_line_blame()
        end,
        desc = "Toggle blame",
    },
    {
        "<leader>Gu",
        function()
            require("gitsigns").reset_hunk()
        end,
        desc = "Reset hunk",
    },

    -- ============================================================================
    -- Test (Neotest)
    -- ============================================================================
    {
        "<leader>TA",
        function()
            local state = require("test_state")
            state.running = true
            state.passed = 0
            state.failed = 0
            local timer = vim.uv.new_timer()
            assert(timer, "Failed to create timer")
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
                require("neotest").run.run(vim.fn.getcwd())
            end, 300)
        end,
        desc = "Run all tests",
    },
    {
        "<leader>TC",
        function()
            require("coverage").toggle()
        end,
        desc = "Toggle coverage",
    },
    {
        "<leader>TF",
        function()
            require("neotest").jump.prev({ status = "failed" })
        end,
        desc = "Previous failed test",
    },
    {
        "<leader>TL",
        function()
            require("coverage").load(true)
        end,
        desc = "Load coverage",
    },
    {
        "<leader>TS",
        function()
            require("coverage").summary()
        end,
        desc = "Coverage summary",
    },
    {
        "<leader>TT",
        function()
            require("neotest").run.run(vim.fn.expand("%"))
        end,
        desc = "Run current file",
    },
    {
        "<leader>Ta",
        function()
            require("neotest").run.attach()
        end,
        desc = "Attach to test",
    },
    {
        "<leader>Tf",
        function()
            require("neotest").jump.next({ status = "failed" })
        end,
        desc = "Next failed test",
    },
    {
        "<leader>Tm",
        function()
            require("neotest").summary.toggle()
        end,
        desc = "Toggle test summary",
    },
    {
        "<leader>To",
        function()
            require("neotest").output.open()
        end,
        desc = "Test output",
    },
    {
        "<leader>Tp",
        function()
            require("neotest").output_panel.toggle()
        end,
        desc = "Toggle output panel",
    },
    {
        "<leader>Tr",
        function()
            require("neotest").run.run()
        end,
        desc = "Run nearest test",
    },
    {
        "<leader>Ts",
        function()
            require("neotest").run.stop()
        end,
        desc = "Stop test",
    },
    { "<leader>W", "gwip", desc = "Wrap paragraph", mode = "n" },
    { "<leader>W", "gw", desc = "Wrap selection", mode = "v" },

    {
        "<F5>",
        function()
            require("dap").continue()
        end,
        desc = "Debug: Continue / Start",
        mode = "n",
    },
    {
        "<F10>",
        function()
            require("dap").step_over()
        end,
        desc = "Debug: Step Over",
        mode = "n",
    },
    {
        "<F11>",
        function()
            require("dap").step_into()
        end,
        desc = "Debug: Step Into",
        mode = "n",
    },
    {
        "<F12>",
        function()
            require("dap").step_out()
        end,
        desc = "Debug: Step Out",
        mode = "n",
    },
    {
        "<Leader>Db",
        function()
            require("dap").toggle_breakpoint()
        end,
        desc = "Debug: Toggle Breakpoint",
        mode = "n",
    },
    {
        "<Leader>DB",
        function()
            require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end,
        desc = "Debug: Conditional Breakpoint",
        mode = "n",
    },
})

-- ============================================================================
-- LSP buffer-local mappings
-- ============================================================================
local M = {}

function M.setup_lsp(bufnr)
    require("which-key").add({
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
                ---@diagnostic disable-next-line: redundant-return-value
                return ":IncRename " .. vim.fn.expand("<cword>")
            end,
            desc = "Rename symbol",
            buffer = bufnr,
            expr = true,
        },
        {
            "<leader>fd",
            function()
                require("telescope.builtin").lsp_document_symbols({ show_line = true })
            end,
            desc = "Find document symbols",
            buffer = bufnr,
        },
        { "<leader>gt", vim.lsp.buf.type_definition, desc = "Type definition", buffer = bufnr },
        {
            "<leader>sd",
            function()
                require("telescope.builtin").lsp_document_symbols({ show_line = true })
            end,
            desc = "Document symbols",
            buffer = bufnr,
        },
        {
            "<leader>sw",
            function()
                require("telescope.builtin").lsp_dynamic_workspace_symbols()
            end,
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
