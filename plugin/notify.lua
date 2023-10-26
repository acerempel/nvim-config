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

send_notification_bytes = string.dump(send_notification)

vim.loop.disable_stdio_inheritance()

vim.notify = function (message, level, opts)
  opts = opts or {}
  local title = (log_level_strings[level] or 'Notification') .. (opts.title and (' ' .. opts.title) or '')
  table.insert(_G.notifications, message)
  local task_func = function(send_notification, title, message)
    assert(loadstring(send_notification))(title, message)
  end
  local task = vim.loop.new_work(task_func, function(...) return ... end)
  task:queue(send_notification_bytes, title, message)
end
