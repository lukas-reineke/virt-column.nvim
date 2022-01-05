local M = {}

function M.concat_table(t1, t2)
    for _, v in ipairs(t2) do
        t1[#t1 + 1] = v
    end
    return t1
end

return M
