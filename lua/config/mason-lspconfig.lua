-- NOTE: For some reason, you may need to open neovim once or twice for r_language_server to properly download
require("mason-lspconfig").setup({
    ensure_installed = { "sumneko_lua", "julials", "marksman", "r_language_server", "taplo", "pylsp" }
})
