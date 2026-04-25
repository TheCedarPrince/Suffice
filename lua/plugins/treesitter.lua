return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    dependencies = {
      "folke/which-key.nvim",
      { "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },
      {
        "abecodes/tabout.nvim",
        opts = {
          tabkey = "<Tab>",
          backwards_tabkey = "<S-Tab>",
          completion = true,
        },
      },
    },
    main = "nvim-treesitter",  -- changed from nvim-treesitter.configs
    opts = {
      highlight = { enable = true },
      indent = { enable = true },
    },
    init = function()
      -- ensure_installed is now done via the install API
      local installed = require("nvim-treesitter.config").get_installed()
      local wanted = { "markdown", "yaml", "julia" }
      local to_install = vim.tbl_filter(function(p)
        return not vim.tbl_contains(installed, p)
      end, wanted)
      if #to_install > 0 then
        require("nvim-treesitter").install(to_install)
      end

      -- incremental_selection is now a built-in Neovim feature
      vim.keymap.set("n", "<M-w>", ":lua vim.treesitter.get_node():range()<CR>")

      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          pcall(vim.treesitter.start)
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },
}
