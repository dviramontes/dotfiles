-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Startup / runtime snappiness
vim.g.snacks_animate = false -- skip snacks UI animations

-- Keep diffs readable without extra redraw work from conceal
vim.opt.conceallevel = 0

-- Slightly snappier mapped sequences (LazyVim default is often 300)
vim.opt.timeoutlen = 300

-- ShaDa: retain history but avoid oversized startup reads/writes
vim.opt.shada = "!,'100,<50,s10,h"
