return {
  "rareitems/anki.nvim",
  commit = "2a30bb4307000ff1be542906292418c50d3e7261",
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
