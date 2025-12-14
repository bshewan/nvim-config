return {
  'akinsho/toggleterm.nvim', version = "*",
    config = function()
      require("toggleterm").setup({
        size = 20,
        open_mapping = [[<c-\>]],
        hide_numbers = true,
        winbar = {
          enabled = true,
          name_formatter = function(term) return "Terminal: " .. term.name end,
        },
     })
    end,
}
