return {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    config = function()
        local telescope = require("telescope")
        local fb_actions = require("telescope").extensions.file_browser.actions

        telescope.setup({
            extensions = {
                file_browser = {
                    theme = "ivy",
                    hijack_netrw = true,
                    mappings = {
                        ["i"] = {
                            -- your custom insert mode mappings
                        },
                        ["n"] = {
                            -- your custom normal mode mappings
                        },
                    },
                },
            },
        })
        telescope.load_extension("file_browser")

        local map = vim.keymap.set
        map("n", "<leader>te", ":Telescope file_browser path=%:p:h select_buffer=true<CR>", { desc = "File Explorer" })

    end,
}
