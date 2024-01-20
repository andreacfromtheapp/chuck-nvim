local layout = require("chuck-nvim.ui.layout")
local events = require("nui.utils.autocmd").event

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
    if string.match(line, "removing all") then
      action = "clear"
    end
  end
  return action
end

local function shred_set(line)
  local action = set_action(line)
  if line and action then
    layout.set_node(line, action)
    layout.shreds_tree:render()
  end
end

local function shred_lines(logfile)
  local line = ""
  vim.fn.jobstart({ "tail", "-f", tostring(logfile) }, {
    on_stdout = function(_, data, _)
      data[1] = line .. data[1]
      line = data[#data]
      data[#data] = nil
      if #data > 0 then
        shred_set(data[#data])
      end
    end,
  })
end

local function start_chuck(cmd, logfile)
  local chuck_cmd = string.format("terminal %s 3>&1 2>&1 | tee %s", cmd, logfile)
  vim.cmd(chuck_cmd)
end

function M.chuck_ui(cmd, logfile)
  layout.chuck_layout:mount()
  layout.chuck_pane:on(events.BufEnter, function()
    start_chuck(cmd, logfile)
  end, { once = true })
  layout.shred_pane:on(events.BufEnter, function()
    shred_lines(logfile)
  end, { once = true })
  vim.cmd("wincmd w")

  layout.chuck_layout:update(layout.update_layout)
end

local function read_file(path)
  local file = assert(io.open(path, "rb"))
  local content = file:read("*all")
  file:close()
  return content
end

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
