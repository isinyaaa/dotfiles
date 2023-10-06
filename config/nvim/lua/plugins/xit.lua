return {
    "synaptiko/xit.nvim",
    ft = "xit",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
    },
    config = function()
        require("xit").setup()
    end,
}
