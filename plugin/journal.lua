local note = require('journal.notes')
local config = require('journal.config')

vim.api.nvim_create_user_command('Note', function(params)
  if params.args == '' then
    vim.ui.input({ prompt = 'Enter note title: ' }, function(input)
      note.create_note_command(input, params)
    end)
  else
    note.create_note_command(params.args, params)
  end
end, { range = true, nargs = '?', bang = true })

local augroup = vim.api.nvim_create_augroup('jorunal.nvim', { clear = true })
vim.api.nvim_create_autocmd('BufEnter', {
  pattern = '*.md',
  callback = function ()
    vim.opt_local.path:append { vim.fs.normalize(config.base_path) .. '/**' }
    vim.opt_local.suffixesadd:append { '.md', '.Monday.md', '-Tuesday.md', '-Wednesday.md', '-Thursday.md', '-Friday.md'}
  end,
  group = augroup,
})

