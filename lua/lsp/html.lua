local M = {}

M.config = {
	filetypes = { "html", "twig", "hbs" },
	init_options = {
		provideMarkupLinter = true,
		provideStyleLinter = true,
		provideScriptLinter = true,
	},
	settings = {
		html = {
			-- Enable/disable default HTML validation
			validate = true,
			-- Enable/disable default HTML linting
			lint = true,
			-- Enable/disable default HTML formatting
			format = true,
			-- Enable/disable default HTML completion
			completion = true,
		},
		css = {
			-- Enable/disable default CSS validation
			validate = true,
			-- Enable/disable default CSS linting
			lint = true,
			-- Enable/disable default CSS formatting
			format = true,
			-- Enable/disable default CSS completion
			completion = true,
		},
		javascript = {
			-- Enable/disable default JavaScript validation
			validate = true,
			-- Enable/disable default JavaScript linting
			lint = true,
			-- Enable/disable default JavaScript formatting
			format = true,
			-- Enable/disable default JavaScript completion
			completion = true,
		},
	},
}

return M
