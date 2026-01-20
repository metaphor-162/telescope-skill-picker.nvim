local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local previewers = require("telescope.previewers")
local skill_picker = require("skill-picker")

local M = {}

--- Format entry for display in telescope
--- @param entry SkillMetadata
--- @return table
local function entry_maker(entry)
  local display = entry.name
  if entry.description then
    -- Truncate description to 50 chars
    local desc = entry.description:sub(1, 50)
    if #entry.description > 50 then
      desc = desc .. "..."
    end
    display = display .. " : " .. desc
  end

  return {
    value = entry,
    display = display,
    ordinal = entry.name .. " " .. (entry.description or ""),
    path = entry.path,
    name = entry.name,
  }
end

--- Main picker function
--- @param opts table|nil Telescope options
function M.show(opts)
  opts = opts or {}

  -- Ensure cache is populated
  if #skill_picker.cache == 0 then
    skill_picker.refresh(true)
  end

  pickers
    .new(opts, {
      prompt_title = "Skills",
      finder = finders.new_table({
        results = skill_picker.cache,
        entry_maker = entry_maker,
      }),
      sorter = conf.generic_sorter(opts),
      previewer = conf.file_previewer(opts),
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          if selection then
            vim.cmd("edit " .. vim.fn.fnameescape(selection.path))
          end
        end)

        -- <C-y>: Copy skill name
        map("i", "<C-y>", function()
          local selection = action_state.get_selected_entry()
          if selection then
            vim.fn.setreg("+", selection.name)
            vim.notify("Copied: " .. selection.name, vim.log.levels.INFO)
          end
        end)

        -- <C-i>: Insert skill name
        map("i", "<C-i>", function()
          local selection = action_state.get_selected_entry()
          if selection then
            actions.close(prompt_bufnr)
            vim.api.nvim_put({ selection.name }, "c", true, true)
          end
        end)

        -- <C-t>: Open in new tab
        map("i", "<C-t>", function()
          local selection = action_state.get_selected_entry()
          if selection then
            actions.close(prompt_bufnr)
            vim.cmd("tabedit " .. vim.fn.fnameescape(selection.path))
          end
        end)

        return true
      end,
    })
    :find()
end

return M

