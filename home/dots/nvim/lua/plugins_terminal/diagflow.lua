
return {
    'dgagn/diagflow.nvim',
    event = 'LspAttach',
    opts = {
        show_borders = true,
        format = function(diagnostic)
            return '[' .. diagnostic.source .. '] ' .. diagnostic.message
        end,
        scope = 'line',
    }
}