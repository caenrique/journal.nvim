local M = {}

local config = require('journal.config')
local delim = '---'

function M.get_metadata(title, extra_data)
  local created_at = os.date(config.date_pattern.new_date .. ' %X', os.time())
  local lines = {}
  table.insert(lines, delim)
  table.insert(lines, 'title: ' .. title)
  table.insert(lines, 'created_at: ' .. created_at)
  for k, v in pairs(extra_data or {}) do
    table.insert(lines, k .. ': ' .. v)
  end
  table.insert(lines, delim)
  return lines
end

return M
