-- ==========================================
-- PLUGIN CONFIGURATIONS
-- ==========================================

-- UI: Theme
vim.cmd.colorscheme("catppuccin-mocha")

-- UI: Lualine
require("lualine").setup({
    options = {
        theme = "catppuccin-mocha",
        globalstatus = true,
        component_separators = { left = '', right = ''},
        section_separators = { left = '', right = ''},
    }
})

-- UI: Notifications & Messages (Noice & Notify)
require("notify").setup({
    background_colour = "#000000",
})
vim.notify = require("notify")

require("noice").setup({
    lsp = {
        override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
        },
    },
    presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = false,
    },
})

-- UI: Dashboard (alpha-nvim)
local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

dashboard.section.header.val = {
    "                                                     ",
    "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
    "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
    "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
    "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
    "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
    "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
    "                                                     ",
    "                [ DEVELOP. COMPETE. WIN. ]           ",
    "                                                     ",
}

dashboard.section.buttons.val = {
    dashboard.button("c", "  New CP Workspace", ":e solution.cpp <CR> | :vsplit input.txt <CR> | :wincmd h <CR>"),
    dashboard.button("f", "  Find file", ":Telescope find_files <CR>"),
    dashboard.button("r", "  Recent files", ":Telescope oldfiles <CR>"),
    dashboard.button("g", "󰊄  Live grep", ":Telescope live_grep <CR>"),
    dashboard.button("s", "  Settings", ":e ~/.config/nvim/init.lua <CR>"),
    dashboard.button("q", "󰅙  Quit", ":qa<CR>"),
}

-- Align the dashboard centrally and add some highlight groups
dashboard.section.header.opts.hl = "Include"
dashboard.section.buttons.opts.hl = "Keyword"

-- Calculate dynamic top padding to vertically center the dashboard
dashboard.opts.layout[1].val = function()
    -- Header (10) + Padding (2) + Buttons (6) = ~18 lines of content
    local content_height = 18
    local padding = math.floor((vim.o.lines - content_height) / 2)
    return math.max(0, padding - 2) -- Subtract a little for the statusline/cmdline
end

alpha.setup(dashboard.opts)

-- UI: Better Inputs
require("dressing").setup()

-- UI: Indent Guides
local hooks = require "ibl.hooks"
require("ibl").setup()

-- Tools: WhichKey
local wk = require("which-key")
wk.setup({
    win = {
        border = "rounded",
        padding = { 1, 2 },
        col = -1, -- Align to the right
        row = -1, -- Align to the bottom
        width = { min = 20, max = 50 },
        height = { min = 4, max = 15 },
    },
    layout = {
        align = "left",
    },
})

-- Register logical groups for Which-Key
wk.add({
  { "<leader>c", group = "Code / CP" },
  { "<leader>f", group = "File / Find" },
  { "<leader>s", group = "Split Window" },
  { "<leader>m", group = "Formatting" },
  { "<leader>r", group = "Refactor" },
  { "<leader>d", group = "Document (LSP)" },
})

-- Tools: GitSigns
require("gitsigns").setup()

-- Tools: Oil (File Explorer)
require("oil").setup({
    view_options = { show_hidden = true },
    keymaps = {
        ["<C-c>"] = false,
        ["q"] = "actions.close",
    }
})
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
vim.keymap.set("n", "<leader>e", "<CMD>Oil<CR>", { desc = "Open File Explorer" })

-- Tools: Telescope
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find Files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live Grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find Buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help Tags" })

-- Syntax: Treesitter
require("nvim-treesitter.configs").setup({
    ensure_installed = { "c", "cpp", "go", "python", "rust", "nix", "lua", "vim", "vimdoc" },
    sync_install = false,
    auto_install = true,
    highlight = { enable = true, additional_vim_regex_highlighting = false },
    indent = { enable = true },
})

-- Formatting: Conform
require("conform").setup({
    formatters_by_ft = {
        lua = { "stylua" },
        python = { "isort", "black" },
        cpp = { "clang-format" },
        c = { "clang-format" },
        go = { "gofmt", "goimports" },
        rust = { "rustfmt" },
        nix = { "nixfmt" },
    },
    format_on_save = {
        timeout_ms = 2500,
        lsp_fallback = true,
    },
})
vim.keymap.set({ "n", "v" }, "<leader>mp", function()
    require("conform").format({ lsp_fallback = true, async = false, timeout_ms = 2500 })
end, { desc = "Format file or range" })

-- ==========================================
-- LSP & COMPLETION CONFIGURATION
-- ==========================================

local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Apply capabilities globally to all LSP servers
vim.lsp.config('*', {
    capabilities = capabilities,
})

