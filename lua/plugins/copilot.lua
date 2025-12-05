return {
  "github/copilot.vim",
  config = function()
    vim.keymap.set("n", "<leader>ap", "<cmd>Copilot panel<cr>", { desc = "Copilot Panel" })
  end,
}
