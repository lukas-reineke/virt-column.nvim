local M = {}

M.refresh = function(bang)
    if bang then
        local win = vim.api.nvim_get_current_win()
        vim.cmd [[noautocmd windo lua require("virt-column").refresh()]]
        if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_set_current_win(win)
        end
    else
        vim.cmd [[lua require("virt-column").refresh()]]
    end
end

return M
