Hammerspoon config

This folder contains Hammerspoon configuration and helper modules used for window management and small productivity helpers.

Hotkeys and features

- Hyper key: Cmd+Alt+Ctrl+Shift
- Hyper+R: Reload Hammerspoon config
- Hyper+Space: App chooser (favorite apps)
- Hyper+t/s/e/n/f: Launch or focus iTerm/Safari/VS Code/Notes/Finder
- Hyper+H/J/K/L while in Window Management Mode (Hyper+M): snap left/down/up/right
- Hyper+M: Enter Window Management Mode
- In Window Management Mode:
  - h/j/k/l or arrow keys: snap window
  - f: maximize
  - c: center
  - - / Shift+= : resize down/up
  - = : reset to original size
  - Shift+N: move focused window to next screen
  - q/Esc: exit mode

Notes

- The configuration auto-reloads when files under ~/.hammerspoon/ change.
- To test changes: reload with Hyper+R or use the menubar icon to toggle caffeinate.

Performance features

- Menubar indicator shows sampled CPU and approximate memory usage (updates every 5s).
- Auto-caffeinate when an external display is connected and the Mac is on AC power (prevents display sleep for presentations).
- Hyper+Cmd+Alt+Ctrl+A: Open Activity Monitor quickly.
- Hyper+Cmd+Alt+Ctrl+K: Show top CPU processes in a chooser; selecting a process will prompt and send SIGTERM (safe manual step).

Configuration notes

- Thresholds and sampling interval are configurable in `performance.lua` (sampleInterval, cpuAlertThreshold, memoryAlertThreshold).
- The module starts automatically on config load; to disable it, remove or comment the `require "performance"` in `init.lua`.

Compact menubar

- By default the performance menubar shows a compact icon to save space. Click the icon to open a menu with full CPU/memory details and actions.
- Toggle compact/expanded display with Hyper+P (Hyper = Cmd+Alt+Ctrl+Shift).
