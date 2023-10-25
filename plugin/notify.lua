_G.notifications = {}

local levels = vim.log.levels
local log_level_strings = {
  [levels.DEBUG] = "Debug",
  [levels.ERROR] = "Error",
  [levels.INFO] = "Info",
  [levels.TRACE] = 'Trace',
  [levels.WARN] = 'Warning',
}

if vim.fn.has("mac") == 1 then
  function send_notification(title, message)
    local script_template = 'display notification "%s" with title "%s" subtitle "%s"'
    local script = string.format(script_template, message, title, "it is a notification")
    vim.fn.system({'osascript', '-e', script})
  end
elseif vim.fn.has("win32") == 1 then
  function send_notification(title, message)
    local script_template = [[New-BurntToastNotification -Text '%s', '%s' -AppLogo  C:\Users\alanr\scoop\apps\neovim\current\share\icons\hicolor\128x128\apps\nvim.png]]
    local script = string.format(script_template, title, message)
    vim.fn.system({'pwsh', '-c', script})
  end
else
  function send_notification(title, message)
    vim.fn.echo(title .. ' ' .. message)
  end
end

vim.notify = function (message, level, opts)
  opts = opts or {}
  local title = (log_level_strings[level] or 'Notification') .. ((' ' .. opts.title) or '')
  table.insert(_G.notifications, message)
  send_notification(title, message)
end
