local M = {}

function M.autoformat_enabled()
  local autoformat = vim.g.autoformat
  return autoformat or autoformat == nil
end

return M
