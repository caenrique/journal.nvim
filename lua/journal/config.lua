local M = {}

local function defaults()
  return {
    journal_dir = "journal",
    notes_dir = "notes",
    base_path = vim.fs.normalize('~/Notes'),
    extension = '.md',
    date_pattern = {
      new_date = "%Y-%m-%d",
      match = '(%d+)-(%d+)-(%d+)'
    },
    create = {
      metadata = true,
      copy_link = true,
      edit_if_exists = true,
    }
  }
end

local config = defaults()

function M.setup(opts)
  local new_config = vim.tbl_deep_extend('force', {}, defaults(), opts or {})

  for _, key in ipairs(vim.tbl_keys(config)) do
    config[key] = nil
  end
  for key, val in pairs(new_config) do
    config[key] = val
  end
end

return setmetatable(config, { __index = M })
