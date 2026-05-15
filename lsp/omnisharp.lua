return {
    cmd = { vim.fn.stdpath("data") .. "/mason/bin/OmniSharp", "--languageserver" },
    filetypes = {
        "cs",
    },
    root_markers = {
        "*.sln",
        "*.csproj",
        ".sln",
        ".csproj",
        ".git",
    },
}
