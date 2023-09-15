local utils = require "virt-column.utils"

local M = {}

--- The current global configuration
---
---@type virtcolumn.config.full?
M.config = nil

--- Map from buffer numbers to their partial configuration
---
--- Anything not included here will fall back to the global configuration
---@type table<number, virtcolumn.config>
M.buffer_config = {}

--- The default configuration
---
---@type virtcolumn.config.full
M.default_config = {
    enabled = true,
    char = "┃",
    virtcolumn = "",
    highlight = "NonText",
    exclude = {
        filetypes = {
            "lspinfo",
            "packer",
            "checkhealth",
            "help",
            "man",
            "TelescopePrompt",
            "TelescopeResults",
        },
        buftypes = { "nofile", "quickfix", "terminal", "prompt" },
    },
}

---@param char string
---@return boolean, string?
local validate_char = function(char)
    if type(char) == "string" then
        local length = vim.fn.strdisplaywidth(char)
        return length <= 1, string.format("'%s' has a dispaly width of %d", char, length)
    else
        if #char == 0 then
            return false, "table is empty"
        end
        for i, c in ipairs(char) do
            local length = vim.fn.strdisplaywidth(c)
            if length > 1 then
                return false, string.format("index %d '%s' has a display width of %d", i, c, length)
            end
        end
        return true
    end
end

---@param config virtcolumn.config?
local validate_config = function(config)
    if not config then
        return
    end

    vim.validate {
        enabled = { config.enabled, "boolean", true },
        char = { config.char, { "string", "table" }, true },
        virtcolumn = { config.virtcolumn, "string", true },
        highlight = { config.highlight, { "string", "table" }, true },
        exclude = { config.exclude, "table", true },
    }

    if config.char then
        vim.validate {
            char = {
                config.char,
                validate_char,
                "char to have a display width of 0 or 1",
            },
        }
    end

    if config.exclude then
        if config.exclude then
            vim.validate {
                filetypes = { config.exclude.filetypes, "table", true },
                buftypes = { config.exclude.buftypes, "table", true },
            }
        end
    end
end

---@param behavior "merge"|"overwrite"
---@param base virtcolumn.config.full
---@param input virtcolumn.config?
---@return virtcolumn.config.full
local merge_configs = function(behavior, base, input)
    local result = vim.tbl_deep_extend("keep", input or {}, base) --[[@as virtcolumn.config.full]]

    if behavior == "merge" and input then
        result.exclude.filetypes = utils.tbl_join(base.exclude.filetypes, vim.tbl_get(input, "exclude", "filetypes"))
        result.exclude.buftypes = utils.tbl_join(base.exclude.buftypes, vim.tbl_get(input, "exclude", "buftypes"))
    end

    return result
end

--- Sets the global configuration
---
--- All values that are not passed are set to the default value
--- List values get merged with the default values
---@param config virtcolumn.config?
---@return virtcolumn.config.full
M.set_config = function(config)
    validate_config(config)
    M.config = merge_configs("merge", M.default_config, config)

    return M.config
end

--- Updates the global configuration
---
--- All values that are not passed are kept as they are
---@param config virtcolumn.config
---@return virtcolumn.config.full
M.update_config = function(config)
    validate_config(config)
    M.config = merge_configs("merge", M.config or M.default_config, config or {})

    return M.config
end

--- Overwrites the global configuration
---
--- Same as `set_config`, but all list values are overwritten instead of merged
---@param config virtcolumn.config
---@return virtcolumn.config.full
M.overwrite_config = function(config)
    validate_config(config)
    M.config = merge_configs("overwrite", M.default_config, config)

    return M.config
end

--- Sets the configuration for a buffer
---
--- All values that are not passed are cleared, and will fall back to the global config
---@param bufnr number
---@param config virtcolumn.config
---@return virtcolumn.config.full
M.set_buffer_config = function(bufnr, config)
    validate_config(config)
    bufnr = utils.get_bufnr(bufnr)
    M.buffer_config[bufnr] = config

    return M.get_config(bufnr)
end

--- Clears the configuration for a buffer
---
---@param bufnr number
M.clear_buffer_config = function(bufnr)
    M.buffer_config[bufnr] = nil
end

--- Returns the configuration for a buffer
---
---@param bufnr number
---@return virtcolumn.config.full
M.get_config = function(bufnr)
    bufnr = utils.get_bufnr(bufnr)
    return merge_configs("merge", M.config or M.default_config, M.buffer_config[bufnr])
end

return M
