local M = {}

M.config = {
	cmd = { "clojure-lsp" },
	filetypes = { "clojure", "edn" },
	root_dir = lspconfig.util.root_pattern("deps.edn", "project.clj", ".git"),
	settings = {
		clojure = {
			-- Enable or disable features
			enable = {
				-- Enable clj-kondo integration
				cljKondo = true,
				-- Enable clojure-lint integration
				clojureLint = true,
				-- Enable eastwood linting
				eastwood = true,
				-- Enable refactorings
				refactor = true,
				-- Enable test runner
				test = true,
				-- Enable REPL support
				repl = true,
				-- Enable AOT compilation
				aot = true,
				-- Enable function usage analysis
				functionUsage = true,
				-- Enable var usage analysis
				varUsage = true,
			},

			-- Editor settings
			editor = {
				-- Enable code formatting
				formatOnSave = true,
				-- Enable auto-import sort
				autoImportSort = true,
				-- Enable auto-add-ns-to-blank-clj-files
				autoAddNsToBlankCljFiles = true,
			},

			-- REPL settings
			repl = {
				-- REPL connection timeout in milliseconds
				connectTimeoutMs = 10000,
				-- REPL connection retry attempts
				connectRetryAttempts = 3,
			},

			-- Test settings
			test = {
				-- Test file patterns
				testFileRegex = [[^(test/.*|(.*_test\.clj))$]],
				-- Test namespace patterns
				testNamespaceRegex = [[^(.*-test)$]],
			},

			-- Refactoring settings
			refactor = {
				-- Enable rename refactoring
				rename = true,
				-- Enable extract function refactoring
				extractFunction = true,
				-- Enable move file refactoring
				moveFile = true,
				-- Enable cycle colliding imports
				cycleCollidingImports = true,
			},

			-- Analysis settings
			analysis = {
				-- Enable unused private vars analysis
				unusedPrivateVars = true,
				-- Enable unused public vars analysis
				unusedPublicVars = true,
				-- Enable unused namespace analysis
				unusedNamespaces = true,
				-- Enable unused imports analysis
				unusedImports = true,
			},

			-- Documentation settings
			documentation = {
				-- Enable doc lookup
				lookup = true,
				-- Enable inline docs
				inlineDocs = true,
			},

			-- Completion settings
			completion = {
				-- Enable function argument completion
				functionArgumentPlaceholders = true,
				-- Enable resolve middleware aliases
				resolveMiddlewareAliases = true,
			},
		},
	},
}

return M
