return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    "hrsh7th/cmp-nvim-lsp",
  },
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    cmp.setup({
      -- Required for AI/LSP snippets
      snippet = {
        expand = function(args) luasnip.lsp_expand(args.body) end,
      },
      
      -- Selection behavior
      completion = { completeopt = "menu,menuone,noinsert" },

      -- Mappings
      mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        
        -- ENTER: Accept menu item
        ["<CR>"] = cmp.mapping.confirm({ select = true }),

        -- TAB: REMOVED to let Copilot handle it!
        -- If you don't use Copilot, you can map this to confirm()
        
        -- Navigation
        ["<Down>"] = cmp.mapping.select_next_item(),
        ["<Up>"] = cmp.mapping.select_prev_item(),
      }),

      sources = cmp.config.sources({
        { name = "codecompanion" }, -- AI
        { name = "nvim_lsp" },      -- C/C++/Rust
        { name = "luasnip" },
      }, {
        { name = "buffer" },
        { name = "path" },
      }),
      
      -- Pretty Icons
      formatting = {
        format = function(entry, vim_item)
          vim_item.menu = ({
            codecompanion = "[AI]",
            nvim_lsp = "[LSP]",
            luasnip = "[Snip]",
            buffer = "[Buf]",
          })[entry.source.name]
          return vim_item
        end,
      },
    })
  end,
}
