return {
  "NickvanDyke/opencode.nvim",
  dependencies = {
    -- Recommended for `ask()` and `select()`.
    -- Required for `snacks` provider.
    { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
  },
  config = function()
    ---@type opencode.Opts
    vim.g.opencode_opts = {
      -- Your configuration, if any — see `lua/opencode/config.lua`, or "goto definition".
    }

    -- Required for `opts.events.reload`.
    vim.o.autoread = true

    local map = vim.keymap.set

    -- AI under <leader>a...
    map({ "n", "x" }, "<leader>ao",
      function() require("opencode").ask("@this: ", { submit = true }) end,
      { desc = "AI Ask (opencode)" })

    map({ "n", "x" }, "<leader>aO",
      function() require("opencode").select() end,
      { desc = "AI Select Action (opencode)" })

    map({ "n", "t" }, "<leader>at",
      function() require("opencode").toggle() end,
      { desc = "Toggle opencode" })

    map("n", "<leader>au",
      function() require("opencode").command("session.half.page.up") end,
      { desc = "opencode half page up" })

    map("n", "<leader>ad",
      function() require("opencode").command("session.half.page.down") end,
      { desc = "opencode half page down" })
  end,
}
