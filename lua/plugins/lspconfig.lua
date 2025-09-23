return {
	"neovim/nvim-lspconfig",
	lazy = false,
	dependencies = {
		{ "SmiteshP/nvim-navic" },
		{ "folke/lazydev.nvim" },
		{ "folke/which-key.nvim" },
		{ "j-hui/fidget.nvim", tag = "legacy" },
		{ "williamboman/mason-lspconfig.nvim", dependencies = "williamboman/mason.nvim" },
		{ "williamboman/mason.nvim", opts = {} },
	},
	config = function()
		vim.lsp.enable("pyright")
		vim.lsp.enable("ruff")
	end,
}
