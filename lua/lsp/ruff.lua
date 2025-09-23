vim.lsp.config("ruff_lsp", {
	cmd = { "ruff", "server", "--config", vim.fn.getcwd() .. "/pyproject.toml" },
	filetypes = { "python" },
	root_dir = require("lspconfig.util").root_pattern("pyproject.toml", "ruff.toml", ".git"),
})
