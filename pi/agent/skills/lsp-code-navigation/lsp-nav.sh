#!/bin/bash

# LSP Code Navigation Script
# Uses nvim's built-in LSP client via headless mode to perform code navigation

MASON_BIN="$HOME/.local/share/nvim/mason/bin"
ACTION=$1
shift

show_help() {
    cat << 'EOF'
Usage: lsp-nav.sh <action> [args]

Actions:
  definition <file> <line> <character>     Go to definition
  references <file> <line> <character>     Find all references
  workspace_symbol <query>                 Search symbols across workspace
  document_symbol <file>                   List symbols in file
  hover <file> <line> <character>          Get hover info
  detect                                   Detect LSP for current project

Examples:
  lsp-nav.sh definition src/main.ts 10 5
  lsp-nav.sh workspace_symbol "MyClass"
  lsp-nav.sh document_symbol src/utils.ts
EOF
}

# Detect which LSP server to use based on project files
detect_lsp() {
    if [[ -f "deno.json" ]] || [[ -f "deno.jsonc" ]]; then
        echo "denols"
    elif [[ -f "package.json" ]] || [[ -f "tsconfig.json" ]]; then
        echo "typescript-language-server"
    elif [[ -f "Cargo.toml" ]]; then
        echo "rust-analyzer"
    elif [[ -f "pyproject.toml" ]] || [[ -f "requirements.txt" ]] || [[ -f "setup.py" ]]; then
        echo "pyright"
    elif [[ -f ".luarc.json" ]] || [[ -n $(find . -maxdepth 1 -name "*.lua" -print -quit 2>/dev/null) ]]; then
        echo "lua-language-server"
    elif [[ -f "astro.config.mjs" ]] || [[ -f "astro.config.ts" ]]; then
        echo "astro-ls"
    elif [[ -f "prisma/schema.prisma" ]]; then
        echo "prisma-language-server"
    elif [[ -f "Dockerfile" ]]; then
        echo "docker-langserver"
    elif [[ -f "tailwind.config.js" ]] || [[ -f "tailwind.config.ts" ]]; then
        echo "tailwindcss-language-server"
    else
        echo "unknown"
    fi
}

# Run nvim LSP command and output results
run_lsp_nvim() {
    local cmd="$1"
    local file="$2"
    local line="${3:-0}"
    local col="${4:-0}"
    
    # Convert file to absolute path
    if [[ -n "$file" ]]; then
        file=$(realpath "$file" 2>/dev/null || echo "$file")
    fi
    
    nvim --headless --clean \
        --cmd "set rtp+=~/.local/share/nvim/lazy/nvim-lspconfig" \
        -u NONE \
        --cmd "lua << EOF
local lspconfig = require('lspconfig')

-- Simple handler that prints results and exits
local results = {}
local handler = function(err, result, ctx, config)
    if err then
        print('ERROR: ' .. vim.inspect(err))
        vim.cmd('qa!')
        return
    end
    if not result or vim.tbl_isempty(result) then
        print('No results found')
        vim.cmd('qa!')
        return
    end
    -- Handle both single result and array of results
    if not vim.islist(result) then
        result = { result }
    end
    for _, item in ipairs(result) do
        if item.targetUri or item.uri then
            local uri = item.targetUri or item.uri
            local range = item.targetRange or item.range
            print(uri .. ':' .. (range and range.start and range.start.line + 1 or '?') .. ':' .. (range and range.start and range.start.character or '?'))
        elseif item.name then
            print(item.name .. ' (' .. (item.kind or 'unknown') .. ')')
        elseif item.location then
            print(item.location.uri .. ':' .. (item.location.range and item.location.range.start and item.location.range.start.line + 1 or '?'))
        end
    end
    vim.cmd('qa!')
end

-- Start LSP and make request
local function start_and_request()
EOF
" -c "lua dofile('$HOME/.pi/agent/skills/lsp-code-navigation/lsp-commands.lua')" -c "qa!" 2>/dev/null
}

case "$ACTION" in
    detect)
        detect_lsp
        ;;
    definition|references|hover)
        file="$1"
        line="$2"
        col="$3"
        if [[ -z "$file" ]] || [[ -z "$line" ]] || [[ -z "$col" ]]; then
            echo "Usage: lsp-nav.sh $ACTION <file> <line> <character>"
            exit 1
        fi
        if [[ ! -f "$file" ]]; then
            echo "File not found: $file"
            exit 1
        fi
        
        # Use nvim with a temp script for LSP operations
        nvim --headless --clean -u NONE \
            --cmd "set rtp+=~/.local/share/nvim/lazy/nvim-lspconfig" \
            --cmd "set rtp+=~/.local/share/nvim/lazy/mason.nvim" \
            -c "lua dofile('$HOME/.pi/agent/skills/lsp-code-navigation/lsp-request.lua')" \
            -c "LspNavigate('$ACTION', '$file', $line, $col)" \
            -c "sleep 5" \
            -c "qa!" 2>&1 | grep -v "^$" | head -50
        ;;
    workspace_symbol)
        query="$1"
        if [[ -z "$query" ]]; then
            echo "Usage: lsp-nav.sh workspace_symbol <query>"
            exit 1
        fi
        
        # Find a source file to attach LSP to
        file=$(find . -type f \( -name "*.ts" -o -name "*.js" -o -name "*.lua" -o -name "*.rs" -o -name "*.py" \) -print -quit 2>/dev/null | head -1)
        if [[ -z "$file" ]]; then
            echo "No source file found to attach LSP"
            exit 1
        fi
        
        nvim --headless --clean -u NONE \
            --cmd "set rtp+=~/.local/share/nvim/lazy/nvim-lspconfig" \
            --cmd "set rtp+=~/.local/share/nvim/lazy/mason.nvim" \
            -c "lua dofile('$HOME/.pi/agent/skills/lsp-code-navigation/lsp-request.lua')" \
            -c "LspWorkspaceSymbol('$file', '$query')" \
            -c "sleep 5" \
            -c "qa!" 2>&1 | grep -v "^$" | head -100
        ;;
    document_symbol)
        file="$1"
        if [[ -z "$file" ]]; then
            echo "Usage: lsp-nav.sh document_symbol <file>"
            exit 1
        fi
        if [[ ! -f "$file" ]]; then
            echo "File not found: $file"
            exit 1
        fi
        
        nvim --headless --clean -u NONE \
            --cmd "set rtp+=~/.local/share/nvim/lazy/nvim-lspconfig" \
            --cmd "set rtp+=~/.local/share/nvim/lazy/mason.nvim" \
            -c "lua dofile('$HOME/.pi/agent/skills/lsp-code-navigation/lsp-request.lua')" \
            -c "LspDocumentSymbol('$file')" \
            -c "sleep 3" \
            -c "qa!" 2>&1 | grep -v "^$" | head -100
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        echo "Unknown action: $ACTION"
        show_help
        exit 1
        ;;
esac