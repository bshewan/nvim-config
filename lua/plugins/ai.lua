return {
  "olimorris/codecompanion.nvim",
  version = "17.33.0",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    require("codecompanion").setup({
      strategies = {
        chat = { adapter = "gemini" },
        inline = { adapter = "gemini" },
      },
    })
  end,
  keys = {
    { "<leader>ac", "<cmd>CodeCompanionChat<cr>",    mode = { "n", "v" }, desc = "AI Chat (CodeCompanion)" },
    { "<leader>ai", "<cmd>CodeCompanion<cr>",        mode = { "n", "v" }, desc = "AI Inline (CodeCompanion)" },
    { "<leader>aa", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "AI Actions (CodeCompanion)" },
  },
}

