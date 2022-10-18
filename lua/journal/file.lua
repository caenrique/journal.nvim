local M = {}

local config = require('journal.config')
local Path = require('journal.path')
local metadata = require('journal.metadata')
local utils = require('journal.utils')

local function file_exists(base_dir, filename)
  print('base dir: ' .. base_dir)
  print('filename: ' .. filename)
  local result = vim.fs.find(filename, { path = base_dir, type = 'file' })
  print('File exits check: ' .. vim.inspect(result))
  return next(result) ~= nil
end

local function buffer_exists(base_dir, filename)
  local result = vim.fn.buflisted(vim.fs.normalize(Path.make(base_dir, filename)))
  print('buffer exists check: ' .. vim.inspect(result))
  return result > 0
end

local function edit_file(filename)
  vim.cmd.edit(filename)
  return vim.api.nvim_win_get_buf(0)
end

function M.open(base_dir, filename, op)
  local opts = vim.tbl_deep_extend('force', config.create, op or {})

  if file_exists(base_dir, filename) then
    print('File ' .. Path.make(base_dir, filename) .. ' already exists!')
    return edit_file(Path.make(base_dir, filename))
  elseif buffer_exists(base_dir, filename) then
    print('Buffer with name ' .. Path.make(base_dir, filename) .. ' already exists')
    return edit_file(Path.make(base_dir, filename))
  else
    print('File ' .. Path.make(base_dir, filename) .. ' does not exists yet')
    if not vim.fn.isdirectory(base_dir) then
      vim.fn.mkdir(base_dir, 'p')
    end

    local buffer = vim.api.nvim_create_buf(true, false)
    vim.api.nvim_buf_set_name(buffer, Path.make(base_dir, filename))

    if opts.metadata then
      local m = {}
      if type(opts.metadata) == "table" then
        m = metadata.get_metadata(opts.title or filename, opts.metadata)
      else
        m = metadata.get_metadata(opts.title or filename, {})
      end
      utils.insert_lines(buffer, m, 0)
    end

    if opts.lines then
      utils.insert_lines(buffer, opts.lines, -1)
    end

    -- vim.api.nvim_buf_call(buffer, function()
    --   vim.cmd.write()
    -- end)

    if opts.copy_link then
      vim.fn.setreg('+',
        '[' .. (opts.title or '') .. '](' .. Path.relative_to(base_dir, config.base_path) .. '/' .. filename .. ')')
    end

    return buffer
  end

end

return M
