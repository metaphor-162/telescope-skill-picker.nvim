local skill_picker = require("skill-picker")
local picker = require("skill-picker.picker")

describe("picker", function()
  it("should have a show function", function()
    assert.is_function(picker.show)
  end)

  it("should register as a telescope extension", function()
    -- This test checks if the registration logic exists
    -- Actual registration happens in plugin/skill-picker.lua
    local has_telescope, telescope = pcall(require, "telescope")
    if has_telescope then
      assert.is_table(telescope.extensions.skill_picker)
    end
  end)
end)
