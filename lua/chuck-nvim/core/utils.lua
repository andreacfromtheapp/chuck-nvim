local NuiTree = require("nui.tree")
local config = require("chuck-nvim.config")
local layout = require("chuck-nvim.ui.layout")
local shreds = require("chuck-nvim.core.shreds")

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

-- the following is needed to set the pane to last line
local function goto_lastline(bufnr)
  vim.api.nvim_buf_call(bufnr, function()
    vim.api.nvim_win_set_cursor(0, { vim.fn.line("$"), 1 })
  end)
end

-- refresh shred_list every second
local function refresh_shreds()
  local timer = vim.loop.new_timer()
  timer:start(0, 1000, function()
    vim.schedule(function()
      layout.shred_list:render()
    end)
  end)
end

-- this calls the layout to set NUI elements in the UI
local function shred_node(line)
  local action = set_action(line)
  if line and action then
    shreds.set_table(line, action)
    local nodes = layout.mknodes()
    layout.shred_list:set_nodes(nodes)
    layout.shred_list:render()
    goto_lastline(layout.shred_pane.bufnr)
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

-- run chuck vm in a job and output stdout in the chuck_pane
local function start_chuck(cmd, logfile)
  vim.fn.jobstart(cmd .. " 3>&1 2>&1 | tee " .. tostring(logfile), {
    on_stdout = function(_, data, _)
      for _, line in pairs(data) do
        layout.chuck_log:add_node(NuiTree.Node({ log = line }))
        layout.chuck_log:render()
        goto_lastline(layout.chuck_pane.bufnr)
      end
    end,
  })
end

-- main (launch chuck and the UI)
function M.chuck_runner(cmd, logfile)
  start_chuck(cmd, logfile)
  shred_line(logfile)
  layout.chuck_layout:mount()
  if config.user.layout == "chuck_on_top" then
    layout.chuck_layout:update(layout.chuck_on_top)
  end
  vim.cmd("wincmd w")
  refresh_shreds()
end

-- this doesn't make much sense, leaving it here for future ideas
-- function M.hide_ui()
--   layout.chuck_layout:hide()
-- end

-- this doesn't make much sense, leaving it here for future ideas
-- function M.show_ui()
--   layout.chuck_layout:show()
-- end

-- this doesn't make much sense, leaving it here for future ideas
-- function M.only_the_shreds()
--   layout.chuck_layout:update(layout.only_the_shreds)
-- end

-- this doesn't make much sense, leaving it here for future ideas
-- function M.only_the_chuckvm()
--   layout.chuck_layout:update(layout.only_the_chuckvm)
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
