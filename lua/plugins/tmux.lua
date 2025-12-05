return {
  -- 1. Navigate between Vim and Tmux with Ctrl+h/j/k/l and Ctrl+\\
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>",  mode = { "n", "t" } },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>",  mode = { "n", "t" } },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>",    mode = { "n", "t" } },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>", mode = { "n", "t" } },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>", mode = { "n", "t" } },
    },
  },

  -- 2. Maximize a split with Leader+z (Like Tmux zoom)
  {
    "szw/vim-maximizer",
    keys = {
      { "<leader>z", "<cmd>MaximizerToggle<cr>", desc = "Maximize Split" },
    },
  },
}
