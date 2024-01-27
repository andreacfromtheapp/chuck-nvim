local M = {}

local timer
local elapsed_time = 0

-- Starts a timer when a specific shred is added to the list
function M.start_timer()
  timer = vim.loop.new_timer()
  timer:start(0, 1000, function()
    elapsed_time = elapsed_time + 1
  end)
end

-- Stops the specific shred timer when it is removed from the list
function M.stop_timer()
  if timer then
    timer:stop()
    timer:close()
    timer = nil
  end
end

-- Resets the current timer (when a specific shred is replaced)
function M.reset_timer()
  M.stop_timer()
  M.start_timer()
end

-- Formats a given number of seconds into hours, minutes, and seconds.
local function format_time(secs)
  local hours = string.format("%02d", math.floor(secs / 3600))
  local minutes = string.format("%02d", math.floor((secs % 3600) / 60))
  local seconds = string.format("%02d", secs % 60)
  return hours .. ":" .. minutes .. ":" .. seconds
end

-- Return a string "HH:MM:SS" if the timer is ongoing, or "00:00:00" if the timer is not.
function M.get_time()
  if elapsed_time > 0 then
    return format_time(elapsed_time)
  end
  return "00:00:00"
end

-- Return the M table.
return M
