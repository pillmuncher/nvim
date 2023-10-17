Set = {
    __add = function(t1, t2)
        local result = setmetatable({}, Set)
        for k in pairs(t1) do
            result[k] = true
        end
        for k in pairs(t2) do
            result[k] = true
        end
        return result
    end,
    __call = function(set)
        local result = {}
        for k in pairs(set) do
            table.insert(result, k)
        end
        return result
    end
}


function map(modes, ...)
    vim.keymap.set(modes(), ...)
end

cmd = vim.cmd

i = setmetatable({ i = true }, Set)
n = setmetatable({ n = true }, Set)
v = setmetatable({ v = true }, Set)
x = setmetatable({ x = true }, Set)
t = setmetatable({ t = true }, Set)


function require_all(target_dir)
    local config_path = vim.fn.stdpath("config")
    local full_target_dir = config_path .. "/lua/" .. target_dir

    -- Iterate through the files in the directory
    for _, filename in ipairs(vim.fn.readdir(full_target_dir)) do
        local full_path = full_target_dir .. "/" .. filename

        -- Check if the file is a Lua file
        if vim.loop.fs_stat(full_path).type == "file" and filename:match("%.lua$") then
            -- Require the Lua file
            require(target_dir .. "." .. filename:gsub("%.lua$", ""))
        end
    end
end
