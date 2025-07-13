-- lua/user/me.lua
-- Add any personal customizations or overrides here.
-- Enable word wrap and linebreak only for markdown files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
  end
})
