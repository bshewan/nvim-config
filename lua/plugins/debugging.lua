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
    keys = {
        -- Function keys
        { "<F5>",  function() require("dap").continue() end,        desc = "Debug: Continue" },
        { "<F10>", function() require("dap").step_over() end,      desc = "Debug: Step Over" },
        { "<F11>", function() require("dap").step_into() end,      desc = "Debug: Step Into" },
        { "<F12>", function() require("dap").step_out() end,       desc = "Debug: Step Out" },

        -- <leader>d... layout
        { "<leader>dc", function() require("dap").continue() end,  desc = "Debug: Continue" },
        { "<leader>do", function() require("dap").step_over() end, desc = "Debug: Step Over" },
        { "<leader>di", function() require("dap").step_into() end, desc = "Debug: Step Into" },
        { "<leader>dO", function() require("dap").step_out() end,  desc = "Debug: Step Out" },

        { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Debug: Breakpoint" },
        { "<leader>dB", function()
            require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end,
            desc = "Debug: Conditional Breakpoint",
        },

        { "<leader>dv", function() require("dap-view").toggle() end, desc = "Debug: Toggle View" },
        { "<leader>dW", function() require("dap-view").show_view('watches') end, desc = "Debug: Show Watches" },
        { "<leader>dC", function() require("dap-view").show_view('console') end, desc = "Debug: Show Console" },
        { "<leader>dD", function() require("dap-view").show_view('disassembly') end, desc = "Debug: Show Disassembly" },
        { "<leader>dR", function() require("dap-view").show_view('repl') end, desc = "Debug: Show REPL" },
        { "<leader>dS", function() require("dap-view").show_view('scopes') end, desc = "Debug: Show Scopes" },

        -- Close DAP integrated terminal(s) from source window                                                                   █
        { "<leader>dt", function()
            -- Remember where you are (source window)
            local source_win = vim.api.nvim_get_current_win()

            -- Close all terminal windows in this tabpage
            for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
                local buf = vim.api.nvim_win_get_buf(win)
                if vim.bo[buf].buftype == "terminal" then
                    pcall(vim.api.nvim_win_close, win, true)
                end
            end

            -- Restore focus to the source window if it still exists
            if vim.api.nvim_win_is_valid(source_win) then
                vim.api.nvim_set_current_win(source_win)
            end
        end,
            desc = "Debug: Close DAP terminal",
        },
    },
    config = function()
        local dap = require("dap")
        -- local dapui = require("dapui")
        local dapview = require("dap-view")
        local vtext = require("nvim-dap-virtual-text")

        vtext.setup({
            display_callback = function(variable, _, _, _, options)
                if options.virt_text_pos == 'inline' then
                    return ' = ' .. variable.value
                else
                    return variable.name .. ' = ' .. variable.value
                end
            end,
        })

        -- dapui.setup()

        -- Auto-open UI (disabled)
        -- dap.listeners.before.attach.dapui_config = function() dapui.open() end
        -- dap.listeners.before.launch.dapui_config = function() dapui.open() end
        -- dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
        -- dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

        require("dap-disasm").setup({
            -- Optional settings
            show_registers = true,
            show_instructions = true,
            instruction_count = 10,
        })

        -- DAP View setup
        dapview.setup({
            winbar = {
                sections = {
                    "console",
                    "watches",
                    "scopes",
                    "breakpoints",
                    "repl",
                    "disassembly",
                },
                default_section = "console",
            },
            windows = {
                position = "right",
                terminal = {
                    start_hidden = false,
                },
            },
        })

        -- Only auto-close dap-view; open it manually with <leader>dv
        dap.listeners.after.event_initialized["dap-view"] = function() dapview.open() end
        dap.listeners.before.event_terminated["dap-view"] = function() dapview.close() end
        dap.listeners.before.event_exited["dap-view"] = function() dapview.close() end

        --------------------------------------------------------------------
        -- Adapters & configurations
        --------------------------------------------------------------------
        dap.adapters.codelldb = {
            type = "server",
            port = "${port}",
            executable = {
                command = "codelldb",
                args = { "--port", "${port}" },
            },
        }

        dap.adapters.gdb = {
            type = "executable",
            command = "gdb",
            args = { "-i", "dap" },
        }

        dap.adapters.cppdbg = {
            id = "cppdbg",
            type = "executable",
            command = vim.fn.stdpath("data") .. "/mason/bin/OpenDebugAD7",
            options = {
                detached = false,
            },
        }

        -- mason-nvim-dap setup for common adapters
        require("mason-nvim-dap").setup({
            ensure_installed = {
                "codelldb",         -- C / C++ / Rust
                "debugpy",          -- Python
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
                    local default_path = vim.fn.getcwd() .. '/bin/program'
                    local input = vim.fn.input('Exe: ', vim.fn.getcwd() .. '/', 'file')

                    if (input == vim.fn.getcwd() .. '/') or (input == "") then
                        return default_path
                    end
                    return input
                end,
                cwd = '${workspaceFolder}',
                stopOnEntry = false,
                console = "integratedTerminal",
                args = function()
                    local input = vim.fn.input('Args: ')
                    return vim.split(input, " ", {plain = true})
                end,

                -- Auto-breakpoint at main
                initCommands = function()
                    return { "breakpoint set --name main" }
                end,
            },
            {
                name = "Launch with GDB",
                type = "cppdbg",
                request = "launch",
                program = function()
                    local default_path = vim.fn.getcwd() .. '/bin/program'
                    local input = vim.fn.input('Exe: ', vim.fn.getcwd() .. '/', 'file')

                    if (input == vim.fn.getcwd() .. '/') or (input == "") then
                        return default_path
                    end
                    return input
                end,
                cwd = '${workspaceFolder}',
                stopAtEntry = true,
                args = function()
                    local input = vim.fn.input('Args: ')
                    return vim.split(input, " ", {plain = true})
                end,
                MIMode = "gdb",
                miDebuggerPath = "/usr/bin/gdb",
                setupCommands = {
                    {
                        text = "-enable-pretty-printing",
                        description = "enable pretty printing",
                        ignoreFailures = false,
                    },
                },
            },
            {
                name = "Attach to GDBserver",
                type = "gdb",
                request = "attach",
                target = "localhost:1234",
                program = function()
                    local default_path = vim.fn.getcwd() .. '/bin/program'
                    local input = vim.fn.input('Exe: ', vim.fn.getcwd() .. '/', 'file')

                    if (input == vim.fn.getcwd() .. '/') or (input == "") then
                        return default_path
                    end
                    return input
                end,
                cwd = '${workspaceFolder}',
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
    end,
}
