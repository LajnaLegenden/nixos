return {"nvim-treesitter/nvim-treesitter", branch = 'master', lazy = false, build = ":TSUpdate", opts = {
    ensure_installed = {
        "lua",
        "javascript",
        "typescript",
        "jsx",
        "tsx",
        "css",
        "html",
        "json",
        "yaml",
        "markdown",
    },
    auto_install = true,

}}