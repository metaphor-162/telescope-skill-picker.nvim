if vim.g.loaded_skill_picker then
  return
end
vim.g.loaded_skill_picker = 1

vim.api.nvim_create_user_command("SkillRefresh", function()
  require("skill-picker").refresh()
end, {})