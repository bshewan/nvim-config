
return {
  {
    "Zeioth/compiler.nvim",
    dependencies = { "stevearc/overseer.nvim" },
    cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
    keys = {
      -- F6: The simple menu
      { "<F6>", "<cmd>CompilerOpen<cr>", desc = "Compiler: Open" },

      -- F7: Redo the last task
      { "<F7>", "<cmd>CompilerRedo<cr>", desc = "Compiler: Redo Last" },

      -- Shift+F7: Toggle the output window
      { "<S-F7>", "<cmd>CompilerToggle<cr>", desc = "Compiler: Toggle Output" },

      -- <leader>c... layout
      { "<leader>cc", "<cmd>CompilerOpen<cr>",   desc = "Compiler: Open" },
      { "<leader>cr", "<cmd>CompilerRedo<cr>",   desc = "Compiler: Redo Last" },
      { "<leader>co", "<cmd>CompilerToggle<cr>", desc = "Compiler: Toggle Output" },

      -- FORCE RUN MAKE (Bypasses scanning)
      { 
        "<leader>cm", 
        function()
          local overseer = require("overseer")

          overseer.open({enter = false, direction = "bottom"})

          -- We create a task manually. We don't care if Overseer "found" it or not.
          local task = overseer.new_task({
            name = "Force Make Run",
            strategy = { "jobstart" },
            cmd = { "make", "run" }, -- <--- This is the exact command it will run in terminal
            cwd = vim.fn.getcwd(),
            components = { 
              "default", 
              { "open_output", open_on_start = true }, 
              -- Auto-dispose after 5 seconds if successful
              { "on_complete_dispose", timeout = 5, statuses = { "SUCCESS" } }
            }
          })
          task:start()
        end, 
        desc = "Run Make (Force)" 
      },
    },
    opts = {},
  },
  
  -- The Task Runner Engine (Overseer)
  {
    "stevearc/overseer.nvim",
    opts = {
      -- 1. SPEED UP: Only look for Makefiles and VSCode tasks
      templates = { "make", "vscode" },
      
      -- 2. UI Configuration
      task_list = {
        direction = "bottom",
        min_height = 25,
        max_height = 25,
        default_detail = 1,
        bindings = {
          -- V2.0 requires defining bindings here if you want custom ones
          ["?"] = "ShowHelp",
          ["<CR>"] = "RunAction",
          ["<C-e>"] = "Edit",
          ["o"] = "Open",
          ["<C-v>"] = "OpenVsplit",
          ["<C-s>"] = "OpenSplit",
          ["<C-f>"] = "OpenFloat",
          ["dd"] = "Dispose",
        },
      },
    },
  },
}
