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

local function get_csharp_project_name()
    local path = vim.fn.expand("%:p:h")
    while path ~= "/" do
        local csproj = vim.fn.glob(path .. "/*.csproj")
        if csproj ~= "" then
            local name = vim.fn.fnamemodify(csproj, ":t:r")
            return name .. " "
        end
        path = vim.fn.fnamemodify(path, ":h")
    end
    return ""
end

local function get_venv_or_project()
    local venv = vim.env.VIRTUAL_ENV
    if venv then
        local params = vim.split(venv, "-", { plain = true })
        return params[#params] .. " "
    end
    if vim.fn.filereadable("project.clj") == 1 then
        return get_project_name()
    end
    local csharp = get_csharp_project_name()
    if csharp ~= "" then
        return csharp
    end
    return ""
end

return {
    -- Colorscheme: High priority to load immediately
    {
        "ramojus/mellifluous.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            color_set = "mountain",
            neutral = true,
            bg_contrast = "hard",
        },
    },

    -- Lualine progress component
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-tree/nvim-web-devicons", "ramojus/mellifluous.nvim" },
        config = function()
            require("lualine").setup({
                options = {
                    theme = "auto",
                    component_separators = { left = "", right = "" },
                    section_separators = { left = "", right = "" },
                    globalstatus = true,
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { "branch", "diff", "diagnostics" },
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
                                local ok, state = pcall(require, "test_state")
                                if not ok then
                                    return ""
                                end
                                if state.running then
                                    return "⟳  testing"
                                end
                                if state.passed == 0 and state.failed == 0 then
                                    return ""
                                end
                                local parts = {}
                                if state.passed > 0 then
                                    table.insert(parts, "✓ " .. state.passed)
                                end
                                if state.failed > 0 then
                                    table.insert(parts, "✗ " .. state.failed)
                                end
                                return table.concat(parts, " ")
                            end,
                            color = function()
                                local ok, state = pcall(require, "test_state")
                                if not ok then
                                    return {}
                                end
                                if state.running then
                                    return { fg = "#FFCB6B" }
                                end
                                if state.failed > 0 then
                                    return { fg = "#F07178" }
                                end
                                if state.passed > 0 then
                                    return { fg = "#C3E88D" }
                                end
                                return {}
                            end,
                        },
                        {
                            function()
                                return vim.fn.ObsessionStatus("●", "○")
                            end,
                            color = { fg = "#C3E88D" },
                        },
                    },
                    lualine_y = { "fileformat", "encoding" },
                    lualine_z = { "progress", "location" },
                },
            })
        end,
    },
    -- Winbar breadcrumbs
    {
        "utilyre/barbecue.nvim",
        event = "VeryLazy",
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
        lazy = false,
        priority = 500,
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
        event = { "BufReadPost", "BufNewFile" },
        main = "ibl",
        opts = {
            enabled = false,
            indent = { char = "│" },
            scope = { enabled = false },
            whitespace = { remove_blankline_trail = true },
        },
    },
}
