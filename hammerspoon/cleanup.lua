-- hammerspoon/cleanup.lua
-- Shortcuts and functions for clearing cache and temporary files
local obj = {}

-- List of cache and temp directories to clean
local cacheDirs = {
  "~/Library/Caches",
  "~/Library/Application Support/Code/CachedData", -- VS Code cache
  "~/Library/Application Support/Code/Cache", -- VS Code cache
  "~/Library/Application Support/Slack/Service Worker/CacheStorage", -- Slack cache
  "~/Library/Application Support/Google/Chrome/Default/Cache", -- Chrome cache
  "~/Library/Application Support/com.apple.sharedfilelist", -- Recent items cache
  "/tmp"
}

-- Function to clear specific cache directory
local function clearCacheDir(dir)
  local expandedDir = string.gsub(dir, "^~", os.getenv("HOME"))
  local cmd = string.format("rm -rf '%s'/*", expandedDir)
  local result = hs.execute(cmd)
  if result then
    hs.alert.show("Cleared cache: " .. dir)
    return true
  else
    hs.alert.show("Error clearing cache: " + dir)
    return false
  end
end

-- Function to clear all caches
local function clearAllCaches()
  local totalCleared = 0
  for _, dir in ipairs(cacheDirs) do
    local expandedDir = string.gsub(dir, "^~", os.getenv("HOME"))
    local beforeSize = hs.execute("du -sh '" .. expandedDir ..
                                      "' 2>/dev/null | cut -f1")
    local result = hs.execute("rm -rf '" .. expandedDir .. "'/*")
    if result and result ~= "" then
      local afterSize = hs.execute("du -sh '" .. expandedDir ..
                                       "' 2>/dev/null | cut -f1")
      -- Compare sizes to confirm cleanup
      if beforeSize ~= afterSize then totalCleared = totalCleared + 1 end
    end
  end
  hs.alert.show("Cleared " .. totalCleared .. " cache locations")
end

-- Function to clear DNS cache
local function clearDNSCache()
  local cmd = "sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder"
  local result = hs.execute(cmd)
  if result then
    hs.alert.show("DNS cache cleared")
  else
    hs.alert.show("Error clearing DNS cache")
  end
end

-- Function to clear system logs
local function clearSystemLogs()
  local logCmd =
      "sudo rm -rf /var/log/asl/*.asl; sudo rm -rf /Library/Logs/DiagnosticReports/*; rm -rf ~/Library/Logs/DiagnosticReports/*"
  local result = hs.execute(logCmd)
  if result then
    hs.alert.show("System logs cleared")
  else
    hs.alert.show("Error clearing system logs")
  end
end

-- Function to clear temporary files
local function clearTempFiles()
  local tempDirs = {
    "/tmp",
    "/private/var/tmp",
    "~/Library/Caches/com.apple.helpd"
  }
  local count = 0

  for _, dir in ipairs(tempDirs) do
    local expandedDir = string.gsub(dir, "^~", os.getenv("HOME"))
    local cmd =
        string.format("find '%s' -type f -mtime +7 -delete", expandedDir)
    local result = hs.execute(cmd)
    if result then count = count + 1 end
  end
  hs.alert.show("Cleaned " .. count .. " temp directories")
end

function obj.init(hyper)
  -- Hotkey to clear all caches (Hyper + C)
  hs.hotkey.bind(hyper, "c", function()
    hs.alert.show("Clearing caches...")
    clearAllCaches()
  end)

  -- Hotkey to clear DNS cache (Hyper + Shift + C)
  hs.hotkey.bind({"cmd", "alt", "shift"}, "C", function()
    hs.alert.show("Clearing DNS cache...")
    clearDNSCache()
  end)

  -- Hotkey to clear system logs (Hyper + Option + C)
  hs.hotkey.bind({"cmd", "alt", "ctrl"}, "C", function()
    hs.alert.show("Clearing system logs...")
    clearSystemLogs()
  end)

  -- Hotkey to clear temporary files (Hyper + Cmd + C)
  hs.hotkey.bind({"cmd", "ctrl", "shift"}, "C", function()
    hs.alert.show("Clearing temporary files...")
    clearTempFiles()
  end)

  -- Quick clean command (Hyper + X) that clears common caches
  hs.hotkey.bind(hyper, "x", function()
    hs.alert.show("Quick cleanup...")
    local quickDirs = {
      "~/Library/Caches",
      "~/Library/Application Support/Code/CachedData",
      "~/Library/Application Support/Code/Cache"
    }

    for _, dir in ipairs(quickDirs) do
      local expandedDir = string.gsub(dir, "^~", os.getenv("HOME"))
      hs.execute("rm -rf '" .. expandedDir .. "'/*")
    end

    hs.alert.show("Quick cleanup completed")
  end)
end

return obj
