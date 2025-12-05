return {
  "mfussenegger/nvim-dap",
  dependencies = {
    --"rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    "theHamsta/nvim-dap-virtual-text",
    "jay-babu/mason-nvim-dap.nvim",
    "igorlfs/nvim-dap-view",
    "Jorenar/nvim-dap-disasm",
  },
  config = function()
    local dap = require("dap")
--    local dapui = require("dapui")
    local dapview = require("dap-view")
    local vtext = require("nvim-dap-virtual-text")

    vtext.setup({
        display_callback = function(variable, buf, stackframe, node, options)
          if options.virt_text_pos == 'inline' then
            return ' = ' .. variable.value
          else
            return variable.name .. ' = ' .. variable.value
          end
        end,
    })

--    dapui.setup()

    -- Auto-open UI
--    dap.listeners.before.attach.dapui_config = function() dapui.open() end
--    dap.listeners.before.launch.dapui_config = function() dapui.open() end
--    dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
--    dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

    require("dap-disasm").setup({
        -- Optional settings
      --show_registers = true,  -- Show registers at the top of the disassembly window
      --show_instructions = true, -- Show instructions in the disassembly window
      --instruction_count = 10,  -- Number of instructions to show
    })

    -- DAP View setup
    dapview.setup({
      winbar = {
        sections = {
          "watches",
          "scopes",
          "breakpoints",
          "repl",
--          "disassembly",
        },
      },
      windows = {
        terminal = {
          start_hidden = false,
        },
      },
    })

    dap.listeners.after.event_initialized["dap-view"] = function() dapview.open() end
    dap.listeners.before.event_terminated["dap-view"] = function() dapview.close() end
    dap.listeners.before.event_exited["dap-view"] = function() dapview.close() end

-- 3. AUTOMATION: Open Layout on Start
    dap.listeners.after.event_initialized["custom_layout"] = function()
        -- We assume focus is on Source, so this creates: [Source] | [Disassembly]
        vim.cmd("DapDisasm")

        -- Force it to be a vertical split to the right of source
        -- (If it opens horizontally by default, we move it)
        vim.cmd("wincmd L")
        vim.cmd("vertical resize 60")

        -- We schedule this to ensure the UI is settled before splitting
        vim.schedule(function()
            -- A. Open the Sidebar (Far Right)
            dapview.open()
        end)
    end

    -- Close both on exit
    dap.listeners.before.event_terminated["custom_layout"] = function()
        dapview.close()
        -- We must manually close the disassembly window if it's separate
        -- (Optional: dap-disasm often closes itself, but this is safer)
        for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.api.nvim_buf_get_name(buf):match("Disassembly") then
                vim.api.nvim_win_close(win, true)
            end
        end
    end

    -- Link the exited listener to the same function
    dap.listeners.before.event_exited["custom_layout"] = dap.listeners.before.event_terminated["custom_layout"]

    dap.adapters.codelldb = {
      type = "server",
      port = "${port}",
      executable = {
        command = "codelldb",
        args = { "--port", "${port}" },
      },
    }

    -- mason-nvim-dap setup for common adapters
    require("mason-nvim-dap").setup({
      ensure_installed = {
        "codelldb",        -- C / C++ / Rust
        "debugpy",         -- Python
        "js-debug-adapter", -- TS / JS / Deno
      },
      automatic_installation = true,
    })

    -- 2. C/C++ CONFIGURATION
    dap.configurations.c = {
      {
        name = "Launch with CodeLLDB",
        type = "codelldb",
        request = "launch",
        program = function()
          return vim.fn.input('Exe: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        console = "integratedTerminal",
        args = function()
          local input = vim.fn.input('Args: ')
          return vim.split(input, " ", true)
        end,

        -- Auto-breakpoint at main
        initCommands = function()
          return { "breakpoint set --name main" }
        end,
      },
    }
    dap.configurations.cpp = dap.configurations.c
    dap.configurations.rust = dap.configurations.c

    -- Deno TypeScript configuration (via js-debug / pwa-node)
    dap.configurations.typescript = {
      {
        name = "Deno: Launch current file",
        type = "pwa-node",
        request = "launch",
        program = "${file}",
        cwd = "${workspaceFolder}",
        runtimeExecutable = "deno",
        runtimeArgs = {
          "run",
          "--inspect-brk",
          "--allow-all",
        },
        attachSimplePort = 9229,
      },
    }
    dap.configurations.javascript = dap.configurations.typescript

    -- NOTE: Rustaceanvim handles the Rust DAP automatically!
    -- You do NOT need to configure Rust here.

    -- Keymaps
    local map = vim.keymap.set

    -- Function keys (keep these for muscle memory)
    map("n", "<F5>",  function() dap.continue()  end, { desc = "Debug: Continue" })
    map("n", "<F10>", function() dap.step_over() end, { desc = "Debug: Step Over" })
    map("n", "<F11>", function() dap.step_into() end, { desc = "Debug: Step Into" })
    map("n", "<F12>", function() dap.step_out()  end, { desc = "Debug: Step Out" })

    -- <leader>d... layout
    map("n", "<leader>dc", function() dap.continue()    end, { desc = "Debug: Continue" })
    map("n", "<leader>do", function() dap.step_over()   end, { desc = "Debug: Step Over" })
    map("n", "<leader>di", function() dap.step_into()   end, { desc = "Debug: Step Into" })
    map("n", "<leader>dO", function() dap.step_out()    end, { desc = "Debug: Step Out" })

    map("n", "<leader>db", function() dap.toggle_breakpoint() end, { desc = "Debug: Breakpoint" })
    map("n", "<leader>dB", function()
      dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
    end, { desc = "Debug: Conditional Breakpoint" })

--    map("n", "<leader>du", function() dapui.toggle() end, { desc = "Debug: Toggle UI" })
    map("n", "<leader>dv", function() dapview.toggle() end, { desc = "Debug: Toggle View" })

    -- Deno quick-launch
    map("n", "<leader>dD", function()
      dap.run(dap.configurations.typescript[1])
    end, { desc = "Debug: Deno (current file)" })
   end,
}

