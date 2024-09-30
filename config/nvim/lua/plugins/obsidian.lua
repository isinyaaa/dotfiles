return {
    "epwalsh/obsidian.nvim",
    ft = "markdown",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    opts = {
        workspaces = {
            {
                name = "personal",
                path = "~/personal/notes/obsidian/current/",
            },
        },
    },
}
