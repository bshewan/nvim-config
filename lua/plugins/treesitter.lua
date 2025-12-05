return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          -- main languages
          "c", "cpp", "rust", "python", "typescript", "tsx", "javascript",
          -- ecosystem / config
          "json", "jsonc", "toml", "yaml",
          -- Neovim / Lua
          "lua", "vim", "vimdoc", "query",
          -- shell / docs
          "bash", "markdown", "markdown_inline",
        },

        sync_install = false,
        auto_install = true,

        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },

        indent = {
          enable = true,
        },
      })
    end,
  },
}

