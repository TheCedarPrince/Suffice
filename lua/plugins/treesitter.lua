return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
      "folke/which-key.nvim",
      "nvim-treesitter/nvim-treesitter-textobjects",
      {
        "abecodes/tabout.nvim",
        opts = {
          tabkey = "<Tab>",
          backwards_tabkey = "<S-Tab>",
          completion = true,
        },
      },
    },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "markdown", "yaml", "julia" },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection    = "<M-w>",
            scope_incremental = "<CR>",
            node_incremental  = "<Tab>",
            node_decremental  = "<S-Tab>",
          },
        },
        textobjects = {
          select = {
            enable    = true,
            lookahead = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
            },
          },
        },
      })
    end,
  },
}
