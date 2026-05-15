return {
    cmd = { "ruff", "server" },
    filetypes = {
        "python",
    },
    root_markers = {
        "Pipfile",
        "pyproject.toml",
        "pyrightconfig.json",
        "requirements.txt",
        "ruff.toml",
        "setup.cfg",
        "setup.py",
        ".git",
    },
}
