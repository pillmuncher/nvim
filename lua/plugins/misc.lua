return {
    -- Org-mode
    {
        "nvim-orgmode/orgmode",
        event = "VeryLazy",
        ft = { "org" },
        opts = {
            org_agenda_files = "~/Documents/org/**/*",
            org_default_notes_file = "~/Documents/org/refile.org",
            org_indent_mode = "noindent",
        },
    },
}
