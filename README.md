# telescope-skill-picker.nvim

Neovim plugin to search and interact with Agent Skills using Telescope.

## Features

- Search skills by name and description.
- Preview skill content within Telescope.
- Asynchronous metadata caching for instant performance.
- Actions:
  - `<CR>`: Open SKILL.md
  - `<C-y>`: Copy skill name to clipboard
  - `<C-i>`: Insert skill name at cursor
  - `<C-t>`: Open SKILL.md in a new tab
- Manual cache refresh via `:SkillRefresh`.

## Requirements

- Neovim (0.9+)
- [nvim-telescope/telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
- [nvim-lua/plenary.nvim](https://github.com/nvim-lua/plenary.nvim)

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "metaphor/telescope-skill-picker.nvim", -- Replace with your actual repo
  dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
  config = function()
    require("skill-picker").setup({
      -- Directory where your SKILL.md files are located.
      -- Defaults to env.SKILLS_DIR
      skills_dir = "~/.gemini/skills",
    })

    -- Recommended keymap
    vim.keymap.set("n", "<Leader>sf", ":Telescope skill_picker<CR>", { desc = "Skill Picker" })
  end,
}
```

## Usage

- `:Telescope skill_picker` - Open the skill picker.
- `:SkillRefresh` - Refresh the skill metadata cache.

## Configuration

| Option       | Type     | Default | Description                                   |
| ------------ | -------- | ------- | --------------------------------------------- |
| `skills_dir` | `string` | `nil`   | Path to the directory containing skill files. |

If `skills_dir` is not provided in `setup()`, the plugin will look for the `SKILLS_DIR` environment variable.

## Tips

### Reusing Skill Directories
You can use symbolic links to reuse your skill directories across different environments or tools. For example, if you want to share your Gemini skills with another tool that expects them at `~/.copilot`:

```bash
ln -s ~/.gemini/skills ~/.copilot
```

This allows `telescope-skill-picker.nvim` to manage your skills in one place while keeping them accessible to other systems.

## License

MIT
