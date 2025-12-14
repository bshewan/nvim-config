return {
  "folke/tokyonight.nvim",
  lazy = false,    -- Load immediately
  priority = 1000, -- Load before everything else
  config = function()
    require("tokyonight").setup({
      style = "night", -- Options: storm, moon, night, day
      transparent = false, -- Change to true if you want terminal background
      styles = {
        sidebars = "transparent",
        floats = "dark",
      },

      -- OPTIONAL: High-Visibility Overrides
      -- If your red underlines ever disappear again, uncomment this block:
      -- on_highlights = function(hl, c)
      --   hl.DiagnosticUnderlineError = { 
      --       bg = "#3d0000", fg = "#ffcccc", underline = true, sp = "#ff0000" 
      --   }
      -- end,
    })

    -- 2. Activate the theme
    vim.cmd.colorscheme("tokyonight")
  end,
}
