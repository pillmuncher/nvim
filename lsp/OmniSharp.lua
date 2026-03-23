return {
    cmd = { vim.fn.stdpath("data") .. "/mason/bin/OmniSharp", "--languageserver" },
    filetypes = { "cs" },
    root_markers = { ".git" },
}
