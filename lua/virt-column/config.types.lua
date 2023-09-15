
---@meta

---@class virtcolumn.config
--- Enables or disables virt-column
---@field enabled boolean?
--- Character, or list of characters, that get used to display the virtual column
---
--- Each character has to have a display width of 0 or 1
---@field char string|string[]?
--- comma-separated list of screen columns, same as `colorcolumn`
---@field virtcolumn string?
--- Highlight group, or list of highlight groups, that get applied to the virtual column
---@field highlight string|string[]?
--- Configures what is excluded from virt-column
---@field exclude virtcolumn.config.exclude?

---@class virtcolumn.config.exclude
--- List of `filetypes` for which virt-column is disabled
---@field filetypes string[]?
--- List of `buftypes` for which virt-column is disabled
---@field buftypes string[]?

---@class virtcolumn.config.full
--- Enables or disables virt-column
---@field enabled boolean
--- Character, or list of characters, that get used to display the virtual column
---
--- Each character has to have a display width of 0 or 1
---@field char string|string[]
--- comma-separated list of screen columns, same as `colorcolumn`
---@field virtcolumn string
--- Highlight group, or list of highlight groups, that get applied to the virtual column
---@field highlight string|string[]
--- Configures what is excluded from virt-column
---@field exclude virtcolumn.config.exclude.full

---@class virtcolumn.config.exclude.full
--- List of `filetypes` for which virt-column is disabled
---@field filetypes string[]
--- List of `buftypes` for which virt-column is disabled
---@field buftypes string[]
