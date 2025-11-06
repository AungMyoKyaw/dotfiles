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
