local M = {}

---store timers to be able to manage them, and the data we need
--@type table<Timer, number>
local timers = {}

-- add timer to table
local function init_timer(timer, timer_id)
  if timers[timer_id] == nil then
    timers[timer_id] = { timer = timer, elapsed_time = 0 }
  end
end

-- increment elapsed_time by 1 second
local function update_timer(timer_id)
  timers[timer_id].elapsed_time = timers[timer_id].elapsed_time + 1
end

-- start a timer when a specific shred is added to the list
local function start_timer(timer_id)
  local timer = vim.loop.new_timer()
  init_timer(timer, timer_id)
  timer:start(0, 1000, function()
    update_timer(timer_id)
  end)
end

-- stop the specific shred timer when it is removed from the list
local function stop_timer(timer_id)
  local timer = timers[timer_id].timer
  if timer ~= nil then
    timer:stop()
    timer:close()
    timer[timer_id] = nil
  end
end

-- stop all timers and empty table
local function stop_all_timers()
  for timer_id, _ in pairs(timers) do
    stop_timer(timer_id)
  end
end

-- replace the current timer with another of the same id
local function replace_timer(timer_id)
  stop_timer(timer_id)
  start_timer(timer_id)
end

function M.set_timer(timer_id, action)
  if action ~= nil and timer_id ~= nil then
    if action == "clear" then
      stop_all_timers()
    end

    if action == "add" then
      start_timer(timer_id)
    end

    if action == "replace" then
      replace_timer(timer_id)
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
  return format_time(timer.elapsed_time)
end

return M
