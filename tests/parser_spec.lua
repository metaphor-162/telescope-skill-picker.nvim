local parser = require("skill-picker.parser")

describe("parser", function()
  it("should parse valid frontmatter", function()
    local content = "---\nname: test-skill\ndescription: This is a test skill.\n---\n# Content"
    local result = parser.parse(content)
    assert.are.same({
      name = "test-skill",
      description = "This is a test skill.",
    }, result)
  end)

  it("should return nil for invalid frontmatter", function()
    local content = "---\ninvalid content\n---"
    local result = parser.parse(content)
    assert.is_nil(result)
  end)
end)