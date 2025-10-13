# Hammerspoon Configuration

**🎉 UPDATE (Sept 2025):** Text replacement has been completely fixed and rewritten! All espanso-like functionality now works perfectly. This comprehensive configuration includes window management, text replacement, performance monitoring, and automation tools.

This folder contains Hammerspoon configuration and helper modules used for window management, text replacement, and small productivity helpers.

## 📋 Table of Contents

1. [Quick Start Guide](#-quick-start-guide)
2. [Hotkeys and Features](#-hotkeys-and-features)
3. [Text Replacement System](#-text-replacement-system-espanso-replacement)
4. [Sensitive Text Replacements](#-sensitive-text-replacements)
5. [Window Management](#-window-management)
6. [Performance Monitoring](#-performance-monitoring)
7. [AutoQuit Features](#-autoquit-features)
8. [Automation Features](#-automation-features)
9. [Configuration](#-configuration)
10. [Troubleshooting](#-troubleshooting)

---

## 🚀 Quick Start Guide

### Step 1: Reload Hammerspoon

Choose one method:

#### Method A: Keyboard Shortcut (Easiest)

Press: **`Cmd + Alt + Ctrl + Shift + R`** (Hyper+R)

#### Method B: Menu Bar

1. Click the Hammerspoon icon in your menu bar
2. Select "Reload Config"

#### Method C: Console

1. Click Hammerspoon icon → Console
2. Type: `hs.reload()`
3. Press Enter

### Step 2: Quick Test

Open any text editor (Notes, TextEdit, VS Code, etc.) and try these:

#### Test 1: Emoji 🔥

Type: `:fire ` (don't forget the space!)
Expected: Should become `🔥 `

#### Test 2: Date 📅

Type: `:date `
Expected: Should become something like `30-Sep-2025 `

#### Test 3: Another Emoji 😁

Type: `:hee `
Expected: Should become `😁 `

### Step 3: Verify It Works

If all three tests work, **CONGRATULATIONS! ✅**

Your text replacement is working perfectly!

---

## ⌨️ Hotkeys and Features

### Primary Shortcuts

- **Hyper key**: Cmd+Alt+Ctrl+Shift
- **Hyper+R**: Reload Hammerspoon config
- **Hyper+T**: Toggle text replacement on/off
- **Hyper+Space**: App chooser (favorite apps)
- **Hyper+t/s/e/n/f**: Launch or focus iTerm/Safari/VS Code/Notes/Finder
- **Hyper+Q**: Manually quit idle applications (AutoQuit)
- **Hyper+I**: Show monitored apps and idle time (AutoQuit)

### Window Management Mode (Hyper+M)

- **Hyper+M**: Enter Window Management Mode
- In Window Management Mode:
  - h/j/k/l or arrow keys: snap window
  - f: maximize
  - c: center
  - - / Shift+= : resize down/up
  - = : reset to original size
  - Shift+N: move focused window to next screen
  - q/Esc: exit mode

### Text Replacement Controls

- **Hyper+T**: Toggle text replacement on/off
- **Hyper+A**: Toggle async network/shell replacements
- **Hyper+D**: Toggle debug mode
- **Hyper+S**: Show usage statistics
- **Hyper+L**: List all available patterns (in console)

### Performance Monitoring

- **Hyper+P**: Toggle compact/expanded menubar display
- **Hyper+Cmd+Alt+Ctrl+A**: Open Activity Monitor
- **Hyper+Cmd+Alt+Ctrl+K**: Show top CPU processes in chooser

---

## 📝 Text Replacement System (Espanso Replacement)

### Overview

Complete text expansion system that replaces espanso functionality with enhanced performance and features.

### Key Features

✅ **Text Expansion**: Type shortcuts that automatically expand to longer text
✅ **Emoji Support**: Quick emoji insertion with simple triggers
✅ **Dynamic Content**: Date/time insertion, shell commands, clipboard integration
✅ **Function-based Replacements**: Complex replacements using Lua functions
✅ **Toggle On/Off**: Easy enable/disable with keyboard shortcut
✅ **System-wide**: Works in all applications
✅ **Performance Optimized**: Trie-based pattern matching for O(k) lookup
✅ **Statistics & Monitoring**: Track usage patterns and performance metrics

### Available Triggers

#### Emoji Shortcuts

```
:hee → 😁        :ha → 🤣         :hmm → 🤔
:cry → 🥹        :sad → 😢        :tick → ✅
:zoom → 🥄       :like → 👍       :inprogress → ⏳
:rose → 🌹       :fire → 🔥       :espanso → [custom]
```

#### Dynamic Content

```
:date → Current date (e.g., 30-Sep-2024)
:time → Current date and time (e.g., 30-Sep-2024 02:30 PM)
:amail → Timestamped email (e.g., aungmyokyaw+20240930143045@amdon.com)
:pw → Generate random password using Bitwarden
:shell → "Hello from your shell"
:lorem → Single sentence of Lorem Ipsum text (fetched from API)
:plorem → Paragraph of Lorem Ipsum text (fetched from API)
```

#### Clipboard-based (requires clipboard content)

```
:distill → Creates a detailed learning prompt with clipboard content
:listfacts → Lists facts from clipboard content
```

#### Learning & Teaching Prompts

```
:fdistill → Full distillation prompt for creating study summaries
:teachme → Prompt for comprehensive teaching
:makeclear → Request for clear explanation
:memorize → Create memory-friendly content
:system → Elite mode system prompt
```

### Usage

1. Type any trigger followed by **Space**, **Enter**, or **Tab** to expand it
2. The module maintains a character buffer and detects triggers
3. When triggered, it deletes the trigger text and inserts the replacement

### Adding New Replacements

Edit `text_replacement.lua` and add entries to the `replacements` table:

```lua
-- Simple text replacement
[":hello"] = "Hello, World!",

-- Dynamic replacement with function
[":random"] = function()
    return tostring(math.random(1, 100))
end,

-- Shell command
[":myip"] = function()
    return execShell("curl -s ifconfig.me")
end,

-- Clipboard-based
[":wrap"] = function()
    local clip = getClipboard()
    return string.format("[[%s]]", clip)
end,
```

### Enhanced API (v2.0)

```lua
-- Add new patterns programmatically
text_replacement.addPattern(":newemoji", "🎉", {type = "emoji", source = "custom"})

-- Remove patterns
text_replacement.removePattern(":oldpattern")

-- Get current statistics
local stats = text_replacement.getStatistics()

-- Enable/disable debug mode
text_replacement.enableDebugMode()
text_replacement.disableDebugMode()

-- Adjust buffer size for memory optimization
text_replacement.setBufferSize(200)
```

---

## 🔒 Sensitive Text Replacements

### Overview

The `sensitive_replacements.lua` file provides a secure way to store personal and sensitive text expansion patterns that should not be committed to version control or shared publicly.

### Purpose

- **Privacy**: Keep sensitive information out of public repositories
- **Security**: Store API keys, passwords, and personal data securely
- **Flexibility**: Add personal shortcuts without cluttering the main configuration

### Usage

This file is automatically loaded by the text replacement system. Add your sensitive patterns to the `sensitiveReplacements` table:

```lua
-- Personal email with timestamp
[":amail"] = function()
  return execShell("date '+aungmyokyaw+%Y%m%d%H%M%S@amdon.com'")
end

-- Add your own sensitive replacements
[":secret"] = "your-secret-text-here"
[":personal"] = function() return "dynamic-sensitive-content" end
```

### Security Features

- **Not in version control**: This file should be excluded from git
- **Isolation**: Sensitive patterns are kept separate from main configuration
- **Runtime API**: Add/remove sensitive patterns programmatically

### API Functions

```lua
-- Get all sensitive replacements
local sensitive = require("sensitive_replacements").getReplacements()

-- Add new sensitive pattern at runtime
require("sensitive_replacements").addReplacement(":newsecret", "secret-value")

-- Remove sensitive pattern
require("sensitive_replacements").removeReplacement(":oldsecret")
```

### Important Notes

⚠️ **Security Warning**: Be extremely careful with API keys and passwords. Consider using a dedicated password manager instead of storing sensitive credentials directly.

💡 **Best Practice**: Keep this file in `.gitignore` and never commit it to public repositories.

---

## 🖥️ Window Management

### Window Management Mode

Activate with **Hyper+M** to enter window management mode for precise window control:

#### Movement

- `h/j/k/l` or arrow keys: snap window to left/bottom/up/right
- `f`: maximize window
- `c`: center window
- `-` / `Shift+=`: resize down/up
- `=`: reset to original size
- `Shift+N`: move focused window to next screen
- `q/Esc`: exit mode

### Features

- Smart screen detection and multi-monitor support
- Preserve original window sizes for restoration
- Smooth animations and transitions
- Application-specific window rules (configurable)

---

## 📊 Performance Monitoring

### Features

- **Menubar Indicator**: Shows sampled CPU and approximate memory usage (updates every 5s)
- **Auto-Caffeinate**: Prevents display sleep when external display is connected and on AC power
- **Process Management**: Quick access to Activity Monitor and process control
- **Compact Display**: Toggle between compact icon and detailed menubar

### Hotkeys

- **Hyper+P**: Toggle compact/expanded menubar display
- **Hyper+Cmd+Alt+Ctrl+A**: Open Activity Monitor
- **Hyper+Cmd+Alt+Ctrl+K**: Show top CPU processes (with safe kill option)

### Configuration

Thresholds and sampling interval are configurable in `performance.lua`:

- `sampleInterval`: Update frequency (default: 5s)
- `cpuAlertThreshold`: CPU usage alert threshold
- `memoryAlertThreshold`: Memory usage alert threshold

---

## 🔄 AutoQuit Features

### Overview

Automatically quits unused applications to save system resources and maintain a clean workspace.

### Features

- **Automatic Monitoring**: Tracks application focus time and quits idle apps
- **Configurable Timeout**: 5-minute default idle threshold
- **Safe Quitting**: Only quits apps with no visible windows
- **Manual Control**: Hotkeys for immediate cleanup and status checking

### Monitored Applications

By default, these applications are monitored for auto-quitting:

- Safari, iTerm, Visual Studio Code, Finder, Mail, Messages, Preview, TextEdit, Calculator, Notes

### Hotkeys

- **Hyper+Q**: Manually quit all idle applications
- **Hyper+I**: Show currently monitored apps and their idle time

### Configuration

To customize the monitored applications or timeout, edit `autoquit.lua`:

```lua
-- Change idle timeout (default: 300 seconds = 5 minutes)
local idleTimeThreshold = 600 -- 10 minutes

-- Add/remove monitored applications
local monitoredApps = {
  "YourApp",
  "AnotherApp"
}
```

### Safety Features

- Only quits applications when no windows are visible
- Preserves applications with unsaved documents
- Shows alerts when applications are automatically quit

---

## 🤖 Automation Features

### AutoQuit

See [AutoQuit Features](#-autoquit-features) for complete documentation of the automatic application quitting system.

### Cleanup

System cleanup utilities:

- Temporary file cleanup
- Memory optimization
- Cache management

### Performance

Advanced performance monitoring and optimization:

- Real-time CPU/memory tracking
- Process prioritization
- Resource usage alerts

---

## ⚙️ Configuration

### File Structure

```
hammerspoon/
├── init.lua              # Main configuration entry point
├── text_replacement.lua  # Text expansion system
├── window_management.lua # Window management features
├── performance.lua       # Performance monitoring
├── automation.lua        # Automation utilities
├── cleanup.lua          # System cleanup tools
├── autoquit.lua         # Automatic application quitting
├── apps.lua             # Application-specific configurations
├── sensitive_replacements.lua # Sensitive text replacement patterns (do not commit)
├── Spoons/              # Hammerspoon Spoons directory (currently empty)
└── README.md            # This documentation
```

### Auto-Reload

The configuration auto-reloads when files under ~/.hammerspoon/ change. To test changes manually:

- Press `Hyper+R`
- Or use the menubar icon to reload

### Module Configuration

Each module can be individually enabled/disabled in `init.lua` by commenting/uncommenting the relevant `require` statements.

### Spoons Directory

The `Spoons/` directory is reserved for Hammerspoon Spoons - reusable Lua plugins that extend Hammerspoon's functionality. Currently, this directory is empty, but you can:

- Download Spoons from the [Hammerspoon Spoons repository](https://github.com/Hammerspoon/hammerspoon-Spoons)
- Install custom Spoons for additional functionality
- Create your own Spoons for modular code organization

To install a Spoon:

1. Download the `.spoon` file
2. Place it in the `Spoons/` directory
3. Load it in your `init.lua` with `hs.loadSpoon("SpoonName")`

---

## 🔧 Troubleshooting

### Text Replacement Issues

#### If Nothing Happens

1. **Check if it's enabled**
   - Press `Hyper+T` to toggle
   - You should see an alert saying "Text Replacement enabled"

2. **Enable Debug Mode**
   - Click Hammerspoon icon → Console
   - Type: `require("text_replacement").enableDebugMode()`
   - Press Enter
   - Try typing `:fire ` again
   - Watch the console for debug messages

3. **Check Statistics**
   - Press `Hyper+S` to view usage statistics
   - Verify patterns are loaded correctly

#### Wrong Text Gets Replaced

- The module maintains a character buffer; if you type quickly and then backspace, the buffer might be out of sync
- Press `Hyper+R` to reload and reset the buffer

#### Clipboard Content Not Restored

- The module waits 200ms before restoring clipboard
- If you paste immediately after expansion, you might paste the replacement text
- Wait a moment before pasting other content

### Performance Issues

1. Reduce buffer size in text replacement if memory is constrained
2. Disable async replacements if network is slow
3. Check statistics for error patterns

### General Issues

1. **Hammerspoon not running**: Check for menubar icon
2. **Configuration errors**: Open Hammerspoon Console to see error messages
3. **Module conflicts**: Ensure no duplicate hotkey assignments

### Getting Help

- Open Hammerspoon Console from menubar for detailed logs
- Check individual module files for configuration options
- Use debug mode (`Hyper+D`) for detailed troubleshooting information

---

## 🚀 Success! 🎉

If your tests pass, you now have a fully functional productivity suite running in Hammerspoon with:

- ✅ Text replacement system (Espanso alternative)
- ✅ Advanced window management
- ✅ Performance monitoring
- ✅ Automation utilities
- ✅ System cleanup tools

**Enjoy your productivity boost!** ⚡

---

## 📚 Additional Resources

### Architecture Details

```
text_replacement.lua
├── Configuration
│   ├── Replacement definitions (26+ triggers)
│   └── Helper functions (clipboard, shell, date)
├── Event Watcher
│   ├── Monitor keystrokes
│   ├── Maintain character buffer
│   └── Detect trigger + Space/Enter/Tab
├── Replacement Engine
│   ├── Delete trigger text
│   ├── Execute function if needed
│   └── Insert replacement via clipboard
└── Controls
    ├── Toggle on/off (Hyper+T)
    ├── Debug mode (Hyper+D)
    ├── Statistics (Hyper+S)
    └── Status alerts
```

### Performance Optimizations (v2.0)

- **Trie-based Pattern Matching**: O(k) lookup time
- **Circular Buffer**: Efficient memory management
- **Lazy Evaluation**: Defer expensive operations
- **Enhanced Error Handling**: Comprehensive logging

### Security Features

- Automatic clipboard backup and restore
- Input validation for all operations
- Timeout protection for shell commands
- Error handling with fallback mechanisms

---

_Last updated: September 2025_
