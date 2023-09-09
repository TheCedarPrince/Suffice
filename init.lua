local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath
	})
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({{import = "plugins"}, {import = "core.lua.plugins"}})

package.path = package.path .. ';' .. vim.fn.stdpath("config") .. '/?.lua'
vim.o.runtimepath = vim.o.runtimepath .. ',' .. vim.fn.stdpath("config") .. "/core/lua"
require("core.lua.functions")
require("core.lua.options")
require("core.lua.autocommands")
require("core.lua.keymaps")

require("autocommands")

vim.keymap.set('t', '<Esc>', "<C-\\><C-n>", {silent = true})

