return {
  {
    "nvim-treesitter/nvim-treesitter", -- Smarter code understanding like syntax Highlight and navigation
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects", -- Syntax aware text-objects, select, move, swap, and peek support.
      {
        "abecodes/tabout.nvim", -- Tab out from parenthesis, quotes, brackets...
        opts = {
          tabkey = "<Tab>", -- key to trigger tabout, set to an empty string to disable
          backwards_tabkey = "<S-Tab>", -- key to trigger backwards tabout, set to an empty string to disable
          completion = true, -- We use tab for completion so set this to true
        },
      },
    },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {"markdown", "yaml", "julia"},
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<M-w>",
            scope_incremental = "<CR>",
            node_incremental = "<Tab>", -- increment to the upper named parent
            node_decremental = "<S-Tab>", -- decrement to the previous node
          },
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim

            keymaps = {
              -- Use v[keymap], c[keymap], d[keymap] to perform any operation
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
            },
          },
        },
      })
    end
  }
}
