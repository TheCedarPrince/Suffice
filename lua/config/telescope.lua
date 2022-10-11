local themes = require("telescope.themes")

function themes.thick(opt)
	return {
		winblend = 20;
		width = 0.8;
		show_line = false;
		prompt_prefix = '>';
		prompt_title = '';
		results_title = '';
		preview_title = '';
		borderchars = {
			prompt = { '▀', '▐', '▄', '▌', '▛', '▜', '▟', '▙' };
			results = { '▀', '▐', '▄', '▌', '▛', '▜', '▟', '▙' };
			preview = { '▀', '▐', '▄', '▌', '▛', '▜', '▟', '▙' };
		}
	}
end

require('telescope').setup {
	defaults = {
		-- Default configuration for telescope goes here:
		-- config_key = value,
		mappings = {}
	},
	extensions = {
		-- Your extension configuration goes here:
		-- extension_name = {
		--   extension_config_key = value,
		-- }
		-- please take a look at the readme of the extension you want to configure
	}
}

-- require('telescope').load_extension('neoclip')

function map(mode, bind, action)
	vim.api.nvim_set_keymap(mode, bind, action .. "<cr>", { noremap = true, silent = true });
end

map('n', '<C-s>', ':Telescope live_grep')
map('i', '<C-s>', ':Telescope live_grep')
