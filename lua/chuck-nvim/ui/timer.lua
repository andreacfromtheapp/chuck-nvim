local M = {}

---@type table
local timers = {}

-- add timer to table
local function init_timer(timer_id)
  timers[timer_id] = { elapsed_time = 0 }
end

-- increment elapsed_time by 1 second
local function update_timer(timer_id)
  timers[timer_id].elapsed_time = timers[timer_id].elapsed_time + 1
end

-- start a timer when a specific shred is added to the list
function M.start_timer(timer_id)
  init_timer(timer_id)
  local timer = vim.loop.new_timer()
  timer:start(0, 1000, function()
    update_timer(timer_id)
  end)
end

-- stop the specific shred timer when it is removed from the list
function M.stop_timer(timer_id)
  local timer = timers[timer_id]
  if timer ~= nil then
    timer:stop()
    timer:close()
    timer = nil
  end
end

-- FIX: rely on stop_timer for this, DRY.
-- stop all timers and empty table
function M.stop_all_timers(timer_id)
  for timer in pairs(timers) do
    -- M.stop_timer(timer.timer_id)
    timer:stop()
    timer:close()
    timers[timer_id] = nil
  end
end

-- reset the current timer (when a specific shred is replaced)
function M.reset_timer(timer_id)
  M.stop_timer(timer_id)
  M.start_timer(timer_id)
end

-- format a given number of seconds into hours, minutes, and seconds.
local function format_time(secs)
  local hours = string.format("%02d", math.floor(secs / 3600))
  local minutes = string.format("%02d", math.floor((secs % 3600) / 60))
  local seconds = string.format("%02d", secs % 60)
  return hours .. ":" .. minutes .. ":" .. seconds
end

-- return "HH:MM:SS" if the timer is ongoing, else return "00:00:00"
function M.get_time(timer_id)
  local timer = timers[timer_id]
  if timer ~= nil and timer.elapsed_time > 0 then
    return format_time(timer.elapsed_time)
  end
  return "00:00:00"
end

return M
