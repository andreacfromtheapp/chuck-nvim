local utils = require "chuck-nvim.core.utils"
local M = {}

-- split window and start chuck --loop in a terminal
function M.chuck_loop()
  local cmd = "chuck --loop"

  utils.create_split_terminal(cmd)
end

-- check chuck status
function M.check_status()
  local cmd = "chuck --status"

  utils.exec(cmd)
end

-- print chuck detailed time information
function M.chuck_time()
  local cmd = "chuck --time"

  utils.exec(cmd)
end

-- check add current file to shreds
function M.add_shred()
  local cmd
  cmd = string.format("chuck --add %s", vim.fn.expand "%")

  utils.exec(cmd)
end

-- check remove a shred with id from shreds
function M.remove_shred()
  local cmd

  vim.ui.input({ prompt = "Shred(s) to remove: " }, function(input)
    cmd = string.format("chuck --remove %d", tonumber(input)) -- FIX: for some reason %d isn't working here
    utils.exec(cmd)
  end)
end

-- check replace a shred with the current buffer
function M.replace_shred()
  local cmd

  vim.ui.input({ prompt = "Shred to replace: " }, function(input)
    cmd = string.format("chuck --replace %d %s", tonumber(input), vim.fn.expand "%")
    utils.exec(cmd)
  end)
end

-- remove all shreds and reset the type system
function M.clear_vm()
  local cmd = "chuck --clear.vm"

  utils.exec(cmd)
end

-- remove all shreds and leave chuck vm running
function M.clear_shreds()
  local cmd = "chuck --remove.all"

  utils.exec(cmd)
end

-- quit chuck entirely
function M.exit()
  local cmd = "chuck --exit"

  utils.exec(cmd)
end

return M
