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

	-- Lua powered greeter dashboard
	use { 'goolord/alpha-nvim', requires = { 'kyazdani42/nvim-web-devicons' }, config = [[require('config.alpha-nvim')]] }

	-- Foldtext customization and folded region preview in Neovim
	use { 'anuvyklack/pretty-fold.nvim', requires = { 'anuvyklack/fold-preview.nvim', 'anuvyklack/keymap-amend.nvim' },
		config = [[require('config.pretty-fold')]] }

	-- Bookmark and annotation tool
	use { 'MattesGroeger/vim-bookmarks' }

	-- Gruvbox color scheme [CONFIGURED]
	use { "ellisonleao/gruvbox.nvim", config = [[require('config.gruvbox')]] }

	-- Lua statusline [CONFIGURED]
	use { 'nvim-lualine/lualine.nvim', config = [[require('config.lualine')]] }

	-- Create custom submodes and menus
	use { 'anuvyklack/hydra.nvim' }
	-- TODO: Create Hydra for vim table mode
	-- TODO: Create Hydra for VOoM
	-- TODO: Create Hydra for gitsigns; see: https://github.com/anuvyklack/hydra.nvim/wiki/Git
	-- TODO: Create Hydra for julia-vim (or configure for which-key ?)

	-- Utilities for naming tabs [CONFIGURED]
	use { 'gcmt/taboo.vim', config = [[require('config.taboo')]], requires = { 'ryanoasis/vim-devicons', opt = true } }

	-- Automatic line wrapping of text files [CONFIGURED]
	use { 'preservim/vim-pencil', config = [[require('config.vim-pencil')]] }

	-- Distraction-free writing in Vim [CONFIGURED]
	use { 'junegunn/goyo.vim', config = [[require('config.goyo')]] }

	-- Use (neo)vim terminal in the floating/popup window [CONFIGURED]
	use { 'voldikss/vim-floaterm', config = [[require('config.vim-floaterm')]] }

	-- Continuously updated session files [CONFIGURED]
	use { 'tpope/vim-obsession' }

	-- Git integration for buffers [CONFIGURED]
	use { 'lewis6991/gitsigns.nvim', config = [[require('config.gitsigns')]] }

	-- Neovim plugin to centre your buffer by creating a persistent scratchpad [CONFIGURED]
	use { 'FraserLee/ScratchPad', config = [[require('config.scratchpad')]] }

	-- Changes Vim working directory to project root
	use { 'airblade/vim-rooter' }

	-- Floating winbar statuslines for Neovim
	use { 'b0o/incline.nvim', config = [[require('config.incline')]] }

	-- TODO: add https://github.com/preservim/nerdcommenter for commenting superpowers

	----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- SECTION: Markup and Language Specific Plugins
	-- DESC: Plugin groups which are specific to a given language or markup
	----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	------------------------------------------------------------------------------------------------
	-- SUBSECTION: Julia
	-- DESC: Plugins for Julia specific usage
	------------------------------------------------------------------------------------------------

	-- Vim support for Julia [CONFIGURED]
	use { 'JuliaEditorSupport/julia-vim', config = [[require('config.julia-vim')]] }

	------------------------------------------------------------------------------------------------
	-- SUBSECTION: Jupyter
	-- DESC: Plugins for Jupyter Notebook specific usage
	------------------------------------------------------------------------------------------------

	use { 'goerz/jupytext.vim' }


	------------------------------------------------------------------------------------------------
	-- SUBSECTION: Markdown
	-- DESC: Plugins for Markdown specific usage and its derivatives (pandoc, commonmark, etc.)
	------------------------------------------------------------------------------------------------

	-- Preview markdown within a browser! [CONFIGURED]
	-- NOTE: See: https://github.com/iamcco/markdown-preview.nvim/issues/424
	use { 'iamcco/markdown-preview.nvim', run = function() vim.fn['mkdp#util#install']() end, ft = { 'markdown', 'pandoc' },
		config = [[require('config.markdown-preview')]] }

	-- Fenced Markdown Code-block editing
	use { 'AckslD/nvim-FeMaco.lua', config = 'require("femaco").setup()' }

	-- Interface to work with Pandoc (also required for vim-pandoc-syntax) [CONFIGURED]
	use { 'vim-pandoc/vim-pandoc' }

	-- Syntax configuration for automatically working with markdownish syntax [CONFIGURED]
	-- TODO: Switch citation engine back to something more lightweight
	use { 'vim-pandoc/vim-pandoc-syntax', config = [[require('config.vim-pandoc-syntax')]] }

	-- Useful mappings and commands for creating and computing on tables [CONFIGURED]
	use { 'dhruvasagar/vim-table-mode', config = [[require('config.vim-table-mode')]] }

	------------------------------------------------------------------------------------------------
	-- SUBSECTION: R
	-- DESC: Plugins for R specific usage
	------------------------------------------------------------------------------------------------

	use { 'jalvesaq/Nvim-R' }

	------------------------------------------------------------------------------------------------
	-- SUBSECTION: LaTeX
	-- DESC: Plugins for LaTeX specific usage
	------------------------------------------------------------------------------------------------

	-- A modern Vim and neovim filetype plugin for LaTeX files
	use { 'lervag/vimtex', config = [[require('config.vimtex')]] }

	------------------------------------------------------------------------------------------------
	-- SUBSECTION: Todo.txt
	-- DESC: Plugins to support the todo.txt specification
	------------------------------------------------------------------------------------------------

	-- BUG: Omnicompletion needs to be sorted out here otherwise, this doesn't really work
	use { 'dbeniamine/todo.txt-vim', config = [[require('config.todo-txt-vim')]] }

	----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- SECTION: Navigation
	-- DESC: Plugins which improve overall navigation through files, buffers, and the file system
	----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	------------------------------------------------------------------------------------------------
	-- SUBSECTION: Telescope
	-- DESC: Plugins for Telescope and its associated extensions
	------------------------------------------------------------------------------------------------

	-- Integrates vim-bookmarks into telescope.nvim
	-- TODO: Merge nvim-neoclip config to telescope config
	use { 'tom-anders/telescope-vim-bookmarks.nvim' }

	-- Highly extendable fuzzy finder over lists
	use {
		'nvim-telescope/telescope.nvim',
		requires = { { 'nvim-lua/plenary.nvim' } },
		config = [[require('config.telescope')]]
	}

	-- Clipboard manager neovim plugin with telescope integration
	-- TODO: Merge nvim-neoclip config to telescope config
	-- use {
	--	"AckslD/nvim-neoclip.lua",
	--	requires = {
	--		{ 'kkharji/sqlite.lua', module = 'sqlite' },
	--	},
	--	config = [[require('config.nvim-neoclip')]]
	-- }

	------------------------------------------------------------------------------------------------
	-- SUBSECTION:
	-- DESC:
	------------------------------------------------------------------------------------------------

	-- TODO: Add Trouble: https://github.com/folke/trouble.nvim

	use {
		'nvim-treesitter/nvim-treesitter',
		run = ':TSUpdate'
	}

	-- Neovim motions on speed! [CONFIGURED]
	use { 'phaazon/hop.nvim', config = [[require('config.hop')]] }

	-- A two pane document outliner [CONFIGURED]
	use { 'vim-voom/VOoM', config = [[require('config.voom')]] }

	-- Highlight, list and search todo comments in your projects [CONFIGURED]
	use { 'folke/todo-comments.nvim', config = [[require('config.todo-comments')]] }

	----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- SECTION: Language Server Protocol
	-- DESC: Plugins which manage providers for language server protocols
	----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	-- NOTE: The following three packages must be in the order given or else they will not work correctly together (this is per documentation here: https://github.com/williamboman/mason-lspconfig.nvim#setup

	-- Portable package manager for Neovim that runs everywhere Neovim runs [CONFIGURED]
	use { 'williamboman/mason.nvim', config = [[require('config.mason')]] }

	-- Extension to mason.nvim that makes it easier to use lspconfig with mason.nvim [CONFIGURED]
	use { 'williamboman/mason-lspconfig.nvim', config = [[require('config.mason-lspconfig')]] }

	-- Quickstart configs for Nvim LSP [CONFIGURED]
	use { 'neovim/nvim-lspconfig', config = [[require('config.nvim-lspconfig')]] }

	----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- SECTION: Autocompletion
	-- DESC: Plugins which enable autocompletion across buffers, snippets, and LSP providers
	----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	-- A completion plugin for neovim coded in Lua [CONFIGURED]
	use { 'hrsh7th/nvim-cmp', config = [[require('config.completion')]] }

	-- nvim-cmp source for neovim builtin LSP client [CONFIGURED]
	use { 'hrsh7th/cmp-nvim-lsp', config = [[require('config.completion')]] }

	-- nvim-cmp source for buffer words [CONFIGURED]
	use { 'hrsh7th/cmp-buffer', config = [[require('config.completion')]] }

	-- nvim-cmp source for path [CONFIGURED]
	use { 'hrsh7th/cmp-path', config = [[require('config.completion')]] }

	-- nvim-cmp source for vim's cmdline [CONFIGURED]
	use { 'hrsh7th/cmp-cmdline', config = [[require('config.completion')]] }

	-- luasnip completion source for nvim-cmp [CONFIGURED]
	use { 'saadparwaiz1/cmp_luasnip', config = [[require('config.completion')]] }

	----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- SECTION: Snippets
	-- DESC: Plugins for snippets
	----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	-- NOTE: For more advanced completions, checkout this: https://sbulav.github.io/vim/neovim-setting-up-luasnip/
	use { 'L3MON4D3/LuaSnip', config = [[require('config.completion')]] }

	use { 'rafamadriz/friendly-snippets', config = [[require('config.completion')]] }

	----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- SECTION: Miscellaneous
	-- DESC: Miscellaneous plugins that assist in various aspects of the neovim experience
	----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	use({ "wbthomason/packer.nvim", opt = true })
end)
