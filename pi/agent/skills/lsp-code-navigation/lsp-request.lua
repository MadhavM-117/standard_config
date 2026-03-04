-- LSP Request Helper for pi
-- This script provides LSP functionality through nvim's headless mode

local M = {}

-- Get LSP config based on filetype
local function get_lsp_config(filetype)
    local configs = {
        typescript = {
            cmd = { vim.fn.expand("~/.local/share/nvim/mason/bin/typescript-language-server"), "--stdio" },
            root_markers = { "package.json", "tsconfig.json", ".git" },
        },
        javascript = {
            cmd = { vim.fn.expand("~/.local/share/nvim/mason/bin/typescript-language-server"), "--stdio" },
            root_markers = { "package.json", ".git" },
        },
        lua = {
            cmd = { vim.fn.expand("~/.local/share/nvim/mason/bin/lua-language-server") },
            root_markers = { ".luarc.json", ".git" },
        },
        rust = {
            cmd = { vim.fn.expand("~/.local/share/nvim/mason/bin/rust-analyzer") },
            root_markers = { "Cargo.toml", ".git" },
        },
        python = {
            cmd = { vim.fn.expand("~/.local/share/nvim/mason/bin/pyright-langserver"), "--stdio" },
            root_markers = { "pyproject.toml", "setup.py", "requirements.txt", ".git" },
        },
        astro = {
            cmd = { vim.fn.expand("~/.local/share/nvim/mason/bin/astro-ls"), "--stdio" },
            root_markers = { "astro.config.mjs", "astro.config.ts", ".git" },
        },
        prisma = {
            cmd = { vim.fn.expand("~/.local/share/nvim/mason/bin/prisma-language-server"), "--stdio" },
            root_markers = { "prisma/schema.prisma", ".git" },
        },
        dockerfile = {
            cmd = { vim.fn.expand("~/.local/share/nvim/mason/bin/docker-langserver"), "--stdio" },
            root_markers = { "Dockerfile", ".git" },
        },
        css = {
            cmd = { vim.fn.expand("~/.local/share/nvim/mason/bin/vscode-css-language-server"), "--stdio" },
            root_markers = { "package.json", ".git" },
        },
        scss = {
            cmd = { vim.fn.expand("~/.local/share/nvim/mason/bin/vscode-css-language-server"), "--stdio" },
            root_markers = { "package.json", ".git" },
        },
        html = {
            cmd = { vim.fn.expand("~/.local/share/nvim/mason/bin/vscode-html-language-server"), "--stdio" },
            root_markers = { "package.json", ".git" },
        },
        markdown = {
            cmd = { vim.fn.expand("~/.local/share/nvim/mason/bin/marksman") },
            root_markers = { ".git", ".marksman.toml" },
        },
    }
    return configs[filetype]
end

-- Detect filetype from extension
local function detect_filetype(filename)
    local ext = filename:match("%.([^.]+)$")
    local map = {
        ts = "typescript",
        tsx = "typescript",
        js = "javascript",
        jsx = "javascript",
        lua = "lua",
        rs = "rust",
        py = "python",
        astro = "astro",
        prisma = "prisma",
        dockerfile = "dockerfile",
        css = "css",
        scss = "scss",
        html = "html",
        md = "markdown",
    }
    return map[ext] or ""
end

-- Find project root
local function find_root(root_markers, start_path)
    local path = vim.fn.fnamemodify(start_path, ":p:h")
    while path ~= "/" and path ~= "" do
        for _, marker in ipairs(root_markers) do
            if vim.fn.glob(path .. "/" .. marker) ~= "" then
                return path
            end
        end
        path = vim.fn.fnamemodify(path, ":h")
    end
    return vim.fn.getcwd()
end

-- Start LSP client for file
local function start_lsp(file_path, callback)
    local filetype = detect_filetype(file_path)
    if filetype == "" then
        print("Cannot detect filetype for: " .. file_path)
        return nil
    end
    
    local config = get_lsp_config(filetype)
    if not config then
        print("No LSP config for filetype: " .. filetype)
        return nil
    end
    
    local root_dir = find_root(config.root_markers, file_path)
    
    local client_id = vim.lsp.start({
        name = filetype .. "-lsp",
        cmd = config.cmd,
        root_dir = root_dir,
    })
    
    if not client_id then
        print("Failed to start LSP client")
        return nil
    end
    
    -- Wait for client to be ready
    local attempts = 0
    vim.wait(5000, function()
        local client = vim.lsp.get_client_by_id(client_id)
        if client and client.initialized then
            return true
        end
        attempts = attempts + 1
        return false
    end, 100)
    
    local client = vim.lsp.get_client_by_id(client_id)
    if not client or not client.initialized then
        print("LSP client failed to initialize")
        return nil
    end
    
    return client_id
