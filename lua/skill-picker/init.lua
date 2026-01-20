--- @class SkillConfig
--- @field skills_dir string|nil Path to the directory containing skill files

--- @class SkillMetadata
--- @field name string Name of the skill
--- @field description string|nil Description of the skill
--- @field path string Full path to the SKILL.md file

local M = {}
local parser = require("skill-picker.parser")

--- @type SkillConfig
M.config = {
  skills_dir = vim.env.SKILLS_DIR,
}

--- @type SkillMetadata[]
M.cache = {}

--- Setup the plugin
--- @param opts SkillConfig|nil
function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})

  if M.config.skills_dir then
    M.config.skills_dir = vim.fn.expand(M.config.skills_dir)
  end

  -- Trigger initial refresh asynchronously
  vim.schedule(function()
    M.refresh(true) -- silent refresh on startup
  end)
end

--- Refresh the skills cache
--- @param silent boolean|nil If true, suppress notifications
function M.refresh(silent)
  local skills_dir = M.config.skills_dir
  if not skills_dir or skills_dir == "" then
    if not silent then
      vim.notify("skill-picker: SKILLS_DIR is not set", vim.log.levels.ERROR)
    end
    return
  end

  local has_scan, scan = pcall(require, "plenary.scandir")
  local has_path, path = pcall(require, "plenary.path")

  if not has_scan or not has_path then
    if not silent then
      vim.notify("skill-picker: plenary.nvim is required", vim.log.levels.ERROR)
    end
    return
  end

  M.cache = {}
  local files = scan.scan_dir(skills_dir, {
    search_pattern = "SKILL%.md$",
    depth = 2,
  })

  for _, file in ipairs(files) do
    local content = path:new(file):read()
    local skill = parser.parse(content)
    if skill then
      --- @type SkillMetadata
      local metadata = {
        name = skill.name,
        description = skill.description,
        path = file,
      }
      table.insert(M.cache, metadata)
    else
      vim.notify("skill-picker: Failed to parse " .. file, vim.log.levels.WARN)
    end
  end

  if not silent then
    vim.notify("skill-picker: Skills cache refreshed (" .. #M.cache .. " skills found)", vim.log.levels.INFO)
  end
end

return M