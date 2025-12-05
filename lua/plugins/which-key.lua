return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  opts = {
    -- Use the new spec-based configuration so which-key v3
    -- can derive groups directly from here.
    spec = {
      { "<leader>f",  group = "+find" },      -- Telescope
      { "<leader>c",  group = "+code" },      -- Code / compiler
      { "<leader>d",  group = "+debug" },     -- DAP
      { "<leader>a",  group = "+ai" },        -- AI tools
      { "<leader>cc", group = "+compiler" },  -- more specific compiler subgroup
    },
  },
}
