-- lua/settings/mappings.lua
local cmd = vim.cmd

-- ============================================================================
-- Command Abbreviations (fix common typos)
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
-- Plugin APIs
-- ============================================================================
local gitsigns = require("gitsigns")
local telescope = require("telescope")
local whichkey = require("which-key")

-- ============================================================================
-- Which-Key
-- ============================================================================
whichkey.add({

    -- Group labels
    { "<leader>b", group = "Buffer" },
    { "<leader>c", group = "Code" },
    { "<leader>d", group = "Diagnostics" },
    { "<leader>f", group = "Find" },
    { "<leader>g", group = "Git/GoTo" },
    { "<leader>n", group = "New" },
    { "<leader>o", group = "Open" },
    { "<leader>r", group = "Refactor" },
    { "<leader>s", group = "Symbols/Show" },
    { "<leader>t", group = "Toggle" },
    { "<leader>w", group = "Workspace" },

    -- ========================================================================
    -- Visual mode
    -- ========================================================================
    { ">", ">gv", desc = "Indent and keep selection", mode = "v" },
    { "<", "<gv", desc = "Dedent and keep selection", mode = "v" },
    { "<S-Down>", "<Down>", desc = "", mode = { "n", "v" }, silent = true },
    { "<S-Up>", "<Up>", desc = "", mode = { "n", "v" }, silent = true },

    -- ========================================================================
    -- Basic operations
    -- ========================================================================
    { "<Esc>", "<CMD>noh<CR>", desc = "Clear search highlights", mode = "n" },
    { "y.", "<CMD>%y+<CR>", desc = "Yank entire buffer", mode = "n" },
    { "<leader>p", 'p:let @+=@0<CR>:let @"=@0<CR>', desc = "Paste without replacing register", mode = "v" },

    -- ========================================================================
    -- Text formatting
    -- ========================================================================
    { "<leader>W", "gwip", desc = "Wrap paragraph", mode = "n" },
    { "<leader>W", "gw", desc = "Wrap selection", mode = "v" },

    -- ========================================================================
    -- Commenting (Ctrl+/)
    -- ========================================================================
    {
        "<C-#>",
        "gcc",
        desc = "Toggle comment",
        mode = { "i", "n" },
        remap = true,
    },
    {
        "<C-#>",
        "gc",
        desc = "Toggle comment",
        mode = "v",
        remap = true,
    },

    -- ========================================================================
    -- Window navigation (Ctrl+Arrow)
    -- ========================================================================
    { "<C-Left>", "<C-W>h", desc = "Window left", mode = "n" },
    { "<C-Down>", "<C-W>j", desc = "Window below", mode = "n" },
    { "<C-Up>", "<C-W>k", desc = "Window above", mode = "n" },
    { "<C-Right>", "<C-W>l", desc = "Window right", mode = "n" },

    -- Window resizing (Alt+Arrow) — normal mode only, no cmp conflict
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

    -- ========================================================================
    -- Buffer navigation
    -- ========================================================================
    { "<C-PageDown>", "<CMD>bnext!<CR>", desc = "Next buffer", mode = "n" },
    { "<C-PageUp>", "<CMD>bprev!<CR>", desc = "Previous buffer", mode = "n" },

    -- ========================================================================
    -- Buffer operations
    -- ========================================================================
    { "<leader>bd", "<CMD>bd<CR>", desc = "Delete buffer", mode = "n" },
    { "<leader>bn", "<CMD>enew<CR>", desc = "New buffer", mode = "n" },

    -- ========================================================================
    -- Terminal — startinsert AFTER terminal opens
    -- ========================================================================
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
    {
        "<Esc>",
        vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, true, true),
        desc = "Exit terminal mode",
        mode = "t",
    },

    -- ========================================================================
    -- TUI applications
    -- ========================================================================
    { "<C-n>", "<CMD>NvimTreeToggle<CR>", desc = "Toggle file explorer", mode = { "i", "n" } },
    { "<C-u>", "<CMD>UndotreeToggle<CR>", desc = "Toggle undo tree", mode = { "i", "n" } },
    { "<C-g>", "<CMD>LazyGit<CR>", desc = "Toggle LazyGit", mode = "n" },
    { "<C-l>", "<CMD>AerialToggle!<CR>", desc = "Toggle code outline", mode = "n" },
    { "<C-j>", "<CMD>Telescope jumplist<CR>", desc = "Open jumplist", mode = "n" },
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
        mode = "n", -- not insert, so no cmp conflict
    },
    -- Close window/buffer intelligently
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
    -- ========================================================================
    -- Which-Key search
    -- ========================================================================
    {
        "<leader><leader>",
        function()
            cmd("WhichKey " .. vim.fn.input("WhichKey: "))
        end,
        desc = "Search WhichKey",
        mode = "n",
    },

    -- ========================================================================
    -- Find (Telescope)
    -- ========================================================================
    { "<leader>f?", "<CMD>Telescope help_tags<CR>", desc = "Find help" },
    {
        "<leader>fa",
        "<CMD>Telescope find_files follow=true no_ignore=true hidden=true<CR>",
        desc = "Find any file (hidden too)",
    },
    { "<leader>fb", "<CMD>Telescope buffers<CR>", desc = "Find buffer" },
    { "<leader>fc", "<CMD>Telescope git_commits<CR>", desc = "Find git commit" },
    {
        "<leader>fd",
        function()
            require("telescope.builtin").lsp_document_symbols({ show_line = true })
        end,
        desc = "Find document symbols",
    },
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
    {
        "<leader>fw",
        function()
            require("telescope.builtin").lsp_dynamic_workspace_symbols()
        end,
        desc = "Find workspace symbols",
    },
    { "<leader>fx", "<CMD>Telescope live_grep<CR>", desc = "Find text (live grep)" },

    -- ========================================================================
    -- Git / GoTo
    -- ========================================================================
    { "<leader>g.", "<CMD>lcd %:p:h<CR>", desc = "cd to current file's dir" },
    { "<leader>gb", gitsigns.blame_line, desc = "Git blame line" },
    { "<leader>gh", gitsigns.preview_hunk, desc = "Git hunk diff" },
    { "<leader>gd", gitsigns.preview_hunk_inline, desc = "Git hunk inline (deleted)" },
    { "<leader>gu", gitsigns.reset_hunk, desc = "Undo (reset) git hunk" },
    {
        "<leader>gn",
        function()
            if not vim.wo.diff then
                vim.schedule(function()
                    gitsigns.nav_hunk("next")
                end)
            end
        end,
        desc = "Next git hunk",
    },
    {
        "<leader>gN",
        function()
            if not vim.wo.diff then
                vim.schedule(function()
                    gitsigns.nav_hunk("prev")
                end)
            end
        end,
        desc = "Prev git hunk",
    },

    -- ========================================================================
    -- Diagnostics
    -- ========================================================================
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

    -- ========================================================================
    -- Open
    -- ========================================================================
    { "<leader>oq", "<CMD>copen<CR>", desc = "Open quickfix", mode = { "n", "v" } },

    -- ========================================================================
    -- Toggle
    -- ========================================================================
    { "<leader>tc", "<CMD>set list!<CR>", desc = "Toggle listchars" },
    { "<leader>tn", "<CMD>set nu!<CR>", desc = "Toggle line numbers" },
    { "<leader>tr", "<CMD>set rnu!<CR>", desc = "Toggle relative numbers" },
    { "<leader>ti", "<CMD>IBLToggle<CR>", desc = "Toggle indent lines" },
    { "<leader>ts", "<CMD>IBLToggleScope<CR>", desc = "Toggle scope lines" },

    -- ========================================================================
    -- Refactor
    -- ========================================================================
    {
        "<leader>rn",
        function()
            return ":IncRename " .. vim.fn.expand("<cword>")
        end,
        desc = "Rename symbol",
        mode = "n",
        expr = true,
    },
    -- ========================================================================
    -- Test (Neotest)
    -- ========================================================================
    { "<leader>T", group = "Test" },
    {
        "<leader>Tr",
        function()
            require("neotest").run.run()
        end,
        desc = "Run nearest test",
    },
    {
        "<leader>TT",
        function()
            require("neotest").run.run(vim.fn.expand("%"))
        end,
        desc = "Run current file",
    },
    {
        "<leader>Ts",
        function()
            require("neotest").run.stop()
        end,
        desc = "Stop test",
    },
    {
        "<leader>Ta",
        function()
            require("neotest").run.attach()
        end,
        desc = "Attach to test",
    },
    {
        "<leader>To",
        function()
            require("neotest").output.open({ enter = true })
        end,
        desc = "Open output",
    },
    {
        "<leader>TO",
        function()
            require("neotest").output_panel.toggle()
        end,
        desc = "Toggle output panel",
    },
    {
        "<leader>Tm",
        function()
            require("neotest").summary.toggle()
        end,
        desc = "Toggle summary",
    },
})

