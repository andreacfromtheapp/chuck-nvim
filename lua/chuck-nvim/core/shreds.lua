local M = {}

-- temp table to store raw data from ChucK
local tmp_tbl = {}

-- shreds table to build the Shred UI with NuiTable
M.table = {}

-- clear table on remove all or exiting
local function clear_table(tbl)
    for k in pairs(tbl) do
        tbl[k] = nil
    end
end

-- split line into columns and return each word as line
local function column(line, n)
    local p = string.rep("%s+.-", n - 1) .. "(%S+)"
    return line:match(p)
end

-- if the log line matches a certain word/pattern we set an action
local function set_action(line)
    local action
    if string.match(line, "sporking incoming shred: %d") then
        action = "add"
    end
    if string.match(line, "replacing shred %d") then
        action = "replace"
    end
    if string.match(line, "removing shred: %d") then
        action = "remove"
    end
    -- if clearing or exiting, empty the table and set action to nil
    if string.match(line, "removing all shreds") then
        clear_table(tmp_tbl)
        clear_table(M.table)
        action = nil
    end
    return action
end

-- set the temporary table to raw ChucK data ["id"] = "value"
local function set_tmp_tbl(line)
    local action = set_action(line)

    -- if the log line matches a certain word/pattern
    if action ~= nil then
        local shred_id
        local shred_name
        -- get string length
        local _, count = string.gsub(line, "% ", "")

        -- iterate over the string
        for n = 1, count + 1 do
            -- split line to columns and match the last id and last filename
            local id = column(line, n):match("%d+")
            local name = column(line, n):match("%((.+)%).+")

            -- if id is valid initialize shred_id
            if id ~= nil then
                shred_id = tostring(id)
            end
            -- if name is valid initialize shred_name
            if name ~= nil then
                shred_name = name
            end

            -- if shred_id and shred_name are valid
            if shred_id ~= nil and shred_name ~= nil and shred_name:match(".ck") then
                -- if adding/replacing set shred as: id is key -> shred_name is value
                if action == "add" or "replace" then
                    tmp_tbl[shred_id] = shred_name
                end
                -- if removing set shred as nil: id is key -> nil
                if action == "remove" then
                    tmp_tbl[shred_id] = nil
                end
            end
        end
    end
end

-- build actual shreds table to use with NuiTable UI layout
function M.set_shreds_tbl(line)
    -- set the temporary table first
    set_tmp_tbl(line)
    -- if the temporary table is not empty
    if #tmp_tbl ~= 0 then
        -- sort it first
        table.sort(tmp_tbl)
        -- convert to a valid shreds table to use with NuiTable
        for k, v in pairs(tmp_tbl) do
            table.insert(M.table, { id = k, name = v })
        end
    end
end

return M
