local function set_python_path(path)
	local clients = vim.lsp.get_clients({
		bufnr = vim.api.nvim_get_current_buf(),
		name = "pyright",
	})
	for _, client in ipairs(clients) do
		if client.settings then
			client.settings.python = vim.tbl_deep_extend("force", client.settings.python, { pythonPath = path })
		else
			client.config.settings =
				vim.tbl_deep_extend("force", client.config.settings, { python = { pythonPath = path } })
		end
		client.notify("workspace/didChangeConfiguration", { settings = nil })
	end
end

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
		-- Fix "position_encoding param" error message
		-- for telescope.builtin.lsp_document_symbols:
		local notify_original = vim.notify
		vim.notify = function(msg, ...)
			if
				msg
				and (
					msg:match("position_encoding param is required")
					or msg:match("Defaulting to position encoding of the first client")
					or msg:match("multiple different client offset_encodings")
				)
			then
				return
			end
			return notify_original(msg, ...)
		end

		-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
		local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

		-- Common on_attach function
		local on_attach = function(client, bufnr)
			if client.server_capabilities["documentSymbolProvider"] then
				require("nvim-navic").attach(client, bufnr)
			end
			require("settings.mappings").setup_lsp(bufnr)
		end

		vim.diagnostic.config({
			virtual_text = true,
			signs = true,
			update_in_insert = false,
		})

		-- Define the LSP servers to set up
		local servers = {
			pyright = {
				cmd = { "pyright-langserver", "--stdio" },
				filetypes = { "python" },
				root_dir = require("lspconfig.util").root_pattern("pyproject.toml"),
				root_markers = {
					"pyproject.toml",
					"setup.py",
					"setup.cfg",
					"requirements.txt",
					"Pipfile",
					"pyrightconfig.json",
					".git",
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
						client:exec_cmd({
							command = "pyright.organizeimports",
							arguments = { vim.uri_from_bufnr(bufnr) },
						})
					end, {
						desc = "Organize Imports",
					})
					vim.api.nvim_buf_create_user_command(bufnr, "LspPyrightSetPythonPath", set_python_path, {
						desc = "Reconfigure pyright with the provided python path",
						nargs = 1,
						complete = "file",
					})
				end,
			},
			ruff = {
				cmd = { "ruff", "server" },
				filetypes = { "python" },
				root_dir = require("lspconfig.util").root_pattern("pyproject.toml", "ruff.toml", ".ruff.toml", ".git"),
				root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
				settings = {},
			},
			clangd = {},
			-- omnisharp = { filetypes = { "cs" } },
			html = { filetypes = { "html", "twig", "hbs" } },
			lua_ls = {
				Lua = {
					workspace = { checkThirdParty = false },
					telemetry = { enable = false },
					diagnostics = { globals = { "vim" } },
				},
			},
			-- pylsp = {
			--     settings = {
			--         pylsp = {
			--             plugins = {
			--                 black = { enabled = true },
			--                 pylsp_mypy = {
			--                     enabled = true,
			--                     strict = true,
			--                     live_mode = false,
			--                     overrides = {
			--                         "--check-untyped-defs",
			--                         "--explicit-package-bases",
			--                         "--namespace-packages",
			--                         ".",
			--                     },
			--                 },
			--                 pycodestyle = { enabled = false },
			--                 pyflakes = { enabled = false },
			--                 flake8 = { enabled = false },
			--                 pylsp_rope = { enabled = true },
			--                 rope_autoimport = { enabled = true },
			--                 rope_completion = { enabled = true },
			--                 rope_refactor = { enabled = true },
			--             },
			--             diagnostics = {
			--                 enable = true,
			--                 types = {
			--                     'error', 'warning', 'information', 'hint' -- this ensures all types are shown
			--                 },
			--             },
			--         },
			--     },
			--     -- on_new_config = function(new_config, _)
			--     --     local mypy_path = os.getenv("MYPYPATH")
			--     --     if mypy_path then
			--     --         new_config.cmd_env = {
			--     --             MYPYPATH = mypy_path,
			--     --         }
			--     --     end
			--     -- end,
			-- },
		}

		-- Set up Mason with the LSP servers
		local mason_lspconfig = require("mason-lspconfig")
		mason_lspconfig.setup({
			ensure_installed = vim.tbl_keys(servers),
			automatic_enable = true,
		})

		-- After mason_lspconfig.setup(...)
		for server_name, server_config in pairs(servers) do
			local config = vim.tbl_deep_extend("force", {
				capabilities = capabilities,
				on_attach = on_attach,
			}, server_config)

			require("lspconfig")[server_name].setup(config)
		end
	end,
}
