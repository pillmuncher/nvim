local function split(input, delimiter)
    local arr = {}
    local _ = string.gsub(input, '[^' .. delimiter .. ']+', function(w) table.insert(arr, w) end)
    return arr
end

local function get_venv()
    local venv = vim.env.VIRTUAL_ENV
    if venv then
        local params = split(venv, '/')
        return params[table.getn(params)] .. ' '
    else
        return ''
    end
end

return {
    'utilyre/barbecue.nvim',
    lazy         = false,
    name         = 'barbecue',
    dependencies = {
        { 'SmiteshP/nvim-navic',         opts = {} },
        { 'nvim-tree/nvim-web-devicons', opts = {} },
    },
    opts         = {
        create_autocmd = false,
        show_dirname = false,
        custom_section = get_venv,
    },
}
