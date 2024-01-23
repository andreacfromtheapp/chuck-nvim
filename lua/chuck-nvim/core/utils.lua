local NuiTree = require("nui.tree")
local layout = require("chuck-nvim.ui.layout")

local M = {}

-- if the log line matches a certain word/pattern we set an action
local function set_action(line)
  local action
  if line ~= nil then
    if string.match(line, "sporking incoming shred: %d") then
      action = "add"
    end
    if string.match(line, "replacing shred %d") then
      action = "replace"
    end
    if string.match(line, "removing shred: %d") then
      action = "remove"
    end
    if string.match(line, "removing all") or string.match(line, "EXIT") then
      action = "clear"
    end
  end
  return action
end

-- this calls the layout to set NUI elements in the UI
local function shred_node(line)
  local action = set_action(line)
  if line and action then
    if action ~= nil then
      local pattern = ".*(%d+)%s+%((.-)%)"
      local shred_id, shred_name = line:match(pattern)

      if action == "clear" then
        layout.shred_list:set_nodes({})
      end

      if shred_id ~= nil and shred_name ~= nil and shred_name:match(".ck") then
        if action == "add" then
          layout.shred_list:add_node(NuiTree.Node({ id = shred_id, name = shred_name }))
        end

        if action == "replace" then
          layout.shred_list:remove_node(shred_id)
          layout.shred_list:add_node(NuiTree.Node({ id = shred_id, name = shred_name }))
        end

        if action == "remove" then
          layout.shred_list:remove_node(shred_id)
        end
      end
    end
    layout.shred_list:render()
  end
end

-- tail to parse logfile and trigger the above on a new line
local function shred_line(logfile)
  local line = ""
  vim.fn.jobstart({ "tail", "-F", tostring(logfile) }, {
    on_stdout = function(_, data, _)
      data[1] = line .. data[1]
      line = data[#data]
      data[#data] = nil
      shred_node(data[#data])
    end,
  })
end

-- run chuck vm in a job and putput stdout in a split as is
local function start_chuck(cmd, logfile)
  vim.fn.jobstart(cmd .. " 3>&1 2>&1 | tee " .. tostring(logfile), {
    on_stdout = function(_, data, _)
      for _, line in pairs(data) do
        layout.chuck_log:add_node(NuiTree.Node({ log = line }))
        layout.chuck_log:render()
      end
    end,
  })
end

function M.chuck_runner(cmd, logfile)
  start_chuck(cmd, logfile)
  shred_line(logfile)
  layout.chuck_layout:mount()
  vim.cmd("wincmd w")
end

-- FIX: implement a way to toggle the UI
-- toggle the NUI layout
-- function M.chuck_ui_toggle()
-- layout.chuck_layout:hide()
-- layout.chuck_layout:show()
-- end

-- utility used by exec
local function read_file(path)
  local file = assert(io.open(path, "rb"))
  local content = file:read("*all")
  file:close()
  return content
end

-- actually run the command passed to it
function M.exec(cmd, stdin)
  local tmp = os.tmpname()
  local pipe = assert(io.popen(cmd .. " > " .. tmp, "w"))

  if stdin then
    pipe:write(stdin)
  end

  pipe:close()

  local output = read_file(tmp)
  os.remove(tmp)

  return output
end

return M
