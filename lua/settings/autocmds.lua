local api = vim.api

-- ============================================================================
-- Augroups
-- ============================================================================
local yank_highlight = api.nvim_create_augroup("YankHighlight", { clear = true })
local text_soft_wrap = api.nvim_create_augroup("TextSoftWrap", { clear = true })
local cursor_restore = api.nvim_create_augroup("CursorRestore", { clear = true })
local project_root = api.nvim_create_augroup("ProjectRoot", { clear = true })

-- ============================================================================
-- Flash when yanking
-- ============================================================================
api.nvim_create_autocmd("TextYankPost", {
    group = yank_highlight,
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- ============================================================================
-- Restore cursor position when reopening a file
-- ============================================================================
api.nvim_create_autocmd("BufReadPost", {
    group = cursor_restore,
    callback = function()
        local mark = api.nvim_buf_get_mark(0, '"')
        local line_count = api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= line_count then
            pcall(api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

-- ============================================================================
-- Soft wrap for prose filetypes
-- ============================================================================
api.nvim_create_autocmd("FileType", {
    group = text_soft_wrap,
    pattern = { "markdown", "org" },
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.linebreak = true
        vim.opt_local.textwidth = 0
    end,
})

-- ============================================================================
-- Open all folds when entering a Python buffer
-- ============================================================================
api.nvim_create_autocmd("FileType", {
    pattern = "python",
    callback = function()
        -- foldlevel 99 is more reliable than zR in a FileType autocmd
        -- since treesitter folding may not be set up yet when zR runs
        vim.opt_local.foldlevel = 99
    end,
})

-- ============================================================================
-- Remove trailing whitespace on save (excludes filetypes where it matters)
-- ============================================================================
api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*" },
    callback = function()
        local ft = vim.bo.filetype
        local exclude = { make = true, markdown = true }
        if not exclude[ft] then
            vim.cmd([[%s/\s\+$//e]])
        end
    end,
})

-- ============================================================================
-- Don't list quickfix buffers
-- ============================================================================
api.nvim_create_autocmd("FileType", {
    pattern = "qf",
    callback = function()
        vim.opt_local.buflisted = false
    end,
})

-- ============================================================================
-- CD to project root when opening a Python file
-- ============================================================================
api.nvim_create_autocmd("BufReadPost", {
    group = project_root,
    pattern = "*.py",
    callback = function()
        local root = vim.fs.root(0, { "pyproject.toml", "setup.py", "setup.cfg", ".git" })
        if root then
            vim.cmd("lcd " .. root)
        end
    end,
})

-- ============================================================================
-- CD to project root when opening a Clojure file
-- ============================================================================
api.nvim_create_autocmd("BufReadPost", {
    group = project_root,
    pattern = "*.clj",
    callback = function()
        local root = vim.fs.root(0, { "deps.edn", "project.clj", ".git" })
        if root then
            vim.cmd("lcd " .. root)
        end
    end,
})

-- ============================================================================
-- Update barbecue winbar on obsession status change
-- ============================================================================
api.nvim_create_autocmd("CursorHold", {
    callback = function()
        require("barbecue.ui").update()
    end,
})
