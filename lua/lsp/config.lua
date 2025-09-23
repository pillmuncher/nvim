local lspconfig = require("lspconfig")
local mason_lspconfig = require("mason-lspconfig")

-- Common LSP settings
local common_config = {
	capabilities = require("cmp_nvim_lsp").default_capabilities(),
	root_dir = function()
		return vim.fn.getcwd()
	end,

	on_attach = function(client, bufnr)
		require("lsp.handlers").setup(client, bufnr)
		if client.server_capabilities.documentSymbolProvider then
			require("nvim-navic").attach(client, bufnr)
		end
	end,

	flags = {
		debounce_text_changes = 150,
	},
}

-- Set up Mason
require("mason").setup({
	ui = {
		border = "rounded",
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
	},
})

-- Set up LSP installer
mason_lspconfig.setup({
	ensure_installed = {
		"pyright",
		"ruff",
		"clangd",
		"html",
		"lua_ls",
	},
	automatic_installation = true,
})
