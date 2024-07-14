local M = {}

function M.autoformat_enabled()
  local autoformat = vim.g.autoformat
  return autoformat or autoformat == nil
end

function M.autoformat_info()
  local enabled = M.autoformat_enabled()
  local lines = {
    "# Auto format status",
    ("- [%s] global **%s**"):format(enabled and "x" or " ", enabled and "enabled" or "disabled"),
  }
  vim.notify(
    table.concat(lines, "\n"),
    vim.log.levels.INFO,
    { title = "Auto format (" .. (enabled and "enabled" or "disabled") .. ")" }
  )
end

function M.autoformat_toggle()
  vim.g.autoformat = not M.autoformat_enabled()
  M.autoformat_info()
end

return M
