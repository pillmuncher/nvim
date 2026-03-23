local function set_python_path(command)
    for _, client in
        ipairs(vim.lsp.get_clients({
            bufnr = vim.api.nvim_get_current_buf(),
            name = "pyright",
        }))
    do
        client.settings = vim.tbl_deep_extend(
            "force",
            client.settings or client.config.settings or {},
            { python = { pythonPath = command.args } }
        )

        client:notify("workspace/didChangeConfiguration", { settings = nil })
    end
end

return {
    cmd = { "pyright-langserver", "--stdio" },
    filetypes = { "python" },
    root_markers = {
        "pyproject.toml",
        "setup.py",
        "setup.cfg",
        "requirements.txt",
        "Pipfile",
        "pyrightconfig.json",
        ".git",
    },
    capabilities = {
        general = {
            positionEncodings = { "utf-8" },
        },
    },
    settings = {
        python = {
            analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "openFilesOnly",
            },
        },
    },
    on_attach = function(client, bufnr)
        vim.api.nvim_buf_create_user_command(bufnr, "LspPyrightOrganizeImports", function()
            client.request("workspace/executeCommand", {
                command = "pyright.organizeimports",
                arguments = { vim.uri_from_bufnr(bufnr) },
            }, nil, bufnr)
        end, { desc = "Organize imports" })

        vim.api.nvim_buf_create_user_command(bufnr, "LspPyrightSetPythonPath", set_python_path, {
            desc = "Reconfigure pyright with the provided python path",
            nargs = 1,
            complete = "file",
        })
    end,
}
