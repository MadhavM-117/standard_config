---
name: lsp-code-navigation
description: Navigate codebases using Language Server Protocol (LSP). Provides go-to-definition, find-references, workspace symbols, and document symbols using the nvim mason-installed LSP servers.
---

# LSP Code Navigation

This skill uses your existing nvim Mason-installed LSP servers to navigate codebases.

## Setup

Ensure LSP servers are installed via Mason (your nvim setup already has these).

## Available Tools

The skill provides these capabilities using LSP:

- **Go to Definition** - Jump to where a symbol is defined
- **Find References** - Find all usages of a symbol
- **Workspace Symbols** - Search symbols across the entire project
- **Document Symbols** - List symbols in the current file
- **Hover Information** - Get type/documentation info

## Usage

### Go to Definition

```bash
cd /path/to/project
~/.pi/agent/skills/lsp-code-navigation/lsp-nav.sh definition <file> <line> <character>
```

Example:
```bash
~/.pi/agent/skills/lsp-code-navigation/lsp-nav.sh definition src/main.ts 10 5
```

### Find References

```bash
~/.pi/agent/skills/lsp-code-navigation/lsp-nav.sh references <file> <line> <character>
```

### Workspace Symbols

```bash
~/.pi/agent/skills/lsp-code-navigation/lsp-nav.sh workspace_symbol <query>
```

Example:
```bash
~/.pi/agent/skills/lsp-code-navigation/lsp-nav.sh workspace_symbol "UserController"
```

### Document Symbols

```bash
~/.pi/agent/skills/lsp-code-navigation/lsp-nav.sh document_symbol <file>
```

### Detect LSP for Project

```bash
~/.pi/agent/skills/lsp-code-navigation/lsp-nav.sh detect
```

## LSP Server Mapping

| Language | LSP Server | Mason Package |
|----------|-----------|---------------|
| TypeScript/JavaScript | typescript-language-server | typescript-language-server |
| Lua | lua-language-server | lua-language-server |
| Rust | rust-analyzer | rust-analyzer |
| Python | pyright | pyright |
| Astro | astro-ls | astro-language-server |
| CSS/SCSS | vscode-css-language-server | css-lsp |
| HTML | vscode-html-language-server | html-lsp |
| Prisma | prisma-language-server | prisma-language-server |
| Docker | docker-langserver | dockerfile-language-server |
| Markdown | marksman | marksman |
| Tailwind | tailwindcss-language-server | tailwindcss-language-server |

## Tips

- Always run from the project root (where applicable config files exist)
- LSP servers need appropriate root markers (package.json, .git, etc.)
- For best results, ensure the project compiles/builds successfully