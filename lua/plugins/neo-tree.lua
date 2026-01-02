return {
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            "nvim-tree/nvim-web-devicons",
        },
        lazy = false,
        keys = {
            { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle Explorer" },
        },
        opts = {
            filesystem = {
                filtered_items = {
                    visible = true,
                    hide_dotfiles = false,
                    hide_gitignored = false,
                },
                follow_current_file = { enabled = true },
                use_libuv_file_watcher = true,
            },
            window = {
                position = "left",
                width = 30,
            },
        },
    }
}