-- On Attach function for setting up LSP keymaps
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = ev.buf, desc = "LSP: " .. desc })
        end

        map("gd", require("telescope.builtin").lsp_definitions, "Goto Definition")
        map("gr", require("telescope.builtin").lsp_references, "Goto References")
        map("gI", require("telescope.builtin").lsp_implementations, "Goto Implementation")
        map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type Definition")
        map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "Document Symbols")
        map("<leader>rn", vim.lsp.buf.rename, "Rename")
        map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
        map("K", vim.lsp.buf.hover, "Hover Documentation")
        map("gD", vim.lsp.buf.declaration, "Goto Declaration")
    end,
})

-- C/C++ (clangd)
vim.lsp.config('clangd', {
    cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--header-insertion=iwyu",
        "--completion-style=detailed",
        "--function-arg-placeholders",
        "--fallback-style=llvm",
    },
})
vim.lsp.enable('clangd')

-- Go (gopls)
vim.lsp.config('gopls', {
    settings = {
        gopls = {
            analyses = {
                unusedparams = true,
                shadow = true,
            },
            staticcheck = true,
            gofumpt = true,
            usePlaceholders = true,
            completeUnimported = true,
            matcher = "Fuzzy",
            semanticTokens = true,
        },
    },
})
vim.lsp.enable('gopls')

-- Python (pyright)
vim.lsp.enable('pyright')

-- Nix (nil_ls)
vim.lsp.enable('nil_ls')

-- Lua (lua_ls)
vim.lsp.config('lua_ls', {
    settings = {
        Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = { library = vim.api.nvim_get_runtime_file("", true) },
            telemetry = { enable = false },
        },
    },
})
vim.lsp.enable('lua_ls')

-- Completion (nvim-cmp)
local cmp = require("cmp")
local luasnip = require("luasnip")

-- Load snippets from friendly-snippets
require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-j>"] = cmp.mapping.select_next_item(),
        ["<C-k>"] = cmp.mapping.select_prev_item(),
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        
        -- Super-tab behavior
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
    }),
    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
    }, {
        { name = "buffer" },
        { name = "path" },
    })
})

-- ==========================================
-- POWER USER & CP FEATURES
-- ==========================================

-- 1. Auto-Pairs
require("nvim-autopairs").setup({
    check_ts = true, -- use treesitter to check for a pair
})
-- Integrate autopairs with cmp
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())

-- 2. Flash (Navigation)
require("flash").setup()
vim.keymap.set({"n", "x", "o"}, "s", function() require("flash").jump() end, { desc = "Flash" })
vim.keymap.set({"n", "x", "o"}, "S", function() require("flash").treesitter() end, { desc = "Flash Treesitter" })

-- 3. Competitest (CP Automation)
require("competitest").setup({
    compile_command = {
        cpp = { exec = "g++", args = { "-O2", "-Wall", "-Wextra", "-std=c++20", "$(FNAME)", "-o", "$(FNOEXT)" } },
        rust = { exec = "rustc", args = { "$(FNAME)" } },
        go = { exec = "go", args = { "build", "-o", "$(FNOEXT)", "$(FNAME)" } },
    },
    run_command = {
        cpp = { exec = "./$(FNOEXT)" },
        rust = { exec = "./$(FNOEXT)" },
        go = { exec = "./$(FNOEXT)" },
        python = { exec = "python3", args = { "$(FNAME)" } },
    },
})
-- Register Competitest keymaps in which-key
wk.add({
  { "<leader>t", group = "Competitest (Tests)" },
  { "<leader>tr", "<cmd>CompetiTest run<CR>", desc = "Run Test Cases" },
  { "<leader>ta", "<cmd>CompetiTest add_testcase<CR>", desc = "Add Test Case" },
  { "<leader>te", "<cmd>CompetiTest edit_testcase<CR>", desc = "Edit Test Case" },
  { "<leader>td", "<cmd>CompetiTest delete_testcase<CR>", desc = "Delete Test Case" },
  { "<leader>ti", "<cmd>CompetiTest receive testcases<CR>", desc = "Download Test Cases" },
})

-- 4. Debugging (DAP + UI)
local dap = require("dap")
local dapui = require("dapui")
dapui.setup()

dap.listeners.before.attach.dapui_config = function() dapui.open() end
dap.listeners.before.launch.dapui_config = function() dapui.open() end
dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

wk.add({
  { "<leader>b", group = "Debugger" },
  { "<leader>bb", function() dap.toggle_breakpoint() end, desc = "Toggle Breakpoint" },
  { "<leader>bc", function() dap.continue() end, desc = "Continue / Start" },
  { "<leader>bi", function() dap.step_into() end, desc = "Step Into" },
  { "<leader>bo", function() dap.step_over() end, desc = "Step Over" },
  { "<leader>bu", function() dapui.toggle() end, desc = "Toggle UI" },
})

