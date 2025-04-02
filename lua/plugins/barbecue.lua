local function split(input, delimiter)
    local arr = {}
    local _ = string.gsub(
        input,
        '[^' .. delimiter .. ']+',
        function(w) table.insert(arr, w) end
    )
    return arr
end

local function get_venv()
    local venv = vim.env.VIRTUAL_ENV
    if venv then
        local params = split(venv, '-')
        return params[#params] .. ' '
    else
        return ''
    end
end

return {
    'utilyre/barbecue.nvim',
    lazy         = false,
    priority     = 100000,
    name         = 'barbecue',
    dependencies = {
        { 'ramojus/mellifluous.nvim' },
        { 'SmiteshP/nvim-navic' },
        { 'nvim-tree/nvim-web-devicons' },
    },
    opts         = {
        create_autocmd = false,
        show_dirname = false,
        show_basename = false,
        custom_section = get_venv,
    },
}
