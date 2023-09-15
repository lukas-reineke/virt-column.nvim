local M = {}

---@param bufnr number
---@return number
M.get_bufnr = function(bufnr)
    if not bufnr or bufnr == 0 then
        return vim.api.nvim_get_current_buf() --[[@as number]]
    end
    return bufnr
end

---@generic T: table
---@vararg T
---@return T
M.tbl_join = function(...)
    local result = {}
    for i, v in ipairs(vim.tbl_flatten { ... }) do
        result[i] = v
    end
    return result
end

---@generic T
---@param list T[]
---@param i number
---@return T
M.tbl_get_index = function(list, i)
    return list[((i - 1) % #list) + 1]
end

return M
