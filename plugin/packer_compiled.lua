-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

_G._packer = _G._packer or {}
_G._packer.inside_compile = true

local time
local profile_info
local should_profile = false
if should_profile then
  local hrtime = vim.loop.hrtime
  profile_info = {}
  time = function(chunk, start)
    if start then
      profile_info[chunk] = hrtime()
    else
      profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
    end
  end
else
  time = function(chunk, start) end
end

local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end
  if threshold then
    table.insert(results, '(Only showing plugins that took longer than ' .. threshold .. ' ms ' .. 'to load)')
  end

  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/home/cedarprince/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/home/cedarprince/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/home/cedarprince/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/home/cedarprince/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/cedarprince/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s), name, _G.packer_plugins[name])
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  LuaSnip = {
    config = { "require('config.completion')" },
    loaded = true,
    path = "/home/cedarprince/.local/share/nvim/site/pack/packer/start/LuaSnip",
    url = "https://github.com/L3MON4D3/LuaSnip"
  },
  ["Nvim-R"] = {
    loaded = true,
    path = "/home/cedarprince/.local/share/nvim/site/pack/packer/start/Nvim-R",
    url = "https://github.com/jalvesaq/Nvim-R"
  },
  VOoM = {
    config = { "require('config.voom')" },
    loaded = true,
    path = "/home/cedarprince/.local/share/nvim/site/pack/packer/start/VOoM",
    url = "https://github.com/vim-voom/VOoM"
  },
  ["alpha-nvim"] = {
    config = { "require('config.alpha-nvim')" },
    loaded = true,
    path = "/home/cedarprince/.local/share/nvim/site/pack/packer/start/alpha-nvim",
    url = "https://github.com/goolord/alpha-nvim"
  },
  ["cmp-buffer"] = {
    config = { "require('config.completion')" },
    loaded = true,
    path = "/home/cedarprince/.local/share/nvim/site/pack/packer/start/cmp-buffer",
    url = "https://github.com/hrsh7th/cmp-buffer"
  },
  ["cmp-cmdline"] = {
    config = { "require('config.completion')" },
    loaded = true,
    path = "/home/cedarprince/.local/share/nvim/site/pack/packer/start/cmp-cmdline",
    url = "https://github.com/hrsh7th/cmp-cmdline"
  },
  ["cmp-nvim-lsp"] = {
    config = { "require('config.completion')" },
    loaded = true,
    path = "/home/cedarprince/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp"
  },
  ["cmp-path"] = {
    config = { "require('config.completion')" },
    loaded = true,
    path = "/home/cedarprince/.local/share/nvim/site/pack/packer/start/cmp-path",
    url = "https://github.com/hrsh7th/cmp-path"
  },
  cmp_luasnip = {
    config = { "require('config.completion')" },
    loaded = true,
    path = "/home/cedarprince/.local/share/nvim/site/pack/packer/start/cmp_luasnip",
    url = "https://github.com/saadparwaiz1/cmp_luasnip"
  },
  ["fold-preview.nvim"] = {
    loaded = true,
    path = "/home/cedarprince/.local/share/nvim/site/pack/packer/start/fold-preview.nvim",
    url = "https://github.com/anuvyklack/fold-preview.nvim"
  },
  ["friendly-snippets"] = {
    config = { "require('config.completion')" },
    loaded = true,
    path = "/home/cedarprince/.local/share/nvim/site/pack/packer/start/friendly-snippets",
    url = "https://github.com/rafamadriz/friendly-snippets"
  },
  ["gitsigns.nvim"] = {
    config = { "require('config.gitsigns')" },
    loaded = true,
    path = "/home/cedarprince/.local/share/nvim/site/pack/packer/start/gitsigns.nvim",
    url = "https://github.com/lewis6991/gitsigns.nvim"
  },
  ["goyo.vim"] = {
    config = { "require('config.goyo')" },
    loaded = true,
    path = "/home/cedarprince/.local/share/nvim/site/pack/packer/start/goyo.vim",
    url = "https://github.com/junegunn/goyo.vim"
  },
  ["gruvbox.nvim"] = {
    config = { "require('config.gruvbox')" },
    loaded = true,
    path = "/home/cedarprince/.local/share/nvim/site/pack/packer/start/gruvbox.nvim",
    url = "https://github.com/ellisonleao/gruvbox.nvim"
  },
  ["hop.nvim"] = {
    config = { "require('config.hop')" },
    loaded = true,
    path = "/home/cedarprince/.local/share/nvim/site/pack/packer/start/hop.nvim",
    url = "https://github.com/phaazon/hop.nvim"
  },
  ["hydra.nvim"] = {
    loaded = true,
    path = "/home/cedarprince/.local/share/nvim/site/pack/packer/start/hydra.nvim",
    url = "https://github.com/anuvyklack/hydra.nvim"
  },
  ["julia-vim"] = {
    config = { "require('config.julia-vim')" },
    loaded = true,
    path = "/home/cedarprince/.local/share/nvim/site/pack/packer/start/julia-vim",
    url = "https://github.com/JuliaEditorSupport/julia-vim"
  },
  ["keymap-amend.nvim"] = {
    loaded = true,
    path = "/home/cedarprince/.local/share/nvim/site/pack/packer/start/keymap-amend.nvim",
    url = "https://github.com/anuvyklack/keymap-amend.nvim"
  },
  ["lualine.nvim"] = {
    config = { "require('config.lualine')" },
    loaded = true,
    path = "/home/cedarprince/.local/share/nvim/site/pack/packer/start/lualine.nvim",
    url = "https://github.com/nvim-lualine/lualine.nvim"
  },
  ["markdown-preview.nvim"] = {
    config = { "require('config.markdown-preview')" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/cedarprince/.local/share/nvim/site/pack/packer/opt/markdown-preview.nvim",
    url = "https://github.com/iamcco/markdown-preview.nvim"
  },
  ["mason-lspconfig.nvim"] = {
    config = { "require('config.mason-lspconfig')" },
    loaded = true,
    path = "/home/cedarprince/.local/share/nvim/site/pack/packer/start/mason-lspconfig.nvim",
    url = "https://github.com/williamboman/mason-lspconfig.nvim"
  },
  ["mason.nvim"] = {
    config = { "require('config.mason')" },
    loaded = true,
    path = "/home/cedarprince/.local/share/nvim/site/pack/packer/start/mason.nvim",
    url = "https://github.com/williamboman/mason.nvim"
  },
  ["nvim-FeMaco.lua"] = {
    config = { 'require("femaco").setup()' },
    loaded = true,
    path = "/home/cedarprince/.local/share/nvim/site/pack/packer/start/nvim-FeMaco.lua",
    url = "https://github.com/AckslD/nvim-FeMaco.lua"
  },
  ["nvim-cmp"] = {
    config = { "require('config.completion')" },
    loaded = true,
    path = "/home/cedarprince/.local/share/nvim/site/pack/packer/start/nvim-cmp",
    url = "https://github.com/hrsh7th/nvim-cmp"
  },
  ["nvim-lspconfig"] = {
    config = { "require('config.nvim-lspconfig')" },
    loaded = true,
    path = "/home/cedarprince/.local/share/nvim/site/pack/packer/start/nvim-lspconfig",
    url = "https://github.com/neovim/nvim-lspconfig"
  },
  ["nvim-neoclip.lua"] = {
    config = { "require('config.nvim-neoclip')" },
    loaded = true,
    path = "/home/cedarprince/.local/share/nvim/site/pack/packer/start/nvim-neoclip.lua",
    url = "https://github.com/AckslD/nvim-neoclip.lua"
  },
  ["nvim-treesitter"] = {
    loaded = true,
    path = "/home/cedarprince/.local/share/nvim/site/pack/packer/start/nvim-treesitter",
    url = "https://github.com/nvim-treesitter/nvim-treesitter"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/home/cedarprince/.local/share/nvim/site/pack/packer/start/nvim-web-devicons",
    url = "https://github.com/kyazdani42/nvim-web-devicons"
  },
  ["packer.nvim"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/cedarprince/.local/share/nvim/site/pack/packer/opt/packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/home/cedarprince/.local/share/nvim/site/pack/packer/start/plenary.nvim",
    url = "https://github.com/nvim-lua/plenary.nvim"
  },
  ["pretty-fold.nvim"] = {
    config = { "require('config.pretty-fold')" },
    loaded = true,
    path = "/home/cedarprince/.local/share/nvim/site/pack/packer/start/pretty-fold.nvim",
    url = "https://github.com/anuvyklack/pretty-fold.nvim"
  },
  ["sqlite.lua"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/cedarprince/.local/share/nvim/site/pack/packer/opt/sqlite.lua",
    url = "https://github.com/kkharji/sqlite.lua"
  },
  ["taboo.vim"] = {
    config = { "require('config.taboo')" },
    loaded = true,
    path = "/home/cedarprince/.local/share/nvim/site/pack/packer/start/taboo.vim",
    url = "https://github.com/gcmt/taboo.vim"
  },
  ["telescope-vim-bookmarks.nvim"] = {
    loaded = true,
    path = "/home/cedarprince/.local/share/nvim/site/pack/packer/start/telescope-vim-bookmarks.nvim",
    url = "https://github.com/tom-anders/telescope-vim-bookmarks.nvim"
  },
  ["telescope.nvim"] = {
    config = { "require('config.telescope')" },
    loaded = true,
    path = "/home/cedarprince/.local/share/nvim/site/pack/packer/start/telescope.nvim",
    url = "https://github.com/nvim-telescope/telescope.nvim"
  },
  ["todo-comments.nvim"] = {
    config = { "require('config.todo-comments')" },
    loaded = true,
    path = "/home/cedarprince/.local/share/nvim/site/pack/packer/start/todo-comments.nvim",
    url = "https://github.com/folke/todo-comments.nvim"
  },
  ["todo.txt-vim"] = {
    config = { "require('config.todo-txt-vim')" },
    loaded = true,
    path = "/home/cedarprince/.local/share/nvim/site/pack/packer/start/todo.txt-vim",
    url = "https://github.com/dbeniamine/todo.txt-vim"
  },
  ["vim-bookmarks"] = {
    loaded = true,
    path = "/home/cedarprince/.local/share/nvim/site/pack/packer/start/vim-bookmarks",
    url = "https://github.com/MattesGroeger/vim-bookmarks"
  },
  ["vim-devicons"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/cedarprince/.local/share/nvim/site/pack/packer/opt/vim-devicons",
    url = "https://github.com/ryanoasis/vim-devicons"
  },
  ["vim-floaterm"] = {
    config = { "require('config.vim-floaterm')" },
    loaded = true,
    path = "/home/cedarprince/.local/share/nvim/site/pack/packer/start/vim-floaterm",
    url = "https://github.com/voldikss/vim-floaterm"
  },
  ["vim-obsession"] = {
    loaded = true,
    path = "/home/cedarprince/.local/share/nvim/site/pack/packer/start/vim-obsession",
    url = "https://github.com/tpope/vim-obsession"
  },
  ["vim-pandoc"] = {
    loaded = true,
    path = "/home/cedarprince/.local/share/nvim/site/pack/packer/start/vim-pandoc",
    url = "https://github.com/vim-pandoc/vim-pandoc"
  },
  ["vim-pandoc-syntax"] = {
    config = { "require('config.vim-pandoc-syntax')" },
    loaded = true,
    path = "/home/cedarprince/.local/share/nvim/site/pack/packer/start/vim-pandoc-syntax",
    url = "https://github.com/vim-pandoc/vim-pandoc-syntax"
  },
  ["vim-pencil"] = {
    config = { "require('config.vim-pencil')" },
    loaded = true,
    path = "/home/cedarprince/.local/share/nvim/site/pack/packer/start/vim-pencil",
    url = "https://github.com/preservim/vim-pencil"
  },
  ["vim-table-mode"] = {
    config = { "require('config.vim-table-mode')" },
    loaded = true,
    path = "/home/cedarprince/.local/share/nvim/site/pack/packer/start/vim-table-mode",
    url = "https://github.com/dhruvasagar/vim-table-mode"
  }
}

