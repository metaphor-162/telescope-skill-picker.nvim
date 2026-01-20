local skill_picker = require("skill-picker")

describe("skill-picker init", function()
  it("should set skills_dir from setup", function()
    skill_picker.setup({
      skills_dir = "/tmp/test-skills"
    })
    assert.are.equal("/tmp/test-skills", skill_picker.config.skills_dir)
  end)

  it("should have a refresh function", function()
    assert.is_function(skill_picker.refresh)
  end)
end)
