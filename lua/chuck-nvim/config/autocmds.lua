local M = {}

function M.chuck_autorun()
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

return M
