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
    map("n", "<leader>ff", builtin.find_files, { desc = "Find Files" })
    map("n", "<leader>fg", builtin.live_grep,  { desc = "Live Grep" })
    map("n", "<leader>fb", builtin.buffers,    { desc = "Buffers" })
    map("n", "<leader>fh", builtin.help_tags,  { desc = "Help Tags" })
  end,
}
