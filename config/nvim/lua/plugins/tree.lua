local function nvimtree_on_attach(bufnr)
    local api = require('nvim-tree.api')

    local function opts(desc)
      return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    api.config.mappings.default_on_attach(bufnr)

    vim.keymap.del('n', ']c', { buffer = bufnr })
    vim.keymap.del('n', '[c', { buffer = bufnr })
    vim.keymap.del('n', '<C-k>', { buffer = bufnr })

    vim.keymap.set('n', '<leader>k', api.node.show_info_popup, opts('Info'))
    vim.keymap.set('n', ']h', api.node.navigate.git.next, opts('Next Git'))
    vim.keymap.set('n', '[h', api.node.navigate.git.prev, opts('Prev Git'))

    vim.keymap.set('n', '?', api.tree.toggle_help, opts('Help'))
  end


require("nvim-tree").setup({
    on_attach = nvimtree_on_attach,
})

local git_top = io.popen("git -C " .. vim.fn.expand("%:p:h") .. " top"):read()

if git_top == nil or git_top == "" then
    vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>")
else
    vim.keymap.set("n", "<C-n>", ":NvimTreeToggle " .. git_top .. "<CR>")
end
