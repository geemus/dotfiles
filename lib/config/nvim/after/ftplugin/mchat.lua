vim.opt_local.wrap = true -- wrap lines

-- follow md links
local nvim_buf_set_keymap = vim.api.nvim_buf_set_keymap
nvim_buf_set_keymap(0, 'n', '<cr>', ':lua require("follow-md-links").follow_link()<cr>', {noremap = true, silent = true})
