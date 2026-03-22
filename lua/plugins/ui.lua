local function get_project_name()
    local root = vim.fs.root(0, { "project.clj" })
    if not root then
        return ""
    end
    local f = io.open(root .. "/project.clj", "r")
    if not f then
        return ""
    end
    local content = f:read("*a")
    f:close()
    local name = content:match("%(defproject%s+([%w%-%._/]+)") or ""
    return name ~= "" and (name .. " ") or ""
end

local function get_venv_or_project()
    if vim.fn.filereadable("project.clj") == 1 then
        return get_project_name()
    end
    local venv = vim.env.VIRTUAL_ENV
    if venv then
        local params = vim.split(venv, "-", { plain = true })
        return params[#params] .. " "
    end
    return ""
end

return {
    -- Colorscheme
    {
        "ramojus/mellifluous.nvim",
        lazy = false,
        priority = 1000000,
        opts = {
            color_set = "mountain",
            neutral = true,
            bg_contrast = "hard",
        },
    },

    -- Statusline
    {
        "nvim-lualine/lualine.nvim",
        lazy = false,
        priority = 100000,
        dependencies = {
            "nvim-tree/nvim-web-devicons",
            "ramojus/mellifluous.nvim",
        },
        opts = {
            theme = "mellifluous",
            extensions = {
                "fzf",
                "lazy",
                "man",
                "mason",
                "nvim-dap-ui",
                "nvim-tree",
                "quickfix",
                "symbols-outline",
                "toggleterm",
            },
            options = {
                component_separators = { left = "", right = "" },
                section_separators = { left = "", right = "" },
            },
            sections = {
                lualine_c = {
                    { "filetype", icon_only = true, icon = { align = "right" } },
                    {
                        "filename",
                        path = 4,
                        file_status = true,
                        newfile_status = true,
                        symbols = { modified = "[✗]", readonly = "[]" },
                    },
                },
                lualine_x = {
                    "selectioncount",
                    "searchcount",
                    {
                        function()
                            return vim.fn.ObsessionStatus("●", "○")
                        end,
                        color = { fg = "#C3E88D" }, -- or whatever color fits your theme
                    },
                },
                lualine_y = { "fileformat", "encoding" },
                lualine_z = { "progress", "location" },
            },
        },
    },

    -- Winbar breadcrumbs
    {
        "utilyre/barbecue.nvim",
        lazy = false,
        priority = 100000,
        name = "barbecue",
        dependencies = {
            "ramojus/mellifluous.nvim",
            "SmiteshP/nvim-navic",
            "nvim-tree/nvim-web-devicons",
        },
        opts = {
            create_autocmd = true,
            show_dirname = false,
            show_basename = false,
            custom_section = get_venv_or_project,
        },
    },

    -- Transparent background
    {
        "xiyaowong/transparent.nvim",
        opts = {
            groups = {
                "Comment",
                "Conditional",
                "Constant",
                "CursorLine",
                "CursorLineNr",
                "EndOfBuffer",
                "Function",
                "Identifier",
                "LineNr",
                "NonText",
                "Normal",
                "NormalNC",
                "Operator",
                "PreProc",
                "Repeat",
                "SignColumn",
                "Special",
                "Statement",
                "String",
                "Structure",
                "Todo",
                "Type",
                "Underlined",
            },
            extra_groups = {
                "DiagnosticOK",
                "DiagnosticSignError",
                "DiagnosticSignHint",
                "DiagnosticSignInfo",
                "DiagnosticSignWarn",
                "GitSignsAdd",
                "GitSignsAddLnInline",
                "GitSignChange",
                "GitSignsChange",
                "GitSignsDelete",
                "SignColumn",
            },
            exclude_groups = {},
        },
    },

    -- Rainbow delimiters
    {
        "HiPhish/rainbow-delimiters.nvim",
        ft = { "clojure", "python", "lua", "vim" },
        config = function()
            require("rainbow-delimiters.setup").setup({
                strategy = {
                    [""] = "rainbow-delimiters.strategy.global",
                    vim = "rainbow-delimiters.strategy.local",
                    python = "rainbow-delimiters.strategy.global",
                },
                query = {
                    [""] = "rainbow-delimiters",
                    lua = "rainbow-blocks",
                    clojure = "rainbow-delimiters",
                    python = "rainbow-delimiters",
                },
                priority = { [""] = 110, lua = 210 },
                highlight = {
                    "RainbowDelimiterRed",
                    "RainbowDelimiterYellow",
                    "RainbowDelimiterBlue",
                    "RainbowDelimiterOrange",
                    "RainbowDelimiterGreen",
                    "RainbowDelimiterViolet",
                    "RainbowDelimiterCyan",
                },
            })
        end,
    },

    -- Indent guides
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {
            enabled = false,
            indent = { char = "│" },
            scope = { enabled = false },
            whitespace = { remove_blankline_trail = true },
        },
    },
}
