return {
  "rareitems/anki.nvim",
  lazy = false,
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("anki").setup({
      tex_support = false,
      models = {
        ["Reader"] = "Incremental Reading::General",
        ["Math Questions"] = "Mathematics Exercises",
        ["Math Definitions"] = "Mathematics",
        ["Math Definition Properties"] = "Mathematics"
      },
    })
  end
}
