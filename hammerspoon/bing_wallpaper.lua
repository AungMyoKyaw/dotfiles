-- Bing Daily Wallpaper for Hammerspoon
-- Automatically sets 4K Bing wallpaper daily
local bingWallpaper = {}
local wallpaperDir = os.getenv("HOME") .. "/.hammerspoon/wallpapers/"
local logFile = wallpaperDir .. "bing_wallpaper.log"
local market = "en-US" -- You can change this: en-US, zh-CN, ja-JP, etc.

-- Create wallpaper directory if it doesn't exist
function ensureWallpaperDir()
  local cmd = string.format("mkdir -p '%s'", wallpaperDir)
  os.execute(cmd)
end

-- Log function for debugging
function log(message)
  local timestamp = os.date("%Y-%m-%d %H:%M:%S")
  local logEntry = string.format("[%s] %s\n", timestamp, message)

  local file = io.open(logFile, "a")
  if file then
    file:write(logEntry)
    file:close()
  end
end

-- Get Bing wallpaper JSON data
function getBingWallpaperInfo()
  local url = string.format(
                  "https://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1&mkt=%s",
                  market)
  local cmd = string.format("curl -s \"%s\"", url)

  local handle = io.popen(cmd)
  if not handle then
    log("Failed to execute curl command")
    return nil
  end

  local result = handle:read("*a")
  handle:close()

  if not result or result == "" then
    log("No data received from Bing API")
    return nil
  end

  -- Parse JSON (simple parsing)
  local success, data = pcall(function() return hs.json.decode(result) end)

  if not success or not data or not data.images or #data.images == 0 then
    log("Failed to parse Bing JSON data")
    return nil
  end

  return data.images[1]
end

-- Download wallpaper with highest available resolution (4K or higher)
function downloadWallpaper(imageData)
  -- Get base URL
  local baseUrl = imageData.urlbase
  if not baseUrl then
    log("No urlbase in image data")
    return nil
  end

  -- Try resolutions in order of preference (highest to lowest, but not below 4K)
  local resolutions = {
    "7680x4320", -- 8K UHD
    "5120x2880", -- 5K
    "3840x2160" -- 4K UHD
  }

  local imageUrl = nil
  for _, resolution in ipairs(resolutions) do
    local testUrl = string.format("https://www.bing.com%s_%s.jpg", baseUrl,
                                  resolution)

    -- Test if URL exists by making a HEAD request
    local testCmd = string.format(
                        "curl -s -I \"%s\" | grep \"HTTP/.* 200\" > /dev/null",
                        testUrl)
    local testResult = os.execute(testCmd)

    if testResult == 0 then
      imageUrl = testUrl
      log("Found high resolution image: " .. resolution)
      break
    end
  end

  -- Fallback to original resolution if no high-res found
  if not imageUrl then
    log("No high resolution found, using original resolution")
    imageUrl = "https://www.bing.com" .. imageData.url
  end

  -- Create filename with date and title
  local title = imageData.title or "wallpaper"
  -- Clean title for filename
  title = title:gsub("[^%w%s%-]", ""):gsub("%s+", "_")
  local filename = string.format("%s_%s.jpg", os.date("%Y-%m-%d"), title)
  local filepath = wallpaperDir .. filename

  -- Download the image
  local cmd = string.format("curl -s -o \"%s\" \"%s\"", filepath, imageUrl)
  local result = os.execute(cmd)

  if result ~= 0 then
    log("Failed to download wallpaper from: " .. imageUrl)
    return nil
  end

  log("Downloaded high resolution wallpaper: " .. filename)
  return filepath
end

-- Set desktop wallpaper
function setWallpaper(filepath)
  if not filepath then
    log("No wallpaper file path provided")
    return false
  end

  -- Check if file exists
  local file = io.open(filepath, "r")
  if not file then
    log("Wallpaper file does not exist: " .. filepath)
    return false
  end
  file:close()

  -- Set wallpaper for all screens
  local screens = hs.screen.allScreens()
  for _, screen in ipairs(screens) do hs.screen.setWallpaper(filepath, screen) end

  log("Set wallpaper: " .. filepath)
  return true
end

-- Check if today's wallpaper already exists
function getTodaysWallpaper()
  local today = os.date("%Y-%m-%d")
  local pattern = wallpaperDir .. today .. "_*.jpg"

  local cmd = string.format("ls \"%s\" 2>/dev/null | head -1", pattern)
  local handle = io.popen(cmd)
  if not handle then return nil end

  local result = handle:read("*a"):gsub("%s+$", "")
  handle:close()

  if result and result ~= "" then
    local file = io.open(result, "r")
    if file then
      file:close()
      return result
    end
  end

  return nil
end

-- Main function to update wallpaper
function bingWallpaper.updateBingWallpaper()
  log("Starting Bing wallpaper update")

  -- Check if we already have today's wallpaper
  local existingWallpaper = getTodaysWallpaper()
  if existingWallpaper then
    log("Today's wallpaper already exists: " .. existingWallpaper)
    setWallpaper(existingWallpaper)
    return true
  end

  -- Get wallpaper info from Bing
  local imageData = getBingWallpaperInfo()
  if not imageData then
    log("Failed to get wallpaper info from Bing")
    return false
  end

  -- Download 4K wallpaper
  local wallpaperPath = downloadWallpaper(imageData)
  if not wallpaperPath then
    log("Failed to download wallpaper")
    return false
  end

  -- Set as wallpaper
  local success = setWallpaper(wallpaperPath)
  if success then
    hs.alert.show("Bing high-res wallpaper updated: " ..
                      (imageData.title or "Unknown"))
  else
    hs.alert.show("Failed to set wallpaper")
  end

  return success
end

-- Clean up old wallpapers (keep last 7 days)
function cleanupOldWallpapers()
  local cmd = string.format(
                  "find \"%s\" -name \"*.jpg\" -mtime +7 -delete 2>/dev/null",
                  wallpaperDir)
  os.execute(cmd)
  log("Cleaned up old wallpapers")
end

-- Initialize the Bing wallpaper module
function bingWallpaper.init(hyper)
  ensureWallpaperDir()

  -- Update wallpaper immediately
  bingWallpaper.updateBingWallpaper()

  -- Schedule daily update at 9:00 AM
  bingWallpaper.dailyTimer = hs.timer.new(3600, function() -- Check every hour
    local hour = tonumber(os.date("%H"))
    local minute = tonumber(os.date("%M"))

    -- Run at 9:00 AM
    if hour == 9 and minute == 0 then
      bingWallpaper.updateBingWallpaper()
      cleanupOldWallpapers()
    end
  end)
  bingWallpaper.dailyTimer:start()

  -- Manual update hotkey (Hyper+W)
  hs.hotkey.bind(hyper, "w", function()
    bingWallpaper.updateBingWallpaper()
    hs.alert.show("Bing high-res wallpaper updated manually")
  end)

  hs.alert.show("Bing high-res wallpaper monitor started")
  log("Bing wallpaper module initialized")
end

-- Stop wallpaper monitoring
function bingWallpaper.stop()
  if bingWallpaper.dailyTimer then
    bingWallpaper.dailyTimer:stop()
    bingWallpaper.dailyTimer = nil
  end
  log("Bing wallpaper module stopped")
end

return bingWallpaper
