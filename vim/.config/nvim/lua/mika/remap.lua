local nnoremap = require("mika.keymap").nnoremap
local inoremap = require("mika.keymap").inoremap
local vnoremap = require("mika.keymap").vnoremap

nnoremap("<leader>pv", "<cmd>Ex<Cr>")
nnoremap("<leader>b", "<cmd>ls<Cr>")
nnoremap("<leader>ls", "<cmd>ls<Cr>")
nnoremap("<leader>#", "<cmd>b#<Cr>")

-- Telescope bindings
nnoremap("<leader>ff", "<cmd>Telescope find_files<Cr>")
nnoremap("<leader>fg", "<cmd>Telescope live_grep<Cr>")
nnoremap("<leader>fb", "<cmd>Telescope buffers<Cr>")
nnoremap("<leader>fh", "<cmd>Telescope help_tags<Cr>")

-- Copy to clipboard
vnoremap("<leader>c", '"+y')

-- Python-specific commenting and uncommenting
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "python", "yaml" },
    callback = function()
        local vnoremap = require("mika.keymap").vnoremap
        -- Comment selected lines
        vnoremap("<leader>/", ":s/^/# /<CR>:noh<CR>", { buffer = true })
        -- Uncomment selected lines
        vnoremap("<leader>u/", ":s/^# //<CR>:noh<CR>", { buffer = true })
    end,
})
