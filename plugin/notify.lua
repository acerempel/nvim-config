_G.notifications = {}

local levels = vim.log.levels
local log_level_strings = {
  [levels.DEBUG] = "Debug",
  [levels.ERROR] = "Error",
  [levels.INFO] = "Info",
  [levels.TRACE] = 'Trace',
  [levels.WARN] = 'Warning',
}

vim.notify = function (message, level, opts)
  local script_template = 'display notification "%s" with title "%s" subtitle "%s"'
  local title = log_level_strings[level] .. ' from Neovim'
  local script = string.format(script_template, message, title, "it is a notification")
  table.insert(_G.notifications, message)
  vim.fn.system({'osascript', '-e', script})
end
