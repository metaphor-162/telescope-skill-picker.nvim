local plenary_dir = os.getenv("PLENARY_DIR") or "/tmp/plenary.nvim"
local telescope_dir = os.getenv("TELESCOPE_DIR") or "/tmp/telescope.nvim"
local is_not_a_directory = vim.fn.isdirectory(plenary_dir) == 0
if is_not_a_directory then
  vim.fn.system({ "git", "clone", "https://github.com/nvim-lua/plenary.nvim", plenary_dir })
end

local is_not_a_directory_telescope = vim.fn.isdirectory(telescope_dir) == 0
if is_not_a_directory_telescope then
  vim.fn.system({ "git", "clone", "https://github.com/nvim-telescope/telescope.nvim", telescope_dir })
end

vim.opt.rtp:append(".")
vim.opt.rtp:append(plenary_dir)
vim.opt.rtp:append(telescope_dir)

vim.cmd("runtime plugin/plenary.vim")
require("plenary.busted")
