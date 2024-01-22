local autocmds = require("chuck-nvim.config.autocmds")
local template = require("chuck-nvim.config.template")

local M = {}

---User configurations.
---
---@type chuck-nvim.Config
M.user = template

---Merge configurations into default configurations and set it as user configurations.
---
---@param opts chuck-nvim.Config Configurations to be merged.
function M.apply(opts)
  M.user = vim.tbl_deep_extend("force", template, opts)

  -- SET AUTORUN AUTOCOMMAND HERE, CAUSE LAZY
  --
  -- run ChuckLoop on nvim start for chuck files
  local autorun = M.user.autorun
  if autorun then
    autocmds.chuck_autorun()
  end
end

return M
