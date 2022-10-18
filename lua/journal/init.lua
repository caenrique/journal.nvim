local M = {}

local dates = require('journal.date')
local file = require('journal.file')
local config = require('journal.config')
local Path = require('journal.path')

local function open_journal_for_date(date)
  local base_dir = Path.make(vim.fs.normalize(config.base_path), config.journal_dir, tostring(date.year), tostring(date.month))
  local filename = date.day .. '-' .. os.date('%A', os.time(date)) .. config.extension
  local title = 'Journal of ' .. os.date(config.date_pattern.new_date, os.time(date))
  local buffer = file.open(base_dir, filename, { title = title, metadata = { tags = '#journal' } })
  vim.api.nvim_win_set_buf(0, buffer)
end

function M.setup(conf)
  config.setup(conf)
end

function M.open_journal(date_str)
  local date = dates.parse(date_str)
  open_journal_for_date(date)
end

function M.open_journal_today()
  local today = os.date("!*t")
  open_journal_for_date(today)
end

function M.open_journal_yesterday()
  local yesterday = os.date("!*t", dates.skip_weekend(os.time(), -1))
  open_journal_for_date(yesterday)
end

function M.open_journal_tomorrow()
  local tomorrow = os.date("!*t", dates.skip_weekend(os.time(), 1))
  open_journal_for_date(tomorrow)
end

return M
