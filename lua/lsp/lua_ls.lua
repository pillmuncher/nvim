local M = {}

M.config = {
	Lua = {
		workspace = {
			checkThirdParty = false,
			library = {
				[vim.fn.expand("$VIMRUNTIME/lua")] = true,
				[vim.fn.stdpath("config") .. "/lua"] = true,
			},
		},
		telemetry = {
			enable = false,
		},
		diagnostics = {
			globals = { "vim" },
			disable = { "undefined-global" },
		},
		format = {
			enable = true,
			-- Use stylua for formatting
			defaultConfigBasedOnStyle = "stylua",
		},
		completion = {
			enable = true,
			callSnippet = "Replace",
			group_load = {
				"java",
				"python",
				"javascript",
				"typescript",
				"c",
				"cpp",
				"ruby",
				"lua",
			},
		},
		runtime = {
			version = "LuaJIT",
			path = vim.split(package.path),
		},
		semantic = {
			enable = true,
		},
	},
}

return M
