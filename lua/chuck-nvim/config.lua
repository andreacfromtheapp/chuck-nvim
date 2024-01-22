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

  --- set autorun autocommand here, cause lazy
  local autorun = M.user.autorun

  if autorun then
    local ChuckAutoGroup = vim.api.nvim_create_augroup("ChuckAutoGroup", { clear = true })
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
      group = ChuckAutoGroup,
      pattern = { "*.ck" },
      callback = function()
        vim.api.nvim_command("ChuckLoop")
        vim.api.nvim_clear_autocmds({ group = ChuckAutoGroup })
      end,
    })
  end
end

return M
