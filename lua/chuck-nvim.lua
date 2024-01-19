local config = require("chuck-nvim.config")

local M = {}

---Load and setup the plugin with potentially a table of configurations.
---
---@param opts chuck-nvim.Config? Table of of configurations to override the default behavior.
function M.setup(opts)
  config.apply(opts or {})
end

return M
