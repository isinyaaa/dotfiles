-- Whitespace management
vim.cmd.highlight({ "ExtraWhitespace", "ctermbg=red", "guibg=red" })
vim.api.nvim_create_autocmd("BufWinEnter", {
    pattern = "*",
    callback = function()
        vim.cmd([[match ExtraWhitespace /\s\+$/]])
    end
}
)
vim.api.nvim_create_autocmd("InsertEnter ", {
    pattern = "*",
    callback = function()
        vim.cmd([[match ExtraWhitespace /\s\+\%#\@<!$/]])
    end
}
)
vim.api.nvim_create_autocmd("InsertLeave ", {
    pattern = "*",
    callback = function()
        vim.cmd([[match ExtraWhitespace /\s\+$/]])
    end
}
)
vim.api.nvim_create_autocmd("BufWinLeave ", {
    pattern = "*",
    callback = function()
        vim.fn.clearmatches()
    end
}
)
