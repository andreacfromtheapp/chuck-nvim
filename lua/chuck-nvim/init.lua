local M = {}

-- TODO: use M.config to manage chuck audio settings and window placement
M.config = {}

function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
  return M.config
end

return M
