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
		-- in your plugin spec or a separate Lua module loaded after lazy.nvim loads mason/lspconfig

		-- attach navic on any LSP client with documentSymbolProvider
		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(args)
				local client = vim.lsp.get_client_by_id(args.data.client_id)
				if client.server_capabilities.documentSymbolProvider then
					require("nvim-navic").attach(client, args.buf)
				end
			end,
		})
		vim.lsp.enable("clojure_lsp")
		vim.lsp.enable("pyright")
		vim.lsp.enable("ruff")
	end,
}
