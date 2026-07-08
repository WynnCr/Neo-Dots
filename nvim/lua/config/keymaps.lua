vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.keymap.set

-- General Keymaps
map("i", "jj", "<ESC>", { desc = "Exit insert mode" })
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear highlights" })

-- Window Navigation
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })
map("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
map("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
map("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })

-- Better Indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Move lines up/down
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")
-- Move selected lines down
map("v", "<A-j>", ":m '>+1<CR>gv=gv")

-- Move selected lines up
map("v", "<A-k>", ":m '<-2<CR>gv=gv")

-- Terminal Escape
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- ==========================================
-- COMPETITIVE PROGRAMMING (CP) KEYMAPS
-- ==========================================

-- Function to get standard executable name
local function get_exec_name()
    local dir = vim.fn.expand("%:p:h")
    local no_ext = vim.fn.expand("%:t:r")
    return dir .. "/" .. no_ext
end

-- Compile Code
map("n", "<F5>", function()
    vim.cmd("w") -- Save current file
    local file = vim.fn.expand("%")
    local ext = vim.fn.expand("%:e")
    local exec_path = get_exec_name()
    
    if ext == "cpp" or ext == "cc" or ext == "cxx" then
        print("Compiling C++...")
        vim.cmd("!g++ -O2 -Wall -Wextra -std=c++20 " .. file .. " -o " .. exec_path)
    elseif ext == "go" then
        print("Compiling Go...")
        vim.cmd("!go build -o " .. exec_path .. " " .. file)
    elseif ext == "py" then
        print("Python does not need compilation! Press F6 to run.")
    else
        print("Not a supported CP language!")
    end
end, { desc = "Compile File (CP)" })

-- Run Code with Split Terminal
map("n", "<F6>", function()
    local ext = vim.fn.expand("%:e")
    local file = vim.fn.expand("%:p")
    local exec_path = get_exec_name()
    
    -- Open vertical split and terminal
    vim.cmd("vsplit")
    vim.cmd("terminal")
    vim.cmd("startinsert") -- Enter insert mode for the terminal
    
    local term_chan = vim.b.terminal_job_id
    
    if ext == "cpp" or ext == "cc" or ext == "cxx" or ext == "go" then
        vim.fn.chansend(term_chan, exec_path .. "\\n")
    elseif ext == "py" then
        vim.fn.chansend(term_chan, "python3 " .. file .. "\\n")
    end
end, { desc = "Run File in Terminal (CP)" })

-- Open/Create Input.txt
map("n", "<leader>ci", function()
    local dir = vim.fn.expand("%:p:h")
    vim.cmd("vsplit " .. dir .. "/input.txt")
end, { desc = "Open input.txt (CP)" })
