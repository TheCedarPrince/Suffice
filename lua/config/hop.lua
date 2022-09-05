require'hop'.setup{
	quit_key = '<ESC>',
	jump_on_sole_occurrence = true,
	case_insensitive = true,
	multi_windows = true,
}

-- HopLineStart
vim.api.nvim_set_keymap('n', '<C-h>l', "<cmd>lua require'hop'.hint_lines_skip_whitespace()<cr>", {})

-- HopWord
vim.api.nvim_set_keymap('n', '<C-h>w', "<cmd>lua require'hop'.hint_words()<cr>", {})

-- HopChar1
vim.api.nvim_set_keymap('n', '<C-h>c', "<cmd>lua require'hop'.hint_char1()<cr>", {})

-- HopPattern
vim.api.nvim_set_keymap('n', '<C-h>p', "<cmd>lua require'hop'.hint_patterns()<cr>", {})
