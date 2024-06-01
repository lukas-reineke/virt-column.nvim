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
    for i, v in ipairs(vim.iter(...):flatten():totable()) do
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

---@param bufnr number
M.get_filetypes = function(bufnr)
    local filetype = vim.api.nvim_get_option_value("filetype", { buf = bufnr })
    if filetype == "" then
        return { "" }
    end
    return vim.split(filetype, ".", { plain = true, trimempty = true })
end

---@param a table
---@param b table
M.tbl_intersect = function(a, b)
    for _, v in ipairs(a) do
        if vim.tbl_contains(b, v) then
            return true
        end
    end
    return false
end

return M