end

-- Format LSP result for output
local function format_result(result)
    if not result then
        return
    end
    
    if type(result) ~= "table" then
        print(vim.inspect(result))
        return
    end
    
    -- Handle Location or LocationLink
    if result.uri or result.targetUri then
        local uri = result.uri or result.targetUri
        local range = result.range or result.targetRange
        local filename = vim.uri_to_fname(uri)
        local line = range and range.start and range.start.line or 0
        local character = range and range.start and range.start.character or 0
        print(string.format("%s:%d:%d", filename, line + 1, character + 1))
        return
    end
    
    -- Handle array of results
    if vim.tbl_islist(result) then
        for _, item in ipairs(result) do
            format_result(item)
        end
        return
    end
    
    -- Handle SymbolInformation or DocumentSymbol
    if result.name then
        local kind = result.kind and vim.lsp.protocol.SymbolKind[result.kind] or "Unknown"
        local location = ""
        if result.location then
            local filename = vim.uri_to_fname(result.location.uri)
            local line = result.location.range and result.location.range.start and result.location.range.start.line or 0
            location = string.format(" (%s:%d)", filename, line + 1)
        elseif result.range then
            location = string.format(" (line %d)", result.range.start.line + 1)
        end
        print(string.format("%s [%s]%s", result.name, kind, location))
        return
    end
    
    -- Fallback
    print(vim.inspect(result))
end

-- Go to definition
function LspNavigate(action, file_path, line, col)
    local client_id = start_lsp(file_path)
    if not client_id then
        return
    end
    
    local bufnr = vim.uri_to_bufnr(vim.uri_from_fname(vim.fn.fnamemodify(file_path, ":p")))
    vim.fn.bufload(bufnr)
    
    local params = vim.lsp.util.make_position_params(0, "utf-16")
    params.position = { line = line - 1, character = col - 1 }
    
    local method = "textDocument/definition"
    if action == "references" then
        method = "textDocument/references"
        params.context = { includeDeclaration = true }
    elseif action == "hover" then
        method = "textDocument/hover"
    end
    
    local results = vim.lsp.buf_request_sync(bufnr, method, params, 5000)
    
    if not results or vim.tbl_isempty(results) then
        print("No results found")
        return
    end
    
    for client_id, response in pairs(results) do
        if response.result then
            format_result(response.result)
        elseif response.error then
            print("Error: " .. vim.inspect(response.error))
        end
    end
end

-- Workspace symbol search
function LspWorkspaceSymbol(file_path, query)
    local client_id = start_lsp(file_path)
    if not client_id then
        return
    end
    
    local bufnr = vim.uri_to_bufnr(vim.uri_from_fname(vim.fn.fnamemodify(file_path, ":p")))
    vim.fn.bufload(bufnr)
    
    local params = { query = query }
    
    local results = vim.lsp.buf_request_sync(bufnr, "workspace/symbol", params, 5000)
    
    if not results or vim.tbl_isempty(results) then
        print("No symbols found")
        return
    end
    
    for client_id, response in pairs(results) do
        if response.result then
            format_result(response.result)
        elseif response.error then
            print("Error: " .. vim.inspect(response.error))
        end
    end
end

-- Document symbol search
function LspDocumentSymbol(file_path)
    local client_id = start_lsp(file_path)
    if not client_id then
        return
    end
    
    local bufnr = vim.uri_to_bufnr(vim.uri_from_fname(vim.fn.fnamemodify(file_path, ":p")))
    vim.fn.bufload(bufnr)
    
    local params = { textDocument = vim.lsp.util.make_text_document_params(bufnr) }
    
    local results = vim.lsp.buf_request_sync(bufnr, "textDocument/documentSymbol", params, 5000)
    
    if not results or vim.tbl_isempty(results) then
        print("No symbols found")
        return
    end
    
    for client_id, response in pairs(results) do
        if response.result then
            format_result(response.result)
        elseif response.error then
            print("Error: " .. vim.inspect(response.error))
        end
    end
end

return M