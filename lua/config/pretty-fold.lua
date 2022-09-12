require('pretty-fold').setup {
	keep_indentation = false,
	fill_char = '━',
	sections = {
		left = {
			'━ ', function()
				return string.rep('*', vim.v.foldlevel)
			end, ' ━┫', 'content', '┣'
		},
		right = { '┫ ', 'number_of_folded_lines', ': ', 'percentage', ' ┣━━' }
	}
}

require('fold-preview').setup {
	border = "rounded"
}

local keymap = vim.keymap
keymap.amend = require('keymap-amend')
local map = require('fold-preview').mapping

keymap.amend('n', 'h',  map.show_close_preview_open_fold)