-- ============================================================================
-- LSP buffer-local mappings
-- ============================================================================
local M = {}

function M.setup_lsp(bufnr)
    local lsp = function(keys, func, desc)
        vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc, noremap = true, silent = true })
    end

    -- Navigation (unprefixed — standard vim-lsp convention)
    lsp("gd", vim.lsp.buf.definition, "definition")
    lsp("gD", vim.lsp.buf.declaration, "declaration")
    lsp("gi", vim.lsp.buf.implementation, "implementation")
    lsp("gr", vim.lsp.buf.references, "references")
    lsp("K", vim.lsp.buf.hover, "Hover docs")
    lsp("<C-k>", vim.lsp.buf.signature_help, "Signature help")

    -- <leader>g group (Git/GoTo)
    lsp("<leader>gt", vim.lsp.buf.type_definition, "type definition")

    -- <leader>c group (Code)
    lsp("<leader>ca", vim.lsp.buf.code_action, "Code actions")

    -- Visual mode
    vim.keymap.set("v", "<leader>ca", function()
        local start = vim.fn.getpos("v")
        local end_ = vim.fn.getpos(".")
        vim.lsp.buf.code_action({
            range = {
                start = { start[2] - 1, math.max(0, start[3] - 1) },
                ["end"] = { end_[2] - 1, end_[3] },
            },
        })
    end, { buffer = bufnr, desc = "Code actions (visual)", noremap = true, silent = true })
    lsp("<leader>cf", function()
        vim.lsp.buf.format({ async = true })
    end, "Format buffer")

    -- <leader>s group (Symbols/Show)
    lsp("<leader>sd", vim.lsp.buf.hover, "docs (hover)")
    lsp("<leader>ss", vim.lsp.buf.signature_help, "signature help")
    lsp("<leader>sr", vim.lsp.buf.references, "references")

    -- <leader>w group (Workspace)
    lsp("<leader>wa", vim.lsp.buf.add_workspace_folder, "add workspace folder")
    lsp("<leader>wd", vim.lsp.buf.remove_workspace_folder, "remove workspace folder")
    lsp("<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, "list workspace folders")
end

return M
