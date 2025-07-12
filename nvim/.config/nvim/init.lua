--[[
Advanced Neovim Optimization Tips:
- If building Neovim from source, enable CPU-specific optimizations (e.g., -march=native, AVX, SSE4) for your hardware.
- Consider enabling LTO (Link Time Optimization) for further performance gains.
- Always use the latest stable Neovim version and keep plugins up to date.
- Profile slow plugins with built-in or third-party profiling tools.
]] --[[
Neovim Startup Benchmarking:
To measure startup time, use:
  nvim --startuptime nvim.log +q && tail -n 20 nvim.log
For more robust benchmarking, install hyperfine (brew install hyperfine) and run:
  hyperfine 'nvim --headless +q'
Compare before/after config changes for best results.
]] vim.loader.enable(true)

require("core.options")
require("core.keymaps")

-- Bootstrap Lazy.nvim plugin manager
require("plugins.bootstrap")

-- Setup lazy plugins
require("plugins.lazy-plugins")

-- Configure plugins and integrations
require("plugins.pluginsettings")

-- Setup LSP and autocompletion
require("plugins.auto-complete")

-- Load user-specific customizations
require("user.me")
