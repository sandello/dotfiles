-- Automatically reload configuration upon file change.

function onHammerspoonDotfilesChanged(files)
  local doReload = false
  for _, file in pairs(files) do
    if file:sub(-4) == ".lua" then
      doReload = true
    end
  end
  if doReload then
    hs.reload()
    hs.alert.show("Reloaded Hammerspoon configuration")
  end
end

hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", onHammerspoonDotfilesChanged):start()

-- Window Management.
-- TODO: Migrate to https://www.hammerspoon.org/docs/hs.grid.html.

hs.window.animationDuration = 0

hs.hotkey.bind({"cmd", "alt"}, "left", function()
  local window = hs.window.focusedWindow()
  local screen = window:screen()
  local max = screen:frame()
  local frame = {x=max.x, y=max.y, w=max.w / 2, h=max.h}
  window:setFrame(frame)
end)

hs.hotkey.bind({"cmd", "alt"}, "right", function()
  local window = hs.window.focusedWindow()
  local screen = window:screen()
  local max = screen:frame()
  local frame = {x=max.x + max.w / 2, y=max.y, w=max.w / 2, h=max.h}
  window:setFrame(frame)
end)

hs.hotkey.bind({"cmd", "alt"}, "up", function()
  local window = hs.window.focusedWindow()
  local screen = window:screen()
  local max = screen:frame()
  local frame = {x=max.x, y=max.y, w=max.w, h=max.h}
  window:setFrame(frame)
end)

hs.hotkey.bind({"cmd", "alt"}, "down", function()
  local window = hs.window.focusedWindow()
  local screen = window:screen()
  local max = screen:frame()
  local frame = {x=max.x + max.w / 4, y=max.y + max.h / 4, w=max.w / 2, h=max.h / 2}
  window:setFrame(frame)
end)

hs.hotkey.bind({"cmd", "alt", "shift"}, "up", function()
  local window = hs.window.focusedWindow()
  local screen = window:screen()
  local max = screen:frame()
  local frame = {x=max.x, y=max.y, w=max.w, h=max.h / 2}
  window:setFrame(frame)
end)

hs.hotkey.bind({"cmd", "alt", "shift"}, "down", function()
  local window = hs.window.focusedWindow()
  local screen = window:screen()
  local max = screen:frame()
  local frame = {x=max.x, y=max.y + max.h / 2, w=max.w, h=max.h / 2}
  window:setFrame(frame)
end)
