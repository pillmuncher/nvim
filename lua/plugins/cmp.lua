local has_words_before = function()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

return {
    'hrsh7th/nvim-cmp',
    lazy         = false,
    dependencies = {
        { "Olical/conjure" },
        { 'L3MON4D3/LuaSnip',            opts = {}, build = "make install_jsregexp" },
        { 'PaterJason/cmp-conjure' },
        { 'hrsh7th/cmp-nvim-lsp',        opts = {} },
        { 'rafamadriz/friendly-snippets' },
        { 'saadparwaiz1/cmp_luasnip' },
    },
    opts         = function(_, opts)
        if type(opts.sources) == "table" then
            vim.list_extend(opts.sources, { name = "conjure" })
        end
    end,
    config       = function()
        local cmp = require('cmp')
        local luasnip = require('luasnip')
        require('luasnip.loaders.from_vscode').lazy_load()

        cmp.setup({
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-n>'] = cmp.mapping.select_next_item(),
                ['<C-p>'] = cmp.mapping.select_prev_item(),
                ['<C-d>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-Space>'] = cmp.mapping.complete({}),
                ['<CR>'] = cmp.mapping.confirm({
                    behavior = cmp.ConfirmBehavior.Replace,
                    select = true,
                }),
                ['<Tab>'] = function(fallback)
                    if not cmp.select_next_item() then
                        if vim.bo.buftype ~= 'prompt' and has_words_before() then
                            cmp.complete()
                        else
                            fallback()
                        end
                    end
                end,
                ['<S-Tab>'] = function(fallback)
                    if not cmp.select_prev_item() then
                        if vim.bo.buftype ~= 'prompt' and has_words_before() then
                            cmp.complete()
                        else
                            fallback()
                        end
                    end
                end,
                ['<M-Down>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif luasnip.expand_or_locally_jumpable() then
                        luasnip.expand_or_jump()
                    else
                        fallback()
                    end
                end, { 'i', 's' }),
                ['<M-Up>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.locally_jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { 'i', 's' }),
            }),
            sources = cmp.config.sources({
                { name = 'buffer' },
                { name = 'conjure' },
                { name = 'clojure' },
                { name = 'luasnip' },
                { name = 'nvim_lsp' },
                { name = 'nvim_lsp_signature_help' },
                { name = 'path' },
                { name = 'spell' },
                { name = 'vsnip' },
            })
        })
    end,
}
