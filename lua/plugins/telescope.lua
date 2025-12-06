return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.5",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local telescope = require("telescope")
    local builtin   = require("telescope.builtin")

    telescope.setup({
      defaults = {
        layout_strategy = "flex",
        mappings = {
          i = {
            ["<C-j>"] = "move_selection_next",
            ["<C-k>"] = "move_selection_previous",
          },
        },
      },
    })

    local map = vim.keymap.set
    map("n", "<leader>tf", builtin.find_files, { desc = "Telescope Files" })
    map("n", "<leader>tg", builtin.live_grep,  { desc = "Telescope Grep" })
    map("n", "<leader>tb", builtin.buffers,    { desc = "Telescope Buffers" })
    map("n", "<leader>th", builtin.help_tags,  { desc = "Telescope Help" })
  end,
}
