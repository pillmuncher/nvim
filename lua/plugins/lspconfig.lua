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
		local lspconfig = require("lspconfig")

		-- nvim-cmp capabilities
		local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

		-- Common on_attach
		local function on_attach(client, bufnr)
			if client.server_capabilities.documentSymbolProvider then
				require("nvim-navic").attach(client, bufnr)
			end
			require("settings.mappings").setup_lsp(bufnr)
		end

		local servers = {
			pyright = {
				cmd = { "pyright-langserver", "--stdio" },
				filetypes = { "python" },
				root_dir = lspconfig.util.root_pattern("pyproject.toml", ".git"),
				root_markers = {
					"pyproject.toml",
					"setup.py",
					"setup.cfg",
					"requirements.txt",
					"Pipfile",
					"pyrightconfig.json",
					".git",
				},
				-- DO NOT set `settings` here — let Pyright read pyrightconfig.json
				on_attach = function(client, bufnr)
					on_attach(client, bufnr)
					vim.api.nvim_buf_create_user_command(bufnr, "LspPyrightOrganizeImports", function()
						client:exec_cmd({
							command = "pyright.organizeimports",
							arguments = { vim.uri_from_bufnr(bufnr) },
						})
					end, { desc = "Organize Imports" })
				end,
			},
			ruff = {
				cmd = { "ruff", "server", "--config", vim.fn.getcwd() .. "/pyproject.toml" },
				filetypes = { "python" },
				root_dir = lspconfig.util.root_pattern("pyproject.toml", "ruff.toml", ".ruff.toml", ".git"),
			},
			clangd = {},
			html = { filetypes = { "html", "twig", "hbs" } },
			lua_ls = {
				Lua = {
					workspace = { checkThirdParty = false },
					telemetry = { enable = false },
					diagnostics = { globals = { "vim" } },
				},
			},
		}

		require("mason-lspconfig").setup({
			ensure_installed = vim.tbl_keys(servers),
			automatic_enable = true,
		})

		for name, cfg in pairs(servers) do
			lspconfig[name].setup(vim.tbl_deep_extend("force", {
				capabilities = capabilities,
				on_attach = on_attach,
			}, cfg))
		end
	end,
}
