local fn = vim.fn

vim.g.package_home = fn.stdpath("data") .. "/site/pack/packer/"
local packer_install_dir = vim.g.package_home .. "/opt/packer.nvim"

local plug_url_format = ""
if vim.g.is_linux then
	plug_url_format = "https://hub.fastgit.org/%s"
else
	plug_url_format = "https://github.com/%s"
end

local packer_repo = string.format(plug_url_format, "wbthomason/packer.nvim")
local install_cmd = string.format("10split |term git clone --depth=1 %s %s", packer_repo, packer_install_dir)

-- Auto-install packer in case it hasn't been installed.
if fn.glob(packer_install_dir) == "" then
	vim.api.nvim_echo({ { "Installing packer.nvim", "Type" } }, true, {})
	vim.cmd(install_cmd)
end

-- Load packer.nvim
vim.cmd("packadd packer.nvim")

return require('packer').startup(function(use)

	----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- SECTION: User Interface Plugins
	-- DESC: Plugins which modify the user interface like themes, statuslines, tablines, and buffers.
	----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	-- A theme for vim and neovim [CONFIGURED]
	use { 'EdenEast/nightfox.nvim', config = [[require('config.nightfox')]] }

	-- Lua statusline
	use {
		'nvim-lualine/lualine.nvim',
		config = [[require('config.lualine')]],
		requires = { 'kyazdani42/nvim-web-devicons', opt = true }
	}

	-- Utilities for pretty tabs [CONFIGURED]
	use { 'gcmt/taboo.vim', config = [[require('config.taboo')]], requires = { 'ryanoasis/vim-devicons', opt = true } }

	use { 'preservim/vim-pencil' } -- , config = [[require('config.vim-pencil')]] }

	use { 'Pocco81/true-zen.nvim', config = [[require('config.true-zen')]] }

	use { 'voldikss/vim-floaterm' }
	-- TODO: Add keymaps to this

	use { 'tpope/vim-obsession' }
	-- TODO: Add obsession symbol to lualine


	use {
		'lewis6991/gitsigns.nvim',
		config = [[require('config.gitsigns')]]
	}




	----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- SECTION: Markup and Language Specific Plugins
	-- DESC: Plugin groups which are specific to a given language or markup
	----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	------------------------------------------------------------------------------------------------
	-- SUBSECTION: Julia
	-- DESC: Plugins for Julia specific usage
	------------------------------------------------------------------------------------------------

	-- Apparently this causes issues with Julia LSP
	-- TODO: Move to graveyard
	-- use { 'JuliaEditorSupport/julia-vim' }

	------------------------------------------------------------------------------------------------
	-- SUBSECTION: Markdown
	-- DESC: Plugins for Markdown specific usage and its derivatives (pandoc, commonmark, etc.)
	------------------------------------------------------------------------------------------------

	-- Preview markdown within a browser!
	-- WARN: See: https://github.com/iamcco/markdown-preview.nvim/issues/424
	use {
		'iamcco/markdown-preview.nvim',
		run = function() vim.fn['mkdp#util#install']() end,
		ft = { 'markdown', 'pandoc' }
	}

	use { 'vim-pandoc/vim-pandoc' }

	use { 'vim-pandoc/vim-pandoc-syntax', config = [[require('config.vim-pandoc-syntax')]]}

	use { 'dhruvasagar/vim-table-mode' }

	------------------------------------------------------------------------------------------------
	-- SUBSECTION: Todo.txt
	-- DESC: Plugins to support the todo.txt specification
	------------------------------------------------------------------------------------------------

	use { 'dbeniamine/todo.txt-vim' }

	------------------------------------------------------------------------------------------------
	-- SUBSECTION: R
	-- DESC: Plugins for R specific usage
	------------------------------------------------------------------------------------------------

	use { 'jalvesaq/Nvim-R' }

	----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- SECTION: Navigation
	-- DESC: Plugins which improve overall navigation through files, buffers, and the file system
	----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	-- TODO: Configure Telescope
	use {
		'nvim-telescope/telescope.nvim',
		requires = { { 'nvim-lua/plenary.nvim' } }
	}

	-- TODO: Add Trouble: https://github.com/folke/trouble.nvim

	use {
		'nvim-treesitter/nvim-treesitter',
		run = ':TSUpdate'
	}

	use {
		'phaazon/hop.nvim',
		branch = 'v1', -- optional but strongly recommended
		config = function()
			-- you can configure Hop the way you like here; see :h hop-config
			require 'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
		end
	}
	-- TODO: Configure Hop properly

	-- A two pane document outliner [CONFIGURED]
	use { 'vim-voom/VOoM', config = [[require('config.voom')]] }

	use {
		'folke/todo-comments.nvim',
		config = [[require('config.todo-comments')]]
	}

	-- TODO: Enable signcolumn=2 https://github.com/folke/todo-comments.nvim/issues/36#issuecomment-863215176


	----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- SECTION: Language Server Protocol
	-- DESC: Plugins which manage providers for language server protocols
	----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	use {
		'williamboman/mason.nvim',
		config = [[require('config.mason')]]
	}

	use {
		'williamboman/mason-lspconfig.nvim',
		config = [[require('config.mason-lspconfig')]]
	}


	use {
		'neovim/nvim-lspconfig',
		config = [[require('config.nvim-lspconfig')]]
	}

	----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- SECTION: Autocompletion
	-- DESC: Plugins which enable autocompletion across buffers, snippets, and LSP providers
	----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	use { 'hrsh7th/nvim-cmp', config = [[require('config.cmp')]] }

	use { 'hrsh7th/cmp-nvim-lsp', config = [[require('config.cmp')]] }

	use { 'hrsh7th/cmp-buffer', config = [[require('config.cmp')]] }

	use { 'hrsh7th/cmp-path', config = [[require('config.cmp')]] }

	use { 'hrsh7th/cmp-cmdline', config = [[require('config.cmp')]] }

	use { 'saadparwaiz1/cmp_luasnip', config = [[require('config.cmp')]] }

	----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- SECTION: Snippets
	-- DESC: Plugins for snippets
	----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	use { 'L3MON4D3/LuaSnip', config = [[require('config.cmp')]] }

	use { 'rafamadriz/friendly-snippets', config = [[require('config.cmp')]] }

	----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- SECTION: Miscellaneous
	-- DESC: Miscellaneous plugins that assist in various aspects of the neovim experience
	----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	use({ "wbthomason/packer.nvim", opt = true })
end)