-- 5. Terminal Manager (ToggleTerm)
require("toggleterm").setup({
    size = 20,
    open_mapping = [[<c-\>]],
    hide_numbers = true,
    shade_terminals = true,
    shading_factor = 2,
    start_in_insert = true,
    insert_mappings = true,
    persist_size = true,
    direction = "float",
    close_on_exit = true,
    shell = vim.o.shell,
    float_opts = {
        border = "curved",
        winblend = 0,
    },
})

-- 6. Session Management (Auto-Session)
require("auto-session").setup({
    log_level = "error",
    auto_session_suppress_dirs = { "~/", "~/Downloads", "/", "/tmp" },
    auto_save_enabled = true,
    auto_restore_enabled = true,
})

-- 7. Git UI (LazyGit)
wk.add({
  { "<leader>g", group = "Git" },
  { "<leader>gg", "<cmd>LazyGit<CR>", desc = "LazyGit UI" },
})

-- ==========================================
-- VISUALS & DIAGNOSTICS
-- ==========================================

-- 8. Icons
require("nvim-web-devicons").setup({
    color_icons = true,
    default = true,
})

-- 9. Bufferline (Tabs)
require("bufferline").setup({
    options = {
        mode = "buffers",
        separator_style = "slant",
        diagnostics = "nvim_lsp",
        offsets = {
            {
                filetype = "oil",
                text = "File Explorer",
                highlight = "Directory",
                separator = true
            }
        },
    }
})
-- Navigate tabs with Shift-H and Shift-L
vim.keymap.set("n", "<S-h>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Previous Tab" })
vim.keymap.set("n", "<S-l>", "<cmd>BufferLineCycleNext<CR>", { desc = "Next Tab" })
vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Close Current Tab" })

-- 10. Trouble (Error Dashboard)
require("trouble").setup({
    modes = {
        diagnostics = {
            auto_close = true,
        },
    },
})
wk.add({
  { "<leader>x", group = "Diagnostics (Trouble)" },
  { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Project Diagnostics" },
  { "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Document Diagnostics" },
  { "<leader>xl", "<cmd>Trouble loclist toggle<cr>", desc = "Location List" },
  { "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List" },
})

-- ==========================================
-- GO SPECIFIC CONFIGURATION
-- ==========================================

-- 11. Go Toolkit (go.nvim)
require("go").setup({
    lsp_cfg = false, -- We already configured gopls manually above
    lsp_keymaps = false, -- We already have our own LSP keymaps
    lsp_inlay_hints = { enable = false }, -- Built-in inlay hints can be noisy
})

wk.add({
  { "<leader>c", group = "Code / CP" },
  { "<leader>cj", "<cmd>GoAddTag<CR>", desc = "Add JSON Tags (Go)" },
  { "<leader>cy", "<cmd>GoAddTag yaml<CR>", desc = "Add YAML Tags (Go)" },
  { "<leader>cf", "<cmd>GoFillStruct<CR>", desc = "Fill Struct (Go)" },
  { "<leader>ce", "<cmd>GoIfErr<CR>", desc = "Generate if err != nil (Go)" },
  { "<leader>ct", "<cmd>GoTest<CR>", desc = "Run Go Tests" },
})

-- 12. Go Debugging (dap-go)
require("dap-go").setup()
wk.add({
  { "<leader>b", group = "Debugger" },
  { "<leader>bt", function() require("dap-go").debug_test() end, desc = "Debug Go Test" },
  { "<leader>bl", function() require("dap-go").debug_last_test() end, desc = "Debug Last Go Test" },
})

-- ==========================================
-- RUST SPECIFIC CONFIGURATION
-- ==========================================

-- 13. Rust Toolkit (rustaceanvim)
vim.g.rustaceanvim = {
  server = {
    default_settings = {
      ['rust-analyzer'] = {
        cargo = { allFeatures = true },
        checkOnSave = { command = "clippy" },
      },
    },
  },
}

wk.add({
  { "<leader>c", group = "Code / CP" },
  { "<leader>ca", "<cmd>RustLsp codeAction<CR>", desc = "Code Action (Rust)" },
  { "<leader>cr", "<cmd>RustLsp runnables<CR>", desc = "Run/Test (Rust)" },
  { "<leader>cd", "<cmd>RustLsp debuggables<CR>", desc = "Debug (Rust)" },
  { "<leader>ch", "<cmd>RustLsp hover actions<CR>", desc = "Hover Actions (Rust)" },
})
