# Pi Coding Agent Configuration
Personal configuration for the [pi coding agent](https://github.com/mariozechner/pi-coding-agent).

## Setup on New Device

### 1. Create Authentication File

You'll need an `auth.json` file with your API credentials. This file is gitignored to protect sensitive data.

**Default provider: OpenRouter**

Create `pi/agent/auth.json` with one of the following formats:

```json
{
  "providers": {
    "openrouter": {
      "api_key": "your-openrouter-api-key"
    }
  }
}
```

```json
{
  "providers": {
    "anthropic": {
      "api_key": "your-anthropic-api-key"
    }
  }
}
```

```json
{
  "providers": {
    "openai": {
      "api_key": "your-openai-api-key"
    }
  }
}
```

### 2. Symlink to Pi Config Directory

Pi looks for configuration in `~/.pi/`. Symlink this directory:

```bash
ln -s /path/to/standard_config/pi ~/.pi
```

Or set the `PI_DIR` environment variable to point to this directory.

## Configuration

- **Default Provider**: OpenRouter
- **Default Model**: minimax/minimax-m2.5
- **Thinking Level**: high

See `agent/settings.json` for all settings.

## Extensions

Custom extensions are included in `agent/extensions/`:

- `context-manager.ts` - context management
- `question-tools/` - custom question tools
- `sandbox/` - sandbox extension

## Skills

Custom skills can be added to `agent/skills/`. Currently no custom skills configured.
