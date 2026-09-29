-- GitHub Copilot (github/copilot.vim)
--
-- <Tab> is already bound to coc completion in lua/mika/init.lua, and copilot's
-- default is also <Tab> — so disable copilot's Tab map and accept suggestions
-- with <C-l> instead (free in insert mode; <C-j> is taken by coc-snippets).
vim.g.copilot_no_tab_map = true

-- Accept the current suggestion. Fallback is empty, so <C-l> is a no-op when
-- there's no suggestion. replace_keycodes=false per copilot.vim's docs.
vim.keymap.set("i", "<C-l>", 'copilot#Accept("")', {
  expr = true,
  replace_keycodes = false,
  silent = true,
  desc = "Copilot: accept suggestion",
})

-- Partial accepts (suggestion is still shown until accepted/dismissed).
vim.keymap.set("i", "<C-;>", "<Plug>(copilot-accept-word)", { desc = "Copilot: accept word" })
vim.keymap.set("i", "<C-'>", "<Plug>(copilot-accept-line)", { desc = "Copilot: accept line" })

-- Cycle suggestions (copilot's built-in <M-]>/<M-[> also still work) and dismiss.
vim.keymap.set("i", "<M-]>", "<Plug>(copilot-next)", { desc = "Copilot: next suggestion" })
vim.keymap.set("i", "<M-[>", "<Plug>(copilot-previous)", { desc = "Copilot: previous suggestion" })
vim.keymap.set("i", "<C-]>", "<Plug>(copilot-dismiss)", { desc = "Copilot: dismiss" })

-- If nvim is launched without nvm on PATH, uncomment to pin copilot's Node:
-- vim.g.copilot_node_command = vim.fn.expand("~/.nvm/versions/node/v22.15.0/bin/node")
