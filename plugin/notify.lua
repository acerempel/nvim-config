_G.notifications = {}
local levels = vim.log.levels
local log_level_strings = {
  [levels.DEBUG] = "Debug",
  [levels.ERROR] = "Error",
  [levels.INFO] = "Info",
  [levels.TRACE] = 'Trace',
  [levels.WARN] = 'Warning',
}

function spawn_process(prog, args)
  function on_output(err, data)
    assert(not err, err)
    if data then
      vim.schedule(function ()
        vim.api.nvim_command('echomsg "' .. data .. '"')
      end)
    end
  end

  function on_exit(code, signal)
    if code ~= 0 then
      vim.schedule(function ()
        vim.api.nvim_command('echoerr "Sending notification failed with exit code '.. code .. ' signal ' .. signal .. '"')
      end)
    end
  end

  local output = vim.loop.new_pipe()
  local options = {args = args, hide = true, stdio = {nil, output, output}}
  vim.loop.spawn(prog, options, on_exit)

  vim.loop.read_start(output, on_output)
end

if vim.fn.has("mac") == 1 then
  function send_notification(title, message)
    local script_template = 'display notification "%s" with title "%s" subtitle "%s"'
    local script = string.format(script_template, message, title, "it is a notification")
    spawn_process('osascript', {'-e', script})
  end
elseif vim.fn.has("win32") == 1 then
  function pwsh_escape_single(str)
    return string.gsub(str, "'", "''")
  end
  function send_notification(title, message)
    local script_template = [[New-BurntToastNotification -Text '%s', '%s' -AppLogo  C:\Users\alanr\scoop\apps\neovim\current\share\icons\hicolor\128x128\apps\nvim.png]]
    local script = string.format(script_template, pwsh_escape_single(title), pwsh_escape_single(message))
    spawn_process('pwsh', {'-c', script})
  end
else
  function send_notification(title, message)
    local command = string.format([[echomsg '%s' '%s']], pwsh_escape_single(title), pwsh_escape_single(message))
    vim.api.nvim_command(command)
  end
end

vim.loop.disable_stdio_inheritance()

vim.notify = function (message, level, opts)
  opts = opts or {}
  local title = (log_level_strings[level] or 'Notification') .. (opts.title and (' ' .. opts.title) or '')
  table.insert(_G.notifications, message)
  send_notification(title, message)
end
