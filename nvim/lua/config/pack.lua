-- ==========================================
-- BUILT-IN PACK MANAGER WRAPPER
-- ==========================================
local pack_path = vim.fn.stdpath("data") .. "/site/pack/plugins/start/"

local plugins = {
    -- Core & Dependencies
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    
    -- UI & Experience
    "catppuccin/nvim",
    "nvim-lualine/lualine.nvim",
    "goolord/alpha-nvim",
    "rcarriga/nvim-notify",
    "MunifTanjim/nui.nvim",
    "folke/noice.nvim",
    "stevearc/dressing.nvim",
    "lukas-reineke/indent-blankline.nvim",
    
    -- LSP & Completion
    "neovim/nvim-lspconfig",
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    "rafamadriz/friendly-snippets",
    
    -- Syntax & Formatting
    "nvim-treesitter/nvim-treesitter@master",
    "stevearc/conform.nvim",
    
    -- Tools
    "nvim-telescope/telescope.nvim",
    "stevearc/oil.nvim",
    "lewis6991/gitsigns.nvim",
    "folke/which-key.nvim",
    
    -- Power User & Workflow
    "tpope/vim-sleuth", -- Auto-detect indent (2 or 4 spaces)
    "windwp/nvim-autopairs",
    "folke/flash.nvim",
    "xeluxee/competitest.nvim",
    "mfussenegger/nvim-dap",
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    "akinsho/toggleterm.nvim",
    "kdheepak/lazygit.nvim",
    "rmagatti/auto-session",

    -- Visuals & Diagnostics
    "nvim-tree/nvim-web-devicons",
    "akinsho/bufferline.nvim",
    "folke/trouble.nvim",
    
    -- Language Specific (Go & Rust)
    "ray-x/go.nvim",
    "ray-x/guihua.lua",
    "leoluz/nvim-dap-go",
    "mrcjkb/rustaceanvim",
}

-- Ensure Plugins are Cloned and Loaded
local is_first_install = false

for _, repo_info in ipairs(plugins) do
    local repo, branch = repo_info:match("^([^@]+)@?(.*)$")
    local name = repo:match(".*/(.*)")
    if name == "nvim" and repo == "catppuccin/nvim" then name = "catppuccin" end
    local path = pack_path .. name
    
    if vim.fn.isdirectory(path) == 0 then
        print("Cloning " .. name .. "...")
        local cmd = { "git", "clone", "--depth", "1", "https://github.com/" .. repo, path }
        if branch ~= "" then
            table.insert(cmd, 3, "-b")
            table.insert(cmd, 4, branch)
        end
        vim.fn.system(cmd)
        is_first_install = true
    end
end

if is_first_install then
    print("Plugins installed! Restart Neovim or run :TSUpdate for full effect.")
    return
end
