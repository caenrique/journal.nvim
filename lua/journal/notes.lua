local M = {}

local file = require('journal.file')
local config = require('journal.config')
local path = require('journal.path')

function M.create_note_command(name, params)
  if name == '' then
    return
  end

  local fname = name:gsub("%s+", "-"):lower() .. config.extension
  local from = vim.api.nvim_buf_get_name(0)

  if params.range > 0 then
    local text = vim.api.nvim_buf_get_lines(0, params.line1 - 1, params.line2, true)
    if params.bang then
      vim.api.nvim_buf_set_lines(0, params.line1 - 1, params.line2, true, {})
    end
    file.open(path.make(vim.fs.normalize(config.base_path), config.notes_dir), fname,
      { metadata = { linked_from = path.relative_to(from, config.base_path) }, lines = text, title = title })
  else
    local buf = file.open(path.make(vim.fs.normalize(config.base_path), config.notes_dir), fname, { metadata = true, title = title })
    vim.api.nvim_win_set_buf(0, buf)
  end
end

return M