time([[Defining packer_plugins]], false)
local module_lazy_loads = {
  ["^sqlite"] = "sqlite.lua"
}
local lazy_load_called = {['packer.load'] = true}
local function lazy_load_module(module_name)
  local to_load = {}
  if lazy_load_called[module_name] then return nil end
  lazy_load_called[module_name] = true
  for module_pat, plugin_name in pairs(module_lazy_loads) do
    if not _G.packer_plugins[plugin_name].loaded and string.match(module_name, module_pat) then
      to_load[#to_load + 1] = plugin_name
    end
  end

  if #to_load > 0 then
    require('packer.load')(to_load, {module = module_name}, _G.packer_plugins)
    local loaded_mod = package.loaded[module_name]
    if loaded_mod then
      return function(modname) return loaded_mod end
    end
  end
end

if not vim.g.packer_custom_loader_enabled then
  table.insert(package.loaders, 1, lazy_load_module)
  vim.g.packer_custom_loader_enabled = true
end

-- Config for: pretty-fold.nvim
time([[Config for pretty-fold.nvim]], true)
require('config.pretty-fold')
time([[Config for pretty-fold.nvim]], false)
-- Config for: vim-pencil
time([[Config for vim-pencil]], true)
require('config.vim-pencil')
time([[Config for vim-pencil]], false)
-- Config for: telescope.nvim
time([[Config for telescope.nvim]], true)
require('config.telescope')
time([[Config for telescope.nvim]], false)
-- Config for: vim-table-mode
time([[Config for vim-table-mode]], true)
require('config.vim-table-mode')
time([[Config for vim-table-mode]], false)
-- Config for: LuaSnip
time([[Config for LuaSnip]], true)
require('config.completion')
time([[Config for LuaSnip]], false)
-- Config for: mason.nvim
time([[Config for mason.nvim]], true)
require('config.mason')
time([[Config for mason.nvim]], false)
-- Config for: todo-comments.nvim
time([[Config for todo-comments.nvim]], true)
require('config.todo-comments')
time([[Config for todo-comments.nvim]], false)
-- Config for: cmp_luasnip
time([[Config for cmp_luasnip]], true)
require('config.completion')
time([[Config for cmp_luasnip]], false)
-- Config for: nvim-FeMaco.lua
time([[Config for nvim-FeMaco.lua]], true)
require("femaco").setup()
time([[Config for nvim-FeMaco.lua]], false)
-- Config for: mason-lspconfig.nvim
time([[Config for mason-lspconfig.nvim]], true)
require('config.mason-lspconfig')
time([[Config for mason-lspconfig.nvim]], false)
-- Config for: VOoM
time([[Config for VOoM]], true)
require('config.voom')
time([[Config for VOoM]], false)
-- Config for: gruvbox.nvim
time([[Config for gruvbox.nvim]], true)
require('config.gruvbox')
time([[Config for gruvbox.nvim]], false)
-- Config for: vim-floaterm
time([[Config for vim-floaterm]], true)
require('config.vim-floaterm')
time([[Config for vim-floaterm]], false)
-- Config for: alpha-nvim
time([[Config for alpha-nvim]], true)
require('config.alpha-nvim')
time([[Config for alpha-nvim]], false)
-- Config for: hop.nvim
time([[Config for hop.nvim]], true)
require('config.hop')
time([[Config for hop.nvim]], false)
-- Config for: friendly-snippets
time([[Config for friendly-snippets]], true)
require('config.completion')
time([[Config for friendly-snippets]], false)
-- Config for: cmp-buffer
time([[Config for cmp-buffer]], true)
require('config.completion')
time([[Config for cmp-buffer]], false)
-- Config for: nvim-neoclip.lua
time([[Config for nvim-neoclip.lua]], true)
require('config.nvim-neoclip')
time([[Config for nvim-neoclip.lua]], false)
-- Config for: todo.txt-vim
time([[Config for todo.txt-vim]], true)
require('config.todo-txt-vim')
time([[Config for todo.txt-vim]], false)
-- Config for: cmp-cmdline
time([[Config for cmp-cmdline]], true)
require('config.completion')
time([[Config for cmp-cmdline]], false)
-- Config for: julia-vim
time([[Config for julia-vim]], true)
require('config.julia-vim')
time([[Config for julia-vim]], false)
-- Config for: nvim-lspconfig
time([[Config for nvim-lspconfig]], true)
require('config.nvim-lspconfig')
time([[Config for nvim-lspconfig]], false)
-- Config for: cmp-nvim-lsp
time([[Config for cmp-nvim-lsp]], true)
require('config.completion')
time([[Config for cmp-nvim-lsp]], false)
-- Config for: nvim-cmp
time([[Config for nvim-cmp]], true)
require('config.completion')
time([[Config for nvim-cmp]], false)
-- Config for: gitsigns.nvim
time([[Config for gitsigns.nvim]], true)
require('config.gitsigns')
time([[Config for gitsigns.nvim]], false)
-- Config for: cmp-path
time([[Config for cmp-path]], true)
require('config.completion')
time([[Config for cmp-path]], false)
-- Config for: lualine.nvim
time([[Config for lualine.nvim]], true)
require('config.lualine')
time([[Config for lualine.nvim]], false)
-- Config for: goyo.vim
time([[Config for goyo.vim]], true)
require('config.goyo')
time([[Config for goyo.vim]], false)
-- Config for: taboo.vim
time([[Config for taboo.vim]], true)
require('config.taboo')
time([[Config for taboo.vim]], false)
-- Config for: vim-pandoc-syntax
time([[Config for vim-pandoc-syntax]], true)
require('config.vim-pandoc-syntax')
time([[Config for vim-pandoc-syntax]], false)
vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Filetype lazy-loads
time([[Defining lazy-load filetype autocommands]], true)
vim.cmd [[au FileType pandoc ++once lua require("packer.load")({'markdown-preview.nvim'}, { ft = "pandoc" }, _G.packer_plugins)]]
vim.cmd [[au FileType markdown ++once lua require("packer.load")({'markdown-preview.nvim'}, { ft = "markdown" }, _G.packer_plugins)]]
time([[Defining lazy-load filetype autocommands]], false)
vim.cmd("augroup END")

_G._packer.inside_compile = false
if _G._packer.needs_bufread == true then
  vim.cmd("doautocmd BufRead")
end
_G._packer.needs_bufread = false

if should_profile then save_profiles() end

end)

if not no_errors then
  error_msg = error_msg:gsub('"', '\\"')
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
