require('sidebar-nvim').setup({
    open = true, 
    bindings = { ["q"] = function() require("sidebar-nvim").close() end }
})