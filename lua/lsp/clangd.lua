local M = {}

M.config = {
	cmd = { "clangd" },
	filetypes = { "c", "cpp", "objc", "objcpp" },
	root_dir = lspconfig.util.root_pattern("compile_commands.json", ".clangd", ".clang-tidy", ".git"),
	settings = {
		clangd = {
			-- Enable semantic highlighting
			semanticHighlighting = true,
			-- Enable clang-tidy integration
			clangTidyFile = ".clang-tidy",
			-- Enable compilation database support
			compilationDatabasePath = "compile_commands.json",
			-- Enable indexing of third-party headers
			index = {
				huds = true,
				threads = 0, -- Auto-detect number of threads
			},
			-- Enable caching of compilation results
			cache = {
				Directory = ".clangd/cache",
				Format = "binary",
			},
		},
	},
}

return M
