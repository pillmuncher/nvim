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
