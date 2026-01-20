local M = {}

--- Parse SKILL.md content to extract name and description from frontmatter
--- @param content string
--- @return table|nil
function M.parse(content)
  if not content or content == "" then
    return nil
  end

  -- Normalize line endings
  content = content:gsub("\r\n", "\n")
  local lines = vim.split(content, "\n")

  -- Find start of frontmatter
  local start_idx = nil
  for i, line in ipairs(lines) do
    if line:match("^%-%-%-%s*$") then
      start_idx = i
      break
    end
  end

  if not start_idx then
    return nil
  end

  local res = {}
  local found_end = false
  for i = start_idx + 1, #lines do
    local line = lines[i]
    if line:match("^%-%-%-%s*$") then
      found_end = true
      break
    end

    local name = line:match("^name:%s*(.*)$")
    if name then
      res.name = vim.trim(name)
    end

    local desc = line:match("^description:%s*(.*)$")
    if desc then
      res.description = vim.trim(desc)
    end
  end

  -- Must have name and valid frontmatter structure
  if not found_end or not res.name or res.name == "" then
    return nil
  end

  return res
end

return M
