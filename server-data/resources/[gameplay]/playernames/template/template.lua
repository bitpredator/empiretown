-- Enhanced Template Engine for Lua / ngx_lua
-- Compatible with Lua 5.1+ and OpenResty (ngx)

local setmetatable = setmetatable
local tostring = tostring
local table_concat = table.concat
local string_gsub = string.gsub
local string_find = string.find
local string_sub = string.sub
local string_byte = string.byte
local string_dump = string.dump
local io_open = io.open
local io_write = io.write
local assert = assert
local type = type
local load = load
local loadstring = loadstring
local setfenv = setfenv
local pcall = pcall
local jit = jit
local ngx = ngx

local template = {}
template._VERSION = "2.0"
template.cache = {}

-- HTML Escape Entities
local HTML_ENTITIES = {
    ["&"] = "&amp;",
    ["<"] = "&lt;",
    [">"] = "&gt;",
    ['"'] = "&quot;",
    ["'"] = "&#39;",
    ["/"] = "&#47;",
}

-- Code Escape Entities
local CODE_ENTITIES = {
    ["{"] = "&#123;",
    ["}"] = "&#125;",
    ["&"] = "&amp;",
    ["<"] = "&lt;",
    [">"] = "&gt;",
    ['"'] = "&quot;",
    ["'"] = "&#39;",
    ["/"] = "&#47;",
}

-- Context detection
local is_openresty = ngx ~= nil
local phase = is_openresty and ngx.get_phase or function()
    return nil
end
local prefix = is_openresty and ngx.config.prefix() or ""
local var = is_openresty and ngx.var or {}
local capture = is_openresty and ngx.location.capture or nil
local null = is_openresty and ngx.null or nil
local caching = true

-- Utility: trim whitespace
local function trim(s)
    return s:match("^%s*(.-)%s*$")
end

-- Utility: read file content
local function readfile(path)
    local file = io_open(path, "rb")
    if not file then
        return nil
    end
    local content = file:read("*a")
    file:close()
    return content
end

-- Utility: safely load Lua code into a function
local function loadchunk(view)
    local env = setmetatable({ template = template }, {
        __index = function(_, k)
            return _G[k]
        end,
    })

    if _VERSION == "Lua 5.1" then
        local f = assert(loadstring(view))
        setfenv(f, env)
        return f
    else
        return assert(load(view, nil, nil, env))
    end
end

-- Escape strings
function template.escape(str, code)
    if type(str) ~= "string" then
        return tostring(str)
    end
    return string_gsub(str, code and "[{}<>\"'&/]" or "[<>\"'&/]", code and CODE_ENTITIES or HTML_ENTITIES)
end

-- Output helper
function template.output(val)
    if val == nil or val == null then
        return ""
    end
    if type(val) == "function" then
        return template.output(val())
    end
    return tostring(val)
end

-- Load template from file
function template.load(path)
    if is_openresty and phase() then
        local location = var.template_location
        if location and location ~= "" then
            local res = capture(location .. "/" .. path)
            if res and res.status == 200 then
                return res.body
            end
        end
        local root = var.template_root or var.document_root or prefix
        return readfile(root .. "/" .. path) or path
    end
    return readfile(path) or path
end

-- Core parser
function template.parse(view)
    assert(view, "Missing template view.")
    view = template.load(view)

    if string_byte(view, 1) == 27 then
        return view -- precompiled
    end

    local chunks = {
        [[context=... or {} local ___,blocks={},{} local function include(v,c)return template.compile(v)(c or context)end]],
    }

    local i, j = 1, 2
    local len = #view

    while i <= len do
        local start, stop = string_find(view, "{%", i, true)
        if not start then
            break
        end

        chunks[j] = string.format("___[#___+1]=[=[%s]=]", view:sub(i, start - 1))
        j = j + 1

        local marker = view:sub(start + 1, start + 1)
        local close_marker = ({
            ["{"] = "}}",
            ["*"] = "*}",
            ["%"] = "%}",
            ["("] = ")}",
            ["["] = "]}",
            ["-"] = "-}",
        })[marker] or "}" .. marker

        local close = string_find(view, close_marker, start + 2, true)
        if close then
            local inner = trim(view:sub(start + 2, close - 1))
            if marker == "{" then
                chunks[j] = "___[#___+1]=template.escape(" .. inner .. ")"
            elseif marker == "*" then
                chunks[j] = "___[#___+1]=template.output(" .. inner .. ")"
            elseif marker == "%" then
                chunks[j] = inner
            elseif marker == "(" or marker == "[" then
                chunks[j] = "___[#___+1]=include(" .. inner .. ")"
            elseif marker == "-" then
                chunks[j] = "-- block: " .. inner
            end
            j = j + 1
            i = close + #close_marker
        else
            break
        end
    end

    if i <= len then
        chunks[j] = string.format("___[#___+1]=[=[%s]=]", view:sub(i))
    end

    chunks[#chunks + 1] = "return table.concat(___)"
    return table_concat(chunks, "\n")
end

-- Compile a view into a function
function template.compile(view, key)
    key = key or view
    if template.cache[key] then
        return template.cache[key]
    end
    local chunk = template.parse(view)
    local func = loadchunk(chunk)
    if caching then
        template.cache[key] = func
    end
    return func
end

-- Render a view
function template.render(view, context, key)
    return template.output(template.compile(view, key)(context))
end

return template
