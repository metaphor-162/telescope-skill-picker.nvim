local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local skill_picker = require("skill-picker")

local M = {}

--- Format entry for display in telescope
--- @param entry SkillMetadata
--- @return table
local function entry_maker(entry)
  return {
    value = entry,
    display = entry.name,
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
      previewer = {
        preview = function(self, entry, status)
          -- Store window ID for scrolling
          self.state = self.state or {}
          self.state.winid = status.preview_win
          
          local bufnr = status.preview_bufnr
          if not bufnr then return end

          local path = entry.path
          if not path then return end

          local p = require("plenary.path"):new(path)
          if p:exists() then
            local lines = p:readlines()
            vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
            -- Note: We avoid setting filetype to prevent triggering the broken treesitter config
          end
        end,
        title = function(self)
          return "Skill Content"
        end,
        scroll_fn = function(self, speed)
          if not self.state or not self.state.winid then return end
          local winid = self.state.winid
          if not vim.api.nvim_win_is_valid(winid) then return end
          
          vim.api.nvim_win_call(winid, function()
            -- speed is number of lines. Positive = down, Negative = up (usually)
            -- Telescope actions pass calculated speed.
            vim.cmd("normal! " .. math.abs(speed) .. (speed > 0 and "j" or "k"))
          end)
        end,
        teardown = function(self) end,
      },
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          local selection = action_state.get_selected_entry()
          if selection then
            actions.close(prompt_bufnr)
            vim.api.nvim_put({ selection.name }, "c", true, true)
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

        -- <C-t>: Open in new tab
        map("i", "<C-t>", function()
          local selection = action_state.get_selected_entry()
          if selection then
            actions.close(prompt_bufnr)
            vim.cmd("tabedit " .. vim.fn.fnameescape(selection.path))
          end
        end)

        -- <C-u> / <C-d>: Scroll preview
        map({ "i", "n" }, "<C-u>", actions.preview_scrolling_up)
        map({ "i", "n" }, "<C-d>", actions.preview_scrolling_down)

        return true
      end,
    })
    :find()
end

return M

