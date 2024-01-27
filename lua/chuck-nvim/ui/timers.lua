local M = {}

--- give it a timer object like akisho does to be able to use stop
---@type table
local timers = {}

-- add timer to table
local function init_timer(timer_id)
  if not vim.tbl_contains(timers, timer_id) then
    timers[timer_id] = { elapsed_time = 0 }
  end
end

-- increment elapsed_time by 1 second
local function update_timer(timer_id)
  timers[timer_id].elapsed_time = timers[timer_id].elapsed_time + 1
  print(timers[timer_id].elapsed_time)
end

-- start a timer when a specific shred is added to the list
local function start_timer(timer_id)
  init_timer(timer_id)
  local timer = vim.loop.new_timer()
  timer:start(0, 1000, function()
    vim.schedule(function()
      update_timer(timer_id)
    end)
  end)
end

-- stop the specific shred timer when it is removed from the list
local function stop_timer(timer_id)
  local timer = timers[timer_id]
  if timer ~= nil then
    timer:stop()
    timer:close()
    timer = nil
  end
end

-- FIX: rely on stop_timer for this, DRY.
-- stop all timers and empty table
local function stop_all_timers(timer_id)
  for timer in pairs(timers) do
    timer:stop()
    timer:close()
    timers[timer_id] = nil
  end
end

-- reset the current timer (when a specific shred is replaced)
local function reset_timer(timer_id)
  stop_timer(timer_id)
  start_timer(timer_id)
end

function M.set_timer(timer_id, action)
  if action ~= nil and timer_id ~= nil then
    if action == "clear" then
      stop_all_timers(timer_id)
    end

    if action == "add" and timers[timer_id] == nil then
      start_timer(timer_id)
    end

    if action == "replace" then
      reset_timer(timer_id)
    end

    if action == "remove" then
      stop_timer(timer_id)
    end
  end
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
