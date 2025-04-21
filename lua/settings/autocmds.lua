-- be more concise:
local api = vim.api

-- close terminal window on <c-d>
api.nvim_create_autocmd('TermOpen', {
    pattern = '*',
    callback = function()
        vim.keymap.set('t', '<c-d>', '<CMD> bd! <CR>', { buffer = 0 })
    end,
})

-- dont list quickfix buffers
api.nvim_create_autocmd('FileType', {
    pattern = 'qf',
    callback = function() vim.opt_local.buflisted = false end,
})

-- set textwidth for lua
api.nvim_create_autocmd('FileType', {
    pattern = 'lua',
    callback = function() vim.opt_local.textwidth = 98 end,
})

-- set textwidth for csharp
api.nvim_create_autocmd('FileType', {
    pattern = 'cs',
    callback = function() vim.opt_local.textwidth = 98 end,
})

-- set textwidth for python
api.nvim_create_autocmd('FileType', {
    pattern = 'python',
    callback = function() vim.opt_local.textwidth = 88 end,
})

-- make a little flash when yanking:
api.nvim_create_autocmd('TextYankPost', {
    pattern = '*',
    group = api.nvim_create_augroup('YankHighlight', { clear = true }),
    callback = function() vim.highlight.on_yank() end,
})

-- remove trainilng whitespace:
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    command = "%s/\\s\\+$//e"
})

-- Shamelessly ripped from Kickstart.nvim:
--
-- Switch for controlling whether you want autoformatting.  Use
-- :AutoFormatToggle to toggle autoformatting on or off
local format_is_enabled = true
vim.api.nvim_create_user_command('AutoFormatToggle', function()
    format_is_enabled = not format_is_enabled
    print('Setting autoformatting to: ' .. tostring(format_is_enabled))
end, {})
-- Create an augroup that is used for managing our formatting autocmds.
-- We need one augroup per client to make sure that multiple clients can
-- attach to the same buffer without interfering with each other.
local _augroups = {}
local get_augroup = function(client)
    if not _augroups[client.id] then
        local group_name = 'lsp-autoformat-' .. client.name
        local id = vim.api.nvim_create_augroup(group_name, { clear = true })
        _augroups[client.id] = id
    end
    return _augroups[client.id]
end
-- Whenever an LSP attaches to a buffer, we will run this function.
-- See `:help LspAttach` for more information about this autocmd event.
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('lsp-attach-autoformat', { clear = true }),
    -- This is where we attach the autoformatting for reasonable clients
    callback = function(args)
        local client_id = args.data.client_id
        local client = vim.lsp.get_client_by_id(client_id)
        local bufnr = args.buf
        -- Only attach to clients that support document formatting
        if not client then
            return
        end

        if not client.server_capabilities.documentFormattingProvider then
            return
        end
        -- Create an autocmd that will run *before* we save the buffer.
        -- Run the formatting command for the LSP that has just attached.
        vim.api.nvim_create_autocmd('BufWritePre', {
            group = get_augroup(client),
            buffer = bufnr,
            callback = function()
                if not format_is_enabled then
                    return
                end
                vim.lsp.buf.format({
                    async = false,
                    filter = function(c)
                        return c.id == client.id
                    end,
                })
            end,
        })
    end,
})
-- Create a command `:Format` local to the LSP buffer
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local bufnr = args.buf
        vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
            vim.lsp.buf.format({ bufnr = bufnr })
        end, { desc = "Format current buffer with LSP" })
    end,
})
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.py",
    callback = function()
        vim.fn.system({ "black", vim.fn.expand("%") })
    end,
})

-- 
-- vim.api.nvim_create_autocmd("FileType", {
--     pattern = "python",
--     callback = function()
--         require("coverage").load(true)
--     end,
-- })
--
-- keep the winbar updated:
-- api.nvim_create_autocmd({
--     'WinScrolled',
--     'WinResized',
--     'InsertLeave',
--     'CursorHold',
--     'BufWinEnter',
-- }, {
--     group = api.nvim_create_augroup('barbecue.updater', {}),
--     callback = function() require('barbecue.ui').update() end,
-- })
