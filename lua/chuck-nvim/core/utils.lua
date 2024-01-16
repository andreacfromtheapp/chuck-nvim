local layout = require "chuck-nvim.core.layout"
local shreds = require "chuck-nvim.core.shreds"

local M = {}

local function shred_lines(logfile)
  local file = assert(io.open(logfile, "r"))
  local line = file:read "*line"

  while line do
    shreds.set_table(line)
    line = file:read "*line"
  end

  file:close()
end

local function start_chuck(cmd, logfile)
  local chuck_cmd = string.format("terminal %s 3>&1 2>&1 | tee %s", cmd, logfile)
  vim.cmd(chuck_cmd)
end

function M.chuck_split(cmd, logfile)
  layout.chuck_layout:mount()
  layout.chuck_pane:on(layout.event.BufEnter, function() start_chuck(cmd, logfile) end, { once = true })
  layout.shred_pane:on(layout.event.BufEnter, function() shred_lines(logfile) end, { once = true })
  layout.chuck_layout:update(layout.update_layout)
  vim.cmd "wincmd w"

  -- FIX: this is a workaound until I can figure out the right event to use to
  -- trigger the callback functions on layout mount in the above code.
  vim.cmd "wincmd w"
  vim.cmd "wincmd w"
  vim.cmd "wincmd w"

  -- FIX: nui table idea
  -- layout.shreds_table:render()
end

local function read_file(path)
  local file = assert(io.open(path, "rb"))
  local content = file:read "*all"
  file:close()
  return content
end

function M.exec(cmd, stdin)
  local tmp = os.tmpname()
  local pipe = assert(io.popen(cmd .. " > " .. tmp, "w"))

  if stdin then pipe:write(stdin) end

  pipe:close()

  local output = read_file(tmp)
  os.remove(tmp)

  return output
end

return M
