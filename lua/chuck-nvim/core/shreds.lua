local M = {}

---shreds table to build the Shred UI with NuiTable
---@type table
M.shreds_table = {}

function M.set_table(line, action)
  if action ~= nil then
    if action == "clear" then
      for k in pairs(M.shreds_table) do
        M.shreds_table[k] = nil
      end
    else
      -- match the last id and last filename
      local pattern = ".*(%d+)%s+%((.-)%)"
      local shred_id, shred_name = line:match(pattern)

      if shred_id ~= nil and shred_name ~= nil and shred_name:match(".ck") then
        if action == "add" or "replace" then
          M.shreds_table[shred_id] = { id = shred_id, name = shred_name, time = "00:00:00" }
          -- make sure it's sorted by id in ascending order first
          -- this doesn't seem to be working when adding shreds
          table.sort(M.shreds_table, function(a, b)
            return a.id < b.id
          end)
        end
        if action == "remove" then
          M.shreds_table[shred_id] = nil
        end
      end
    end
  end
end

return M
