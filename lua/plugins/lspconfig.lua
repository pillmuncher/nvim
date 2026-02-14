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
		local notify_orig = vim.notify
		vim.notify = function() end -- temporarily suppress notifications

		local lspconfig = require("lspconfig")

		-- setup servers
		lspconfig.pyright.setup({
			settings = {
				python = {
					analysis = {
						autoSearchPaths = true,
						useLibraryCodeForTypes = true,
					},
				},
			},
		})
		lspconfig.ruff.setup({})
		lspconfig.clojure_lsp.setup({})

		-- restore notifications
		vim.notify = notify_orig

		-- attach navic on any LSP client
		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(args)
				local client = vim.lsp.get_client_by_id(args.data.client_id)
				if client.server_capabilities.documentSymbolProvider then
					require("nvim-navic").attach(client, args.buf)
				end
			end,
		})
	end,
}
