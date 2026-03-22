local api = vim.api

-- Open all folds when entering a Python buffer
api.nvim_create_autocmd("FileType", {
    pattern = "python",
    callback = function()
        vim.cmd("normal! zx")
    end,
})

-- Close terminal window on <C-d>
api.nvim_create_autocmd("TermOpen", {
    pattern = "*",
    callback = function()
        vim.keymap.set("t", "<c-d>", "<CMD>bd!<CR>", { buffer = 0 })
    end,
})

-- Don't list quickfix buffers
api.nvim_create_autocmd("FileType", {
    pattern = "qf",
    callback = function()
        vim.opt_local.buflisted = false
    end,
})

-- Flash when yanking
api.nvim_create_autocmd("TextYankPost", {
    pattern = "*",
    group = api.nvim_create_augroup("YankHighlight", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- Remove trailing whitespace on save
api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    command = "%s/\\s\\+$//e",
})

-- CD to project root when opening a Clojure file
api.nvim_create_autocmd("BufReadPost", {
    pattern = "*.clj",
    callback = function()
        local root = vim.fs.root(0, { "deps.edn", "project.clj", ".git" })
        if root then
            vim.cmd("cd " .. root)
        end
    end,
})

-- Soft wrap for text files
api.nvim_create_augroup("TextSoftWrap", { clear = true })
api.nvim_create_autocmd("FileType", {
    group = "TextSoftWrap",
    pattern = { "markdown", "org" },
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.linebreak = true
        vim.opt_local.textwidth = 0
    end,
})

-- Update barbecue winbar on obsession status change
api.nvim_create_autocmd("CursorHold", {
    callback = function()
        require("barbecue.ui").update()
    end,
})
