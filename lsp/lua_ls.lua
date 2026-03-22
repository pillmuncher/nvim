return {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    root_markers = { ".luarc.json", ".luarc.jsonc", ".git" },
    settings = {
        Lua = {
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.fn.expand("$VIMRUNTIME/lua"),
                    vim.fn.stdpath("config") .. "/lua",
                },
            },
            telemetry = { enable = false },
            diagnostics = {
                globals = { "vim" },
                disable = { "undefined-global" },
            },
            format = {
                enable = true,
                defaultConfigBasedOnStyle = "stylua",
            },
            completion = {
                enable = true,
                callSnippet = "Replace",
            },
            semantic = { enable = true },
        },
    },
}
