local M = {}

local config = require('journal.config')
local Path = require('journal.path')

function M.format_link(path, title)
  vim.fn.setreg('+',
    '[' .. (title or '') .. '](' .. Path.relative_to(path, config.base_path) .. ')')
end

function M.set_clipboard(content)
  vim.fn.setreg(config.cliboard_reg, content)
end

function M.insert_lines(buffer, lines, at)
  vim.api.nvim_buf_set_lines(buffer, at, at, true, lines)
end

return M
