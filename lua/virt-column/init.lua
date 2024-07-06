local utils = require "virt-column.utils"
local conf = require "virt-column.config"

local M = {}

---@package
M.initialized = false

local reset_highlight = function()
    vim.api.nvim_set_hl(0, "VirtColumn", { link = "Whitespace", default = true })
    vim.api.nvim_set_hl(0, "ColorColumn", {})
end

local init = function()
    M.namespace = vim.api.nvim_create_namespace "virt-column"
    reset_highlight()

    vim.api.nvim_set_decoration_provider(M.namespace, {
        on_win = function(_, win, bufnr, topline, botline_guess)
            local config = conf.get_config(bufnr)
            local buftype = vim.api.nvim_get_option_value("buftype", { buf = bufnr })
            local filetypes = utils.get_filetypes(bufnr)
            if
                not config.enabled
                or utils.tbl_intersect(config.exclude.filetypes, filetypes)
                or vim.tbl_contains(config.exclude.buftypes, buftype)
            then
                pcall(vim.api.nvim_buf_clear_namespace, bufnr, M.namespace, 0, -1)
                return false
            end

            local textwidth = vim.api.nvim_get_option_value("textwidth", { buf = bufnr })
            local leftcol = vim.api.nvim_win_call(win, vim.fn.winsaveview).leftcol or 0

            ---@type number[]
            local colorcolumn = {}
            for _, c in
                ipairs(
                    utils.tbl_join(
                        vim.split(vim.api.nvim_get_option_value("colorcolumn", { win = win }), ","),
                        vim.split(config.virtcolumn, ",")
                    )
                )
            do
                if vim.startswith(c, "+") then
                    if textwidth ~= 0 then
                        table.insert(colorcolumn, textwidth + tonumber(c:sub(2)))
                    end
                elseif vim.startswith(c, "-") then
                    if textwidth ~= 0 then
                        table.insert(colorcolumn, textwidth - tonumber(c:sub(2)))
                    end
                elseif tonumber(c) then
                    table.insert(colorcolumn, tonumber(c))
                end
            end

            table.sort(colorcolumn, function(a, b)
                return a > b
            end)

            pcall(vim.api.nvim_buf_clear_namespace, bufnr, M.namespace, topline, botline_guess)

            local highlight = config.highlight
            if type(highlight) == "string" then
                highlight = { highlight }
            end
            local char = config.char
            if type(char) == "string" then
                char = { char }
            end

            local i = topline
            while i <= botline_guess do
                for j, column in ipairs(colorcolumn) do
                    local width = vim.api.nvim_win_call(win, function()
                        ---@diagnostic disable-next-line
                        return vim.fn.virtcol { i, "$" } - 1
                    end)
                    if width < column then
                        local column_index = #colorcolumn - j + 1
                        pcall(vim.api.nvim_buf_set_extmark, bufnr, M.namespace, i - 1, 0, {
                            virt_text = {
                                {
                                    utils.tbl_get_index(char, column_index),
                                    utils.tbl_get_index(highlight, column_index),
                                },
                            },
                            virt_text_pos = "overlay",
                            hl_mode = "combine",
                            virt_text_win_col = column - 1 - leftcol,
                            priority = 1,
                        })
                    end
                end
                local fold_end = vim.api.nvim_win_call(win, function()
                    ---@diagnostic disable-next-line: redundant-return-value
                    return vim.fn.foldclosedend(i)
                end)
                if fold_end ~= -1 then -- line is folded
                    i = fold_end
                end
                i = i + 1
            end
        end,
    })
end

local setup = function()
    vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("VirtColumn", {}),
        pattern = "*",
        callback = function()
            reset_highlight()
        end,
    })

    if not M.initialized then
        init()
        M.initialized = true
    end
end

--- Initializes and configures virt-column.
---
--- Optionally, the first parameter can be a configuration table.
--- All values that are not passed in the table are set to the default value.
--- List values get merged with the default list value.
---
--- `setup` is idempotent, meaning you can call it multiple times, and each call will reset virt-column.
--- If you want to only update the current configuration, use `update()`.
---@param config virtcolumn.config?
M.setup = function(config)
    conf.set_config(config)
    setup()
end

--- Updates the virt-column configuration
---
--- The first parameter is a configuration table.
--- All values that are not passed in the table are kept as they are.
--- List values get merged with the current list value.
---@param config virtcolumn.config
M.update = function(config)
    conf.update_config(config)
    setup()
end

--- Overwrites the virt-column configuration
---
--- The first parameter is a configuration table.
--- All values that are not passed in the table are kept as they are.
--- All values that are passed overwrite existing and default values.
---@param config virtcolumn.config
M.overwrite = function(config)
    conf.overwrite_config(config)
    setup()
end

--- Configures virt-column for one buffer
---
--- All values that are not passed are cleared, and will fall back to the global config
---@param bufnr number
---@param config virtcolumn.config
M.setup_buffer = function(bufnr, config)
    assert(M.initialized, "Tried to setup buffer without doing global setup")
    bufnr = utils.get_bufnr(bufnr)
    conf.set_buffer_config(bufnr, config)
end

--- Toggle virt-column for one buffer
---
---@param bufnr number
M.toggle_buffer = function(bufnr)
    assert(M.initialized, "Tried to setup buffer without doing global setup")
    bufnr = utils.get_bufnr(bufnr)
    local config = conf.get_config(bufnr)
    M.update { enabled = not config.enabled }
end

vim.api.nvim_create_user_command("VirtColumnToggle", function()
    M.toggle_buffer(0)
end, {})

return M
