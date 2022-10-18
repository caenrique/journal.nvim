local M = {}

local Path = require('plenary.path')

function M.relative_to(path, base_path)
  return vim.fs.normalize(path):gsub(base_path .. '/', '')
end

function M.make(...)
  return Path:new(...):absolute()
end

return M
