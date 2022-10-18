local M = {}

local config = require('journal.config')

function M.parse(date_str)
  local year, month, day = date_str:match(config.date_pattern.match)
  local date = {
    year = year,
    month = month,
    day = day,
  }
  date.day_of_the_week = os.date('%A', os.time(date))
  return date
end

function M.skip_weekend(today, dx)
  local factor = 24 * 60 * 60
  local time = today + (dx * factor)
  local day = os.date('%A', time)
  while day == 'Saturday' or day == 'Sunday' do
    time = time + (dx * factor)
    day = os.date('%A', time)
  end
  return time
end

return M
