local M = {}

-- shreds table to build the Shred UI with NuiTable
M.shreds_table = {}

function M.set_table(line, action)
  if action ~= nil then
    if action == "clear" then
      for k in pairs(M.shreds_table) do
        M.shreds_table[k] = nil
      end
    else
      -- btw if you're concerned about worst-case efficiency consider using this. otherwise the current pattern should be fine.
      -- local id, name
      -- for mid, mname in str:gmatch(pattern) do
      --     id, name = mid, mname
      -- end

      -- match the last id and last filename
      local pattern = ".*(%d+)%s+%((.-)%)"
      local shred_id, shred_name = line:match(pattern)

      if shred_id ~= nil and shred_name ~= nil and shred_name:match(".ck") then
        if action == "add" or "replace" then
          M.shreds_table[shred_id] = { id = shred_id, name = shred_name }
        end
        if action == "remove" then
          M.shreds_table[shred_id] = nil
        end
      end
    end
  end
end

return M
